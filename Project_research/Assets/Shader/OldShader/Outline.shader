// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Outline" {
	
		Properties
		{
			_MainTex("Texture", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
			_OutlineWidth("Outline width", Range(0.0, 0.03)) = .005

		}
			SubShader
		{
			Tags{ "Queue" = "Geometry" "RenderType" = "Opaque" }
			LOD 200
			
			Pass
		{
			Cull Off
			ZWrite Off

			CGPROGRAM

#include "UnityCG.cginc"  
#pragma vertex vert  
#pragma fragment frag  

			half _OutlineWidth;
		fixed4 _OutlineColor;

		struct V2F
		{
			float4 pos:SV_POSITION;
		};

		V2F vert(appdata_base IN)
		{
			V2F o;

			IN.vertex.xyz += IN.normal * _OutlineWidth;
			o.pos = UnityObjectToClipPos(IN.vertex);
			return o;
		}

		fixed4 frag(V2F IN) :COLOR
		{
			return _OutlineColor;
		}
			ENDCG
		}
	

			Pass
		{
			CGPROGRAM
#pragma vertex vert
#pragma fragment frag
			// make fog work
#pragma multi_compile_fog

#include "UnityCG.cginc"

		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;

		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			UNITY_TRANSFER_FOG(o,o.vertex);
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			// sample the texture
			fixed4 col = tex2D(_MainTex, i.uv);
		// apply fog
		UNITY_APPLY_FOG(i.fogCoord, col);
		return col;
		}
			ENDCG
		}
		}
	}


	