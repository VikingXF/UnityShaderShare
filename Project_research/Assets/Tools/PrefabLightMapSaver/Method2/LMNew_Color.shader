Shader "LM/LM1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("MainColor", COLOR) = (1,1,1,1)
		_LightMapA("LightMapA", 2D) = "white" {}
		_LightMapB("LightMapB", 2D) = "white" {}
		_LMMixValue("MixValue", range(0, 1)) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"
			#include "UnityLightingCommon.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				#ifndef LIGHTMAP_OFF 
				float2 lmuv:TEXCOORD2;
				#endif
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _LightMapA;
			sampler2D _LightMapB;			
			half _LMMixValue;
			float4 _MainColor;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				#ifndef LIGHTMAP_OFF
				o.lmuv = v.uv2.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 finalColor = tex2D(_MainTex, i.uv);
				#ifndef LIGHTMAP_OFF
				fixed4 lmCA = tex2D(_LightMapA, i.lmuv);
				fixed3 lmA = DecodeLightmap(lmCA);
				fixed4 lmCB = tex2D(_LightMapB, i.lmuv);
				fixed3 lmB = DecodeLightmap(lmCB);
				fixed3 lm = lerp(lmA, lmB, smoothstep(0, 1, _LMMixValue));
				finalColor.rgb *= lm;
				#endif		
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, finalColor);
				return finalColor*_MainColor;
			}
			ENDCG
		}
	}
}
