// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/UV Wireframe Shader"
{
	Properties
	{
		_LineColor("Line Color", Color) = (1, 1, 1, 1)
		_GridColor("Grid Color", Color) = (0, 0, 0, 1)
		_LineWidth("Line Width", float) = 0.05
	}

		SubShader
	{
		Tags{ "Queue" = "Transparent+100" "RenderType" = "Transparent" }
		LOD 200
		Pass
		{

			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform float4 _LineColor;
			uniform float4 _GridColor;
			uniform float _LineWidth;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				float4 uv2 : TEXCOORD1;
			};

			struct v2f
			{
				float4 pos : POSITION;
				float4 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;
				v.uv.y = 1.0 - v.uv.y;

				o.pos = UnityObjectToClipPos(float4((v.uv.xy - 0.5) * 2.0, 1.0, 1.0));
				
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : COLOR
			{
				float2 uv = i.uv;

				if (uv.x < _LineWidth)
					return _LineColor;
				else if (uv.x > 1 - _LineWidth)
					return _LineColor;
				else if (uv.y < _LineWidth)
					return _LineColor;
				else if (uv.y > 1 - _LineWidth)
					return _LineColor;
				else if (uv.x - uv.y < _LineWidth && uv.x - uv.y > -_LineWidth)
					return _LineColor;
				else
					return _GridColor;
			}
			ENDCG
		}
	}
}