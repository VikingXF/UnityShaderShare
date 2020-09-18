Shader "Babybus/SSS/LitSss"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_DiffuseWrap ("Diffuse Wrap", Vector) = (0.75, 0.375, 0.1875, 0)
		
		//Directional subsurface Scattering
		_InteriorColor ("Interior Color", Color) = (1,1,1,1)
		_FrontSssDistortion ("Front SSS Distortion", Range(0, 1)) = 0.5
		_BackSssDistortion ("Back SSS Distortion", Range(0, 1)) = 0.5
		_FrontSssIntensity ("Front SSS Intensity", Range(0, 1)) = 0.5
		//_BackSssIntensity ("Back SSS Intensity", Range(0, 1)) = 0.2
		_InteriorColorPower ("Interior Color Power", Range(0, 1)) = 2
		
		//fresnel
		_FresnelPower("Fresnel Power", Range(0, 36)) = 0.1
		_FresnelIntensity("Fresnel Intensity", Range(0, 1)) = 0.2
		
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "IgnoreProjector" = "True" "LightMode" = "ForwardBase" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
		
			#pragma vertex vert
			#pragma fragment frag
			
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;				
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                //UNITY_FOG_COORDS(1)
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				float3 normalDir : TEXCOORD3;
                float4 pos : SV_POSITION;
            };
			
			inline float SubsurfaceScattering(float3 viewDir,float3 lightDir,float3 normalDir,float frontSubsurfaceDistortion,float backSubsurfaceDistortion,float frontSssIntensity)
			{
				float3 frontLitDir = normalDir * frontSubsurfaceDistortion - lightDir ;
				float3 backLitDir = normalDir * backSubsurfaceDistortion + lightDir ;
				
				float frontSSS = saturate(dot(viewDir,-frontLitDir));
				float backSSS = saturate(dot(viewDir,-backLitDir));
				
				float result = saturate(frontSSS*frontSssIntensity +backSSS );
				return result;
			}
			
            sampler2D _MainTex;
            float4 _MainTex_ST;
			float3 _DiffuseWrap;
			float _FresnelPower,_FresnelIntensity;
			float4 _InteriorColor;
			float _FrontSssDistortion,_BackSssDistortion,_FrontSssIntensity,_InteriorColorPower;
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				
				float3 posWorld = mul(unity_ObjectToWorld,v.vertex);
				o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));	
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld);
				o.lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				
				float3 L = normalize(i.lightDir);
				float3 V = normalize(i.viewDir);
				float3 N = normalize(i.normalDir);
				float ldn = dot(L, N);
				
				float diffuseWeightFull = max(ldn, 0.0);
				float diffuseWeightHalf = max(0.5 * ldn + 0.5, 0.0);
				float3 diffuseWeight = lerp(diffuseWeightFull.xxx, diffuseWeightHalf.xxx, _DiffuseWrap);
				float3 diffColor = diffuseWeight * _LightColor0.rgb;
				
				//Directional light SSS
				float sssValue =SubsurfaceScattering(i.viewDir,i.lightDir,i.normalDir,_FrontSssDistortion,_BackSssDistortion,_FrontSssIntensity);
				fixed3 sssCol = lerp(_InteriorColor,_LightColor0,saturate(pow(sssValue,_InteriorColorPower))).rgb*sssValue;
				
				//Fresnel
				float fresnel = 1.0 - max(0,dot(i.normalDir,i.viewDir));
				float fresnelValue = lerp(fresnel,0,sssValue);
				float3 fresnelCol = saturate(lerp(_InteriorColor,_LightColor0.rgb,fresnelValue)*pow(fresnelValue,_FresnelPower) * _FresnelIntensity);
				
				col.rgb = col.rgb*diffColor*1.1+fresnelCol+sssCol;
				
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
	//FallBack "Diffuse"
}
