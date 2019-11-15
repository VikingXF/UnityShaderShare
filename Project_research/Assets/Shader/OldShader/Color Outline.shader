// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


	Shader "Custom/Color Outline" {

		Properties
		{
			_Color("Main Color", Color) = (1,1,1,1)
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
			_OutlineWidth("Outline width", Range(0.0, 0.03)) = .005

		}
			SubShader
		{
			Tags{ "Queue" = "Geometry" "RenderType" = "Transparent" }
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



CGPROGRAM
#pragma surface surf Lambert alpha:fade

sampler2D _MainTex;
fixed4 _Color;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}
ENDCG
}

Fallback "Legacy Shaders/Transparent/VertexLit"
}
