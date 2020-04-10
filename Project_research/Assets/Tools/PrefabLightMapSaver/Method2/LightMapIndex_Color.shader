Shader "Babybus/Mobile/LightMapIndex_Color"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("MainColor", COLOR) = (1,1,1,1)
		//_LightMap("LightMap", 2D) = "white" {}

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
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _LightMap;			
			float4 _LightmapST;			
			float4 _MainColor;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = v.uv2.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 Color = tex2D(_MainTex, i.uv.xy)*_MainColor;

				fixed4 lmColor = tex2D(_LightMap, i.uv.zw);
				fixed3 lm = DecodeLightmap(lmColor);
				
				Color.rgb *= lm;
		
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, Color);
				return Color;
			}
			ENDCG
		}
	}
}
