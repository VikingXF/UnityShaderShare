// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/BeautyShop/nails2" {
Properties {
	_FirstTex ("FirstTex", 2D) = "white" {}
	_FirstColor ("MainColor", Color) = (1,1,1,1) 
	_SecondTex ("SecondTex", 2D) = "white" {}
	_SecondColor ("SecondColor", Color) = (1,1,1,1)
	_LerpTex ("LerpTex", 2D) = "white" {}
	_shadow ("shadow", 2D) = "white" {}
	_Switch ("_Switch", Range(0, 1)) = 0
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

			sampler2D _FirstTex,_SecondTex,_shadow,_LerpTex;
			float4 _FirstTex_ST,_SecondTex_ST;
			float4 _FirstColor,_SecondColor;
			fixed _Switch;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _FirstTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _SecondTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 shadowcol = tex2D(_shadow, i.texcoord.xy);
				fixed4 Firstcol = tex2D(_FirstTex, i.texcoord.xy)*_FirstColor;
				fixed3 Firstshadow = shadowcol.rgb *_FirstColor;
				Firstcol.rgb = lerp(Firstcol.rgb,Firstcol.rgb*(1-shadowcol.a)*Firstshadow,shadowcol.a);	
				
				
				fixed4 Secondcol = tex2D(_SecondTex, i.texcoord.zw)*_SecondColor;
				fixed3 Secondshadow = shadowcol.rgb *_SecondColor;
				Secondcol.rgb = lerp(Secondcol,lerp(Secondcol.rgb,Secondcol.rgb*(1-shadowcol.a)*Secondshadow,shadowcol.a),_Switch);
				
				fixed4 Lerpcol = tex2D(_LerpTex, i.texcoord.xy);
				
				fixed4 col = lerp(Firstcol,Secondcol,Lerpcol.a);
				


				return col	;
			}
		ENDCG
	}
}

}
