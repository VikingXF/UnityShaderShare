Shader "Babybus/Special/Ice_Sky"
{
	Properties
	{
		_Color ("Color(RGB)", Color) = (1,1,1,1)//主纹理颜色
		_MainTex ("Texture", 2D) = "white" {} //主纹理
		_FrozenNorm("Frozen Normal Map(RGB)", 2D) = "bump" {} //冰法线纹理
		_FrozenNorPow("Frozen Normal Power" , Range(0,2)) = 1//冰法线纹理强度
		
		_FrozenSpecular ("Frozen Specular",Range(0, 8) ) = 1//冰高光强度
		_FrozenGloss ("Frozen Gloss", Range(0, 1)) = 0.6//冰金属度
		 
		_RimColor("Rim Color", Color) = (0.5,0.5,0.5,1)  
		_RimPower("Rim Power", Range(0.0, 5)) = 0.1 
		_RimIntensity("Rim Intensity", Range(0.0, 10)) = 3 
		
		_LightColor("Light Color", Color) = (1,1,1,1)//灯光颜色
		_LightDir("Light Direction" , vector) = (-1,1,1,1)//灯光方向&强度（W值控制灯光的强度）
		
		_Sky("反射天空盒", 2D) = "" {}
		//_Sky("反射天空盒", cube) = "" {}
		_Fresnel("反射菲涅尔系数", Range(0.0, 1)) = 0
	}
	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
	
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha 

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(5)
				float4 vertex : SV_POSITION;
				
				half4 worldPos : TEXCOORD1;  
                half3 normalDir : TEXCOORD2;  
                half3 tangentDir : TEXCOORD3; 
				half3 bitangentDir: TEXCOORD4; 

				//float NdotV:COLOR;
			};

			sampler2D _MainTex,_FrozenNorm;
			float4 _MainTex_ST,_FrozenNorm_ST;
			float4 _RimColor,_Color,_LightColor;
            float _RimPower,_RimIntensity;
			half _FrozenNorPow;
			half _FrozenGloss,_FrozenSpecular; 
			float4 _LightDir;
			//samplerCUBE _Sky;
			sampler2D _Sky;
			half _Fresnel;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX (v.uv, _FrozenNorm); 
					
				o.normalDir = UnityObjectToWorldNormal(v.normal);
				o.tangentDir = normalize(mul(unity_ObjectToWorld , float4(v.tangent.xyz, 0)).xyz);
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				

				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, normalize(i.normalDir));//转换矩阵
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));//视线方向
				half3 worldLightDir = normalize(_LightDir.xyz); //灯光方向（面板上指定）
				half3 halfDir =normalize(worldLightDir + worldViewDir); //半角方向
				
				
				
				
				
				// 主纹理
				fixed4 col = tex2D(_MainTex, i.uv.xy)*_Color;
				//法线贴图				
				half3 norm = normalize(UnpackNormal(tex2D(_FrozenNorm, i.uv.zw)) * float3(_FrozenNorPow,_FrozenNorPow,1)); //法线采样
				half3 worldNormal = normalize(mul( norm, tangentTransform ));//把法线转换到世界空间
				
				//计算高光
				//把_FrozenGloss的值从0~1映射到2 ~ 2048
				half gloss = exp2(_FrozenGloss * 10 + 1);
				half3 spec = _LightColor.rgb * pow(saturate(dot(halfDir,worldNormal)),gloss) * _FrozenSpecular;
				
				//RIM
				float NdotV = saturate(dot(worldNormal,worldViewDir));
				fixed3 fresnel = pow((1-NdotV) ,_RimPower)* _RimColor.rgb *_RimIntensity*_RimColor.a;
				 
				col.rgb += spec+fresnel;
				
				//采样反射天空盒	
				half3 refl = reflect(-worldViewDir, i.normalDir);
				//col.rgb = lerp(texCUBE(_Sky, refl), col.rgb, _Fresnel);
				col.rgb = lerp(tex2D(_Sky, refl), col.rgb, _Fresnel);
				
				// apply fog

				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
