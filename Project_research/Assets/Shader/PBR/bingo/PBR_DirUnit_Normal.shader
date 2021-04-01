Shader "Babybus/PBR/PBR_DirUnit_Normal"
{
    Properties
    {
		//Basic
		[Header(Basic)]
        _MainTex ("Texture", 2D) = "white" {}
		_Tint ("Tint", Color) = (1,1,1,1)
		
		[Toggle] _Usenormalmap ("Usenormalmap?", Float) = 0
		_BumpMap("Normal Map", 2D) = "bump" {}
		
		//[LightDir]_LightDir("Light Dir" , Vector) = (0,0,-1,0)
		//_LightColor("Light Color", Color) = (1,1,1,1)
		
		//Directional subsurface Scattering
		[Header(Directional subsurface Scattering)]		
		_InteriorColor ("Interior Color", Color) = (1,1,1,1)
		_SssDistortion ("Front SSS Distortion", Range(0, 1)) = 0.5		
		_SssIntensity ("Front SSS Intensity", Range(0, 1)) = 0.5
		_SssDir ("SSS Dir", Range(-1, 1)) = -1
		
		//Specular	
		[Header(Specular)]

		_Specular ("Specular", Range(0, 1)) = 0.5
 		_Gloss ("Gloss", Range(0, 1)) = 0.5
		
		//fresnel
		[Header(Fresnel)]
		
		_FresnelPower("Fresnel Power", Range(0, 36)) = 0.1
		_FresnelIntensity("Fresnel Intensity", Range(0, 1)) = 0.2

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
			Tags { "LightMode"="ForwardBase" }
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog
			
			#include "UnityLightingCommon.cginc"
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight		
			#include "AutoLight.cginc"			
            #include "UnityCG.cginc"
			#pragma shader_feature _USENORMALMAP_ON
			
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
				float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
				//fixed4 diff : COLOR0;
				//float4 posWorld : TEXCOORD1;
	
				float3 viewDir: TEXCOORD1;
				float3 lightDir: TEXCOORD2;	
				
				
				#if _USENORMALMAP_ON	
				float4 TtoW0 : TEXCOORD3;
                float4 TtoW1 : TEXCOORD4;
                float4 TtoW2 : TEXCOORD5;
				SHADOW_COORDS(6)
				#else	
				float3 normalDir: TEXCOORD3;
				SHADOW_COORDS(4)
				#endif

				//SHADOW_COORDS(6)
                //UNITY_FOG_COORDS(5)
				
                float4 vertex : SV_POSITION;
            };
			
	
            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			//half4 _LightDir;
			//float4 _LightColor;
			float4 _Tint,_InteriorColor;
			float _SssDistortion,_SssIntensity,_SssDir;
			float _PointLitRadius;
			float _Specular,_Gloss,_FresnelPower,_FresnelIntensity;
	
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				
					
				#if _USENORMALMAP_ON	
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float4 worldTangent = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
				half sign = worldTangent.w * unity_WorldTransformParams.w;
                float3 worldBinormal = cross(worldNormal, worldTangent) * sign;
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
				#else	
				o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));
				#endif
				
				float4 posWorld = mul(unity_ObjectToWorld,v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _BumpMap);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld.xyz);
				o.lightDir = normalize(_WorldSpaceLightPos0.xyz);
				//o.lightDir = normalize(-_LightDir.xyz);				
			
				TRANSFER_SHADOW(o)   //for shadow
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv.xy)*_Tint;
				
				#if _USENORMALMAP_ON
				fixed3 normal =UnpackNormal(tex2D(_BumpMap,i.uv.zw));
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
                normal = normalize(half3(dot(i.TtoW0.xyz, normal), dot(i.TtoW1.xyz, normal), dot(i.TtoW2.xyz, normal)));    
				
				#else				
				fixed3 normal = i.normalDir;
				
				#endif
				
				//Diffuse
				half nl = max(0,dot(normal,_WorldSpaceLightPos0.xyz));
				fixed4 diff = nl * _LightColor0;
				diff.rgb += ShadeSH9(half4(normal,1));


				//Directional light SSS
	
				float3 frontLitDir = normal * _SssDistortion + _SssDir*i.lightDir ;				
				float frontSSS = saturate(dot(i.viewDir,-frontLitDir));
				float sssValue = saturate(frontSSS*_SssIntensity);				
				fixed3 sssCol = lerp(_InteriorColor,_LightColor0,sssValue).rgb*sssValue;

				//Diffuse2
				fixed4 unlitCol = col*0.5;
				
				fixed shadow = SHADOW_ATTENUATION(i); //recieve shadow
				fixed4 diffCol = lerp(unlitCol,col,diff * shadow);
				//fixed4 diffCol = lerp(unlitCol, col, diff);
				
				//Specular				
				float specularPow = exp2((1 - _Gloss)* 10.0 +1.0);
				float3 specularCol = float3(_Specular,_Specular,_Specular);
				
				float3 halfVector = normalize(i.lightDir + i.viewDir);
				float3 directSpecular = pow(max(0,dot(halfVector,normalize(normal))),specularPow)*specularCol;
				float3 specular = directSpecular *_LightColor0.rgb;
				
				//Fresnel
				float fresnel = 1.0 - max(0,dot(normal,i.viewDir));
				float fresnelValue = lerp(fresnel,0,sssValue);
				float3 fresnelCol = saturate(lerp(_InteriorColor,_LightColor0.rgb,fresnelValue)*pow(fresnelValue,_FresnelPower) * _FresnelIntensity);
				
				//final color
				fixed3 final = sssCol+diffCol.rgb +specular +fresnelCol;
				//final = fresnelCol;
				
				
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, final);

                return fixed4(final,1);
            }
            ENDCG
        }
		//Cast Shadow
		Pass
        {
			Tags { "LightMode"="ShadowCaster" }
			
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct v2f
            {
                V2F_SHADOW_CASTER;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
