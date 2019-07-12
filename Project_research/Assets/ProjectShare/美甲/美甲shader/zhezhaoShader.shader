// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/zhezhaoShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex("MaskTex",2D) = "white"{}
		_ScrollXspeed("xspeed",Range(0,10)) = 2
		_ScrollYspeed("yspeed",Range(0,10)) = 2
			_Scale("Scale",vector)=(1.0,1.0,1.0,1.0)
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100
		//	ZWrite  Off
			Blend  SrcAlpha OneMinusSrcAlpha
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				// make fog work
			//	#pragma multi_compile_fog

				#include "UnityCG.cginc"


	    sampler2D  _MainTex;
		float4  _MainTex_ST;
		sampler2D  _MaskTex;
		float4  _MaskTex_ST;
		float  _ScrollXspeed;
		float  _ScrollYspeed;
		float4  _scale;
		struct a2v
		{
			float4 vertex : POSITION;
			float4 uv : TEXCOORD0;
		};

		struct v2f
		{
			float4 uv : TEXCOORD0;
			//UNITY_FOG_COORDS(1)
			float4 pos : SV_POSITION;
		};

		float4x4  Scale(float4  scale)
		{
			return float4x4(scale.x, 0.0, 0.0, 0.0,
				0.0, scale.y, 0.0, 0.0,
				0.0, 0.0, scale.z, 0.0,
				0.0, 0.0, 0.0, 1.0);
		}
		v2f vert (a2v v)
		{
			v2f o;
			o.pos =UnityObjectToClipPos(v.vertex);
			//v.uv_scale = 0.5;
			v.vertex = mul(Scale(_scale), v.vertex);
			o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
			o.uv.zw = TRANSFORM_TEX(v.uv.zw, _MaskTex);
			//UNITY_TRANSFER_FOG(o,o.vertex);
			return o;
		}
			
		fixed4 frag (v2f i) : SV_Target
		{
			// sample the texture
			
	    	fixed  alpha = tex2D(_MainTex,i.uv.xy).a;
		    fixed4 col = tex2D(_MaskTex, i.uv.zw);
			col.a = col.a*alpha;
			// apply fog
		//	UNITY_APPLY_FOG(i.fogCoord, col);
			return col;
		}
		ENDCG
		}
	}
}
