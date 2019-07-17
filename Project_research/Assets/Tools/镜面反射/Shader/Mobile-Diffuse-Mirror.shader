// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "Babybus/Mobile/Diffuse-Mirror" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_Ref ("For Mirror reflection,don't set it!", 2D) = "white" {}
	_RefRate ("Reflective Rate", Range (0, 1)) = 1
	_RefColor("Reflection Color",Color) = (1,1,1,1)
	_Distance ("Distance", Float) = 0.001
	_Pow ("Pow", Float) = 0.001
	
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 150

CGPROGRAM
#pragma surface surf Lambert noforwardadd

sampler2D _MainTex;
sampler2D _Ref;
half _RefRate;
fixed4 _RefColor;
fixed _Pow;
float _Distance;
 
struct Input {
	float2 uv_MainTex;
	float2 uv_Ref ;
	float4 screenPos;
};

void surf (Input IN, inout SurfaceOutput o) {

	
	float2 screenUV = IN.screenPos.xy / IN.screenPos.w;

	fixed4 ref = tex2D(_Ref, screenUV);
	float distance = _Distance;
	ref += tex2D(_Ref, half2(screenUV.x + distance , screenUV.y + distance ));
    ref += tex2D(_Ref, half2(screenUV.x + distance , screenUV.y)) ;
    ref += tex2D(_Ref, half2(screenUV.x , screenUV.y + distance ));
    ref += tex2D(_Ref, half2(screenUV.x - distance , screenUV.y - distance )) ;
    ref += tex2D(_Ref, half2(screenUV.x + distance , screenUV.y - distance )) ;
    ref += tex2D(_Ref, half2(screenUV.x - distance , screenUV.y + distance )) ;
    ref += tex2D(_Ref, half2(screenUV.x - distance , screenUV.y));
    ref += tex2D(_Ref, half2(screenUV.x , screenUV.y - distance )) ;
    ref = ref / 9;
	
	o.Emission = ref.rgb* _RefRate* _RefColor.rgb;
	
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = c.rgb*0.5+_Pow;
	o.Alpha = c.a;
}
ENDCG
}

Fallback "Mobile/VertexLit"
}
