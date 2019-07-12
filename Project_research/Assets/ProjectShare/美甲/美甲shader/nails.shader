// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/BeautyShop/nails" {
Properties {
	[KeywordEnum(First, Second)] _Steps ("操作步骤", Float) = 0
	_RoughTex ("粗糙指甲贴图", 2D) = "white" {}
	_AlphaTex ("修好的指甲透明贴图", 2D) = "white" {}
	_Switch ("修剪指甲", Range(0, 1)) = 0
	
	_LerpTex ("LerpTex", 2D) = "white" {}
	
	_FirstColor ("FirstColor", Color) = (1,1,1,1) 
	
	
	_SecondTex ("SecondTex", 2D) = "white" {}	
	
	_shadow ("shadow", 2D) = "white" {}
	
	_Flower ("Flower", 2D) = "white" {}
	
	_highlights ("highlights", 2D) = "white" {}
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
			#pragma shader_feature _STEPS_FIRST _STEPS_SECOND
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

			sampler2D _RoughTex,_AlphaTex,_LerpTex,_shadow,_highlights,_Flower,_SecondTex;
			float4 _RoughTex_ST;
			fixed _Switch;
			float4 _FirstColor;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _RoughTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 Alphacol = tex2D(_AlphaTex, i.texcoord);
				
				
				fixed4 shadowcol = tex2D(_shadow, i.texcoord);
				fixed4 highlightscol = tex2D(_highlights, i.texcoord);
				
				fixed4 Firstcol = Alphacol*_FirstColor;												
											
				//第一操作步骤(剪指甲跟磨指甲)
				#if _STEPS_FIRST
				fixed4 Roughcol = tex2D(_RoughTex, i.texcoord);			
				//剪指甲操作				
				Roughcol.a = lerp(Roughcol.a,Alphacol.a,_Switch);	
				//磨指甲操作
				fixed4 Lerpcol = tex2D(_LerpTex, i.texcoord);
				
				fixed3 Firstshadow = shadowcol.rgb *_FirstColor;
				Firstcol.rgb = lerp(Firstcol.rgb,Firstcol.rgb*(1-shadowcol.a)*Firstshadow,shadowcol.a);
				
				Firstcol.rgb = lerp(Firstcol.rgb,highlightscol.rgb,highlightscol.a);
				
				Firstcol.rgb = lerp(Roughcol.rgb,Firstcol.rgb,saturate(1-Lerpcol.r+Firstcol.a));				 
				fixed4 col = Firstcol;
				col.a = Roughcol.a;
				
				//第二操作步骤(涂不同颜色指甲油)
				#elif _STEPS_SECOND
				fixed4 Secondcol = tex2D(_SecondTex, i.texcoord);				
				fixed4 Flowercol = tex2D(_Flower, i.texcoord);
				
				fixed4 col = lerp(lerp(Firstcol,Secondcol,Secondcol.a),Flowercol,Flowercol.a);
				fixed3 shadowcol2 = shadowcol.rgb *_FirstColor;
				col.rgb = lerp(col.rgb,col.rgb*(1-shadowcol.a)*shadowcol2,shadowcol.a);	
				col.rgb = lerp(col.rgb,highlightscol.rgb,highlightscol.a);
				col.a = Alphacol.a-1+_FirstColor.a;			
				#endif

				return col;
			}
		ENDCG
	}
}

}
