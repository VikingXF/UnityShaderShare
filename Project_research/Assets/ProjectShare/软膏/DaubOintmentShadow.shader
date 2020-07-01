// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/Makeup/DaubOintmentShadow" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_TexRGB ("TexRGB", Color) = (1,1,1,1)  
	_MaskTex ("Mask RT", 2D) = "white" {}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex,_MaskTex;
			float4 _MainTex_ST;
			float4 _TexRGB;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				fixed4 Maskcol = tex2D(_MaskTex, i.texcoord);
				col.a = saturate(_TexRGB.a*(col.a-Maskcol.r));
				col.rgb *=_TexRGB.rgb;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
}

}
