Shader "Shadow/DeapthTextureShader"
{
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 depth : TEXCOORD1;
			};

			 v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				// o.depth = o.vertex.zw;
				o.depth = COMPUTE_DEPTH_01;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// float depth = i.depth.x / i.depth.y;
				float depth = i.depth;
			// fixed4 col = EncodeFloatRGBA(depth);
			fixed4 col = EncodeFloatRGBA(min(depth, 0.9999991));
			return col;
		}
		ENDCG
	}
	}
}

