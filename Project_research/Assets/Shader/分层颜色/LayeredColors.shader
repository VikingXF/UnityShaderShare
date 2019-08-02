Shader "Babybus/Special/LayeredColors"
{
	Properties
	{
		_FirstColor("FirstColor", Color) = (0.5,0.5,0.5,1)
		_SecondColor("SecondColor", Color) = (0.5,0.5,0.5,1)
		_ThirdColor("ThirdColor", Color) = (0.5,0.5,0.5,1)
		_FourColor("FourColor", Color) = (0.5,0.5,0.5,1)
		_Layer("Layer",vector) = (0.3,0.4,0.7,1)
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
			//#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			fixed4 _FirstColor,_SecondColor,_ThirdColor,_FourColor;					
			fixed4 _Layer;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = _FirstColor;
				int index1 =step(i.uv.x,_Layer.x);
				int index2 =step(i.uv.x,_Layer.y);
				int index3 =step(i.uv.x,_Layer.z);
				
				col.rgb =_FirstColor*index1+_SecondColor*(1-index1)*index2+_ThirdColor*(1-index2)*index3+ _FourColor*(1-index3);

				
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
				
				
			}
			ENDCG
		}
	}
}
