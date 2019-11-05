Shader "Unlit/BasicDiffuse"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_RampTex ("RampTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        
            CGPROGRAM

            #pragma surface surf BasicDiffuse

			sampler2D _MainTex, _RampTex;
			

			inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir,half3 viewDir, fixed atten)
			{
				float4 col = float4(1,1,1,1);
				//float difLight = max(0, dot(s.Normal, lightDir));
				float difLight = dot(s.Normal, lightDir);
				float rimfLight = dot(s.Normal, viewDir);
				float hLambert = difLight * 0.5 + 0.5;
				float3 ramp = tex2D(_RampTex, float2(hLambert, rimfLight)).rgb;
				
				col.rgb = s.Albedo *_LightColor0*(ramp);
				return col;
			}

			struct Input {
				float2 uv_MainTex;
			};

			void surf(Input IN, inout SurfaceOutput o) {

				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}

            ENDCG
        
    }
}
