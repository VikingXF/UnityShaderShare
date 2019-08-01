Shader "Babybus/UV2Modle"
{
	Properties
	{
		
		_Color("Color",Color) = (1,1,1,1)
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

				float4 vertex : SV_POSITION;
				float4 ov : TEXCOORD0;
			};

		
			float4 _Color;
			v2f vert (appdata v)
			{
				v2f o;				
				o.ov = UnityObjectToClipPos(float4(v.uv, 0, 1));
				o.vertex = UnityObjectToClipPos(v.vertex);
		
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col = i.ov;

				return col;
			}
			ENDCG
		}
	}
}
