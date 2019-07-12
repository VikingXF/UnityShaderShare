// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'



Shader "Babybus/BeautyShop/lerp-ColorTransparentt" {
Properties {
	_FirstTex ("FirstTex", 2D) = "white" {}
	_FirstColor ("FirstColor", Color) = (1,1,1,1)
	_SecondTex ("SecondTex", 2D) = "white" {}
	_SecondColor ("SecondColor", Color) = (1,1,1,1)
	_AlphaTex("AlphaTex", 2D) = "white" {}
	_LerpTex ("LerpTex", 2D) = "white" {}
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
				half2 texcoord : TEXCOORD0;

			};

			sampler2D _FirstTex,_SecondTex,_LerpTex,_AlphaTex;
			float4 _FirstTex_ST;
			fixed4 _FirstColor,_SecondColor;
			fixed _Switch;
			fixed _RR;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _FirstTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed Alphacol = tex2D(_AlphaTex, i.texcoord).a;
				fixed4 Firstcol = tex2D(_FirstTex, i.texcoord)*_FirstColor;//
				fixed4 Secondcol = tex2D(_SecondTex, i.texcoord)*_SecondColor;//
				fixed4 Lerpcol = tex2D(_LerpTex, i.texcoord);
				Secondcol.a = lerp(Secondcol.a,Alphacol,_Switch);
			    Secondcol.a = lerp(Firstcol.a, Secondcol.a, Lerpcol.r - 1 + _SecondColor.a);
				return Secondcol;
			}
		ENDCG
	}
}

}
