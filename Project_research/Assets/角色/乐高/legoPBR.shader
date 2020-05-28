Shader "PBR/legoPBR"
{
    Properties
    {
		//Basic
        _BasicColAndRoughnessTex ("Basic color & Roughness Texture", 2D) = "white" {}
		_InteriorColAndSpecularTex ("Interior color & Specular Texture", 2D) = "white" {}
		_Tint ("Tint", Color) = (1,1,1,1)
		
		//Specular		
		_SpecularRate ("Specular Rate", Range(1, 5)) = 1 
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		
		//Directional subsurface Scattering
		_FrontSssDistortion ("Front SSS Distortion", Range(0, 1)) = 0.5
		_BackSssDistortion ("Back SSS Distortion", Range(0, 1)) = 0.5
		_FrontSssIntensity ("Front SSS Intensity", Range(0, 1)) = 0.5
		_BackSssIntensity ("Back SSS Intensity", Range(0, 1)) = 0.5
		_InteriorColorPower ("Interior Color Power", Range(0, 1)) = 0.5
		
		//Light
		_UnlitRate ("Unlit Rate", Range(0, 1)) = 0.5
		_AmbientLight ("Ambient Light", Color) = (0.5,0.5,0.5,1)
		
		//fresnel
		_FresnelPower("Fresnel Power", Range(0, 36)) = 0.1
		_FresnelIntensity("Fresnel Intensity", Range(0, 1)) = 0.2
		
		//side Rim
		_RimColor ("Rim Color", Color) = (0.5,0.5,0.5,1)	
		_RimIntensity("Rim Intensity", Range(0, 1)) = 0.2
		_RimLightSampler("Rim Mask", 2D) = "white" {}
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
            #pragma multi_compile_fog
			
			#include "UnityLightingCommon.cginc"			
			#include "AutoLight.cginc"
			
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float4 posWorld : TEXCOORD1;
				float3 normalDir: TEXCOORD2;
				float3 viewDir: TEXCOORD3;
				float3 lightDir: TEXCOORD4;
				SHADOW_COORDS(5)				
                UNITY_FOG_COORDS(6)
                float4 vertex : SV_POSITION;
            };

            sampler2D _BasicColAndRoughnessTex;
            float4 _BasicColAndRoughnessTex_ST;
			sampler2D _InteriorColAndSpecularTex;
			sampler2D _RimLightSampler;
			sampler2D _NoiseTex;	
			float4 _Tint,_RimColor,_AmbientLight;		
			float _FrontSssDistortion,_BackSssDistortion,_FrontSssIntensity,_BackSssIntensity,_InteriorColorPower;
			float _SpecularRate,_UnlitRate,_FresnelPower,_FresnelIntensity,_RimIntensity;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld,v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BasicColAndRoughnessTex);
				
				o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - o.posWorld.xyz);
				o.lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				TRANSFER_SHADOW(o)   //for shadow
				
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			inline float SubsurfaceScattering(float3 viewDir,float3 lightDir,float3 normalDir,float frontSubsurfaceDistortion,float backSubsurfaceDistortion,float frontSssIntensity)
			{
				float3 frontLitDir = normalDir * frontSubsurfaceDistortion - lightDir ;
				float3 backLitDir = normalDir * backSubsurfaceDistortion + lightDir ;
				
				float frontSSS = saturate(dot(viewDir,-frontLitDir));
				float backSSS = saturate(dot(viewDir,-backLitDir));
				
				float result = saturate(frontSSS*frontSssIntensity +backSSS );
				return result;
			}			
			
            fixed4 frag (v2f i) : SV_Target
            {
				//common data
				float3 NdotL = dot(i.normalDir,i.lightDir);
				float3 NdotV = dot(i.normalDir,i.viewDir);
				fixed atten = SHADOW_ATTENUATION(i); //recieve shadow
				
				float lightRate = saturate((_LightColor0.x+_LightColor0.y+_LightColor0.z)/3); 
				float lightingValue = saturate(NdotL.x*atten) *lightRate;
				float4 lightcol = lerp(_LightColor0,fixed4(1,1,1,1),0.6);
								
                // sample the texture
                fixed4 col = tex2D(_BasicColAndRoughnessTex, i.uv)*_Tint;
				fixed noise = tex2D(_NoiseTex, float2(i.posWorld.x,i.posWorld.y)).x;
				fixed4 interiorSpecularcol = tex2D(_InteriorColAndSpecularTex, i.uv);
				
				//Directional light SSS
				float sssValue =SubsurfaceScattering(i.viewDir,i.lightDir,i.normalDir,_FrontSssDistortion,_BackSssDistortion,_FrontSssIntensity);
				
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col*sssValue;
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
