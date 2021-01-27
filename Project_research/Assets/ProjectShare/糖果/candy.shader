﻿
/*
结冰shader，
1.根据噪音图以及Blend值控制结冰的区域，
2.在结冰位置的边缘以及菲涅尔反射的地方会更亮
3.结冰的地方顶点会凸起
4.使用自定义灯光方向

ps.如果使用顶点挤出请让美术建模的时候要注意统一法线方向，同一顶点的法线尽量统一，否则会破面
*/

Shader "Babybus/Special/candy"
{
	Properties
	{
		_Color ("Color(RGB)", Color) = (1,1,1,1)//主纹理颜色
		_MainTex ("Texture(RGB)", 2D) = "white" {}//主纹理
		_FrozenNorm("Frozen Normal Map(RGB)", 2D) = "bump" {} //冰法线纹理
		_FrozenNorPow("Frozen Normal Power" , Range(0,2)) = 1//冰法线纹理强度
		_FrozenSqueeze("Frozen Squeeze" , Range(0,1)) = 0.15
		_FrozenColor("Frozen Color(RGBA)", Color) = (0,0.5,1,0.2)//冰颜色
		_FrozenSpecular ("Frozen Specular",Range(0, 8) ) = 1//冰高光强度
        _FrozenGloss ("Frozen Gloss", Range(0, 1)) = 0.6//冰金属度
		_Fresnel("Fresnel", Range(0.2, 10)) = 3//菲涅尔
		_LightColor("Light Color", Color) = (1,1,1,1)//灯光颜色
		_LightDir("Light Direction" , vector) = (-1,1,1,1)//灯光方向&强度（W值控制灯光的强度）

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha 
		Pass
		{
		    Name "FREEZE"
            Tags {"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
            #include "UnityCG.cginc"  



			struct a2v
			{
				half4 vertex : POSITION;
				half3 normal :NORMAL;
				half4 tangent : TANGENT; 
				half2 uv : TEXCOORD0;
			};

			struct v2f
			{
				half4 pos : SV_POSITION;
				half4 uv : TEXCOORD0;
                half4 worldPos : TEXCOORD1;  
                half3 normalDir : TEXCOORD2;  
                half3 tangentDir : TEXCOORD3; 
				half3 bitangentDir: TEXCOORD4;  
				UNITY_FOG_COORDS(5)

			};

			sampler2D _MainTex , _FrozenNorm ;
			half4 _MainTex_ST , _FrozenNorm_ST;
			fixed4 _FrozenColor , _Color , _LightColor;

			half _FrozenSpecular;  
            half _FrozenGloss; 
			half _FrozenNorPow;
			half _FrozenSqueeze;
			half _Fresnel;
			half4 _LightDir;


			v2f vert (a2v v)
			{
				v2f o;

				//计算主纹理和冰冻效果法线的UV
				o.uv.xy = TRANSFORM_TEX (v.uv, _MainTex);  
				o.uv.zw = TRANSFORM_TEX (v.uv, _FrozenNorm); 

				o.pos = UnityObjectToClipPos(v.vertex);

				o.normalDir = UnityObjectToWorldNormal(v.normal);
				o.tangentDir = normalize(mul(unity_ObjectToWorld , float4(v.tangent.xyz, 0)).xyz);
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, normalize(i.normalDir));//转换矩阵
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));//视线方向
				half3 worldLightDir = normalize(_LightDir.xyz); //灯光方向（面板上指定）
				half3 halfDir =normalize(worldLightDir + worldViewDir); //半角方向

				fixed4 col = tex2D(_MainTex, i.uv.xy) * _Color;//主纹理采样

				half3 norm = normalize(UnpackNormal(tex2D(_FrozenNorm, i.uv.zw)) * float3(_FrozenNorPow,_FrozenNorPow,1)); //法线采样
				half3 worldNormal = normalize(mul( norm, tangentTransform ));//把法线转换到世界空间

				//把_FrozenGloss的值从0~1映射到2 ~ 2048
				half gloss = exp2(_FrozenGloss * 10 + 1);


				//计算高光
				half3 spec = _LightColor.rgb * pow(saturate(dot(halfDir,worldNormal)),gloss) * _FrozenSpecular;

				//计算结冰部分颜色
				fixed3 fresnel  = _FrozenColor * pow(1-saturate(dot(worldViewDir , worldNormal)) , _Fresnel) ;
				fixed3 frozenCol = fresnel + spec ;

				//混合；color*color*2是暴雪分享的一个特效算法，可以让颜色更鲜艳
				col.rgb += frozenCol*frozenCol*2 ;
	
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
