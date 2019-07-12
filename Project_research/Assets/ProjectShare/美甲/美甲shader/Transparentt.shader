// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/BeautyShop/Transparent" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_MainColor ("MainColor", Color) = (1,1,1,1) 
	_Flower ("Flower", 2D) = "white" {}
	_shadow ("shadow", 2D) = "white" {}
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
				half4 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex,_Flower,_shadow;
			float4 _MainTex_ST,_Flower_ST;
			float4 _MainColor;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _Flower);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord.xy);
				fixed4 Flowercol = tex2D(_Flower, i.texcoord.zw);
				fixed4 shadowcol = tex2D(_shadow, i.texcoord.xy);				
				col.rgb = _MainColor.rgb*col.rgb;
				col.rgb = lerp(col.rgb,Flowercol.rgb,Flowercol.a);			
				shadowcol.rgb = shadowcol.rgb*_MainColor.rgb;
				col.rgb = lerp(col.rgb,col.rgb*(1-shadowcol.a)*shadowcol.rgb,shadowcol.a);
				
				UNITY_APPLY_FOG(i.fogCoord, col);
				
				col.a *=_MainColor.a;
				return col;
			}
		ENDCG
	}
}

}
