// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Babybus/Unlit/Mask Blend Texture2"
{
	Properties
	{
		_FirstTex ("FirstTex", 2D) = "white" {}
		_SecondTex ("SecondTex", 2D) = "white" {}
		
		_Degree("degree",Range(-0.1,1))=0
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
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _FirstTex,_SecondTex;
			float4 _FirstTex_ST;
			fixed _Degree;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _FirstTex);			
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{				
				fixed4 col;				
				fixed4 col1 = tex2D(_FirstTex, i.uv);
				fixed4 col2 = tex2D(_SecondTex, i.uv);
				fixed gree = saturate((i.uv.y - _Degree)*10);
				if(i.uv.y < _Degree)
					return col = col2; 
				else
					return col = lerp(col2,col1, gree);
				//fixed4 col=lerp(col1,col2, _Degree);
				return col;
			}
			ENDCG
		}
	}
}
