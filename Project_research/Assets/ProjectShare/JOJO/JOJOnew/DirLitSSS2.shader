Shader "Babybus/SSS/DirLitSSS2"
{
    Properties
    {
		//Basic
		[Header(Basic)]
        _MainTex ("Texture", 2D) = "white" {}
		_Tint ("Tint", Color) = (1,1,1,1)
		
		//[LightDir]_LightDir("Light Dir" , Vector) = (0,0,-1,0)
		//_LightColor("Light Color", Color) = (1,1,1,1)
		[Header(Directional subsurface Scattering)]		
		//Directional subsurface Scattering
		_InteriorColor ("Interior Color", Color) = (1,1,1,1)
		_FrontSssDistortion ("Front SSS Distortion", Range(0, 1)) = 0.5
		_FrontSssIntensity("Front SSS Intensity", Range(0, 1)) = 0.5
		_BackSssDistortion ("Back SSS Distortion", Range(0, 1)) = 0.5	
		_BackSssIntensity ("Back SSS Intensity", Range(0, 1)) = 0.2
		_InteriorColorPower ("Interior Color Power", Range(0, 1)) = 2
		
		//Specular	
		[Header(Specular)]
		_Specular ("Specular", Range(0, 1)) = 0.5
 		_Gloss ("Gloss", Range(0, 1)) = 0.5
		
		//fresnel
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
			//#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight		
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
				fixed4 diff : COLOR0;
				//float4 posWorld : TEXCOORD1;
				float3 normalDir: TEXCOORD1;
				float3 viewDir: TEXCOORD2;
				float3 lightDir: TEXCOORD3;											
                //UNITY_FOG_COORDS(5)
				//SHADOW_COORDS(6)
                float4 vertex : SV_POSITION;
            };
			
			
			
			
            sampler2D _MainTex;
            float4 _MainTex_ST;
			//half4 _LightDir;
			//float4 _LightColor;
			float4 _Tint,_InteriorColor;
			float _FrontSssDistortion,_BackSssDistortion,_FrontSssIntensity,_BackSssIntensity,_InteriorColorPower;
			float _PointLitRadius;
			float _Specular,_Gloss,_FresnelPower,_FresnelIntensity;

			inline float SubsurfaceScattering(float3 viewDir,float3 lightDir,float3 normalDir,float frontSubsurfaceDistortion,float backSubsurfaceDistortion,float frontSssIntensity)
			{
				float3 frontLitDir = normalDir * frontSubsurfaceDistortion - lightDir ;
				float3 backLitDir = normalDir * backSubsurfaceDistortion + lightDir ;
				
				float frontSSS = saturate(dot(viewDir,-frontLitDir));
				float backSSS = saturate(dot(viewDir,-backLitDir));
				
				float result = saturate(frontSSS*frontSssIntensity +backSSS );
				return result;
			}
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));
				float4 posWorld = mul(unity_ObjectToWorld,v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld.xyz);
				o.lightDir = normalize(_WorldSpaceLightPos0.xyz);
				//o.lightDir = normalize(-_LightDir.xyz);
				//Diffuse
				half nl = max(0,dot(o.normalDir,_WorldSpaceLightPos0.xyz));
				o.diff = nl * _LightColor0;
				o.diff.rgb += ShadeSH9(half4(o.normalDir,1));
				
				//TRANSFER_SHADOW(o)   //for shadow
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv)*_Tint;
				
				
				//Directional light SSS
				float sssValue =SubsurfaceScattering(i.viewDir,i.lightDir,i.normalDir,_FrontSssDistortion,_BackSssDistortion,_FrontSssIntensity);
				fixed3 sssCol = lerp(_InteriorColor,_LightColor0,saturate(pow(sssValue,_InteriorColorPower))).rgb*sssValue;
				//sssCol*=_BackSssIntensity;
					

				//Diffuse2
				fixed4 unlitCol = col * _InteriorColor *0.5;
				//fixed atten = SHADOW_ATTENUATION(i); //recieve shadow
				//fixed4 diffCol = lerp(unlitCol,col,i.diff * atten);
				fixed4 diffCol = lerp(unlitCol, col, i.diff);
				//Specular				
				float specularPow = exp2((1 - _Gloss)* 10.0 +1.0);
				float3 specularCol = float3(_Specular,_Specular,_Specular);
				
				float3 halfVector = normalize(i.lightDir + i.viewDir);
				float3 directSpecular = pow(max(0,dot(halfVector,normalize(i.normalDir))),specularPow)*specularCol;
				float3 specular = directSpecular *_LightColor0.rgb;
				
				//Fresnel
				float fresnel = 1.0 - max(0,dot(i.normalDir,i.viewDir));
				float fresnelValue = lerp(fresnel,0,sssValue);
				float3 fresnelCol = saturate(lerp(_InteriorColor,_LightColor0.rgb,fresnelValue)*pow(fresnelValue,_FresnelPower) * _FresnelIntensity);
				
				//final color
				fixed3 final = sssCol +diffCol.rgb +specular +fresnelCol;
				
				//final += pointLitSssCol *final;
				
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, final);
                return fixed4(final,1);
            }
            ENDCG
        }
		//Cast Shadow
		/*Pass
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
        }*/
    }
}
