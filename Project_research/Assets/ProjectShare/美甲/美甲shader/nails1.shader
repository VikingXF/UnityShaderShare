// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/BeautyShop/nails1" {
Properties {
	_AlphaTex ("AlphaTex", 2D) = "white" {}
	_FirstColor ("MainColor", Color) = (1,1,1,1) 
	_SecondTex ("SecondTex", 2D) = "white" {}	
	_shadow ("shadow", 2D) = "white" {}
	_Flower ("Flower", 2D) = "white" {}
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

			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half4 texcoord : TEXCOORD0;

			};

			sampler2D _AlphaTex,_SecondTex,_shadow,_Flower;
			float4 _AlphaTex_ST,_SecondTex_ST;
			float4 _FirstColor;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _AlphaTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _SecondTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 Alphacol = tex2D(_AlphaTex, i.texcoord);							
				fixed4 shadowcol = tex2D(_shadow, i.texcoord.xy);
				fixed4 Flowercol = tex2D(_Flower, i.texcoord.xy);
				
				fixed4 Firstcol = Alphacol*_FirstColor;				
				fixed4 Secondcol = tex2D(_SecondTex, i.texcoord.zw);

				fixed4 col = lerp(lerp(Firstcol,Secondcol,Secondcol.a),Flowercol,Flowercol.a);
				fixed3 shadowcol2 = shadowcol.rgb *_FirstColor;
				col.rgb = lerp(col.rgb,col.rgb*(1-shadowcol.a)*shadowcol2,shadowcol.a);	

				col.a = Alphacol.a-1+_FirstColor.a;


				return col	;
			}
		ENDCG
	}
}

}
