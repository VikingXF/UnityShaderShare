// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Babybus/lightmap/projectorShadow_Static"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlendlightTex ("BlendlightTex", 2D) = "white" {}
		_ShadowColor ("影子颜色", Color) = (1,1,1,1)//阴影颜色
		_LightIntensity("亮部强度", Range(0.0, 5.0)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

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
				float2 uv1 : TEXCOORD1;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(2)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BlendlightTex;
			float4 _BlendlightTex_ST;
			float4x4 unity_Projector;
			float4 _ShadowColor;
			fixed _LightIntensity;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				//o.uv.zw = TRANSFORM_TEX(v.uv1,_BlendlightTex);
				float4 pos = mul(unity_Projector,mul(unity_ObjectToWorld, v.vertex));				
				o.uv.zw =float2(pos.x / pos.w, pos.y / pos.w)*_BlendlightTex_ST.xy+_BlendlightTex_ST.zw;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv.xy);
				fixed4 Blendcol = tex2D(_BlendlightTex, i.uv.zw);
				
				Blendcol.rgb = lerp(_ShadowColor.rgb+_ShadowColor.a,_LightIntensity,Blendcol.r);
				col.rgb *= Blendcol.rgb;
				
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
	fallback "Babybus/Unlit/Texture"
}
