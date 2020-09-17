Shader "Easy Skin Shading/Skin Beckmann" {
	Properties {
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		float PHBeckmann (float ndoth, float m)
		{
			float alpha = acos(ndoth);
			float ta = tan(alpha);
			float val = 1.0 / (m * m * pow(ndoth, 4.0)) * exp(-(ta * ta) / (m * m));
			return val;
		}
		float KSTextureCompute (float2 uv)
		{
			return 0.5 * pow(PHBeckmann(uv.x, uv.y), 0.1);
		}
		float4 frag (v2f_img i) : COLOR
		{
			float x = KSTextureCompute(i.uv);
			return float4(x, x, x, 1);
		}
	ENDCG
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG
		}
	}
	FallBack Off
}