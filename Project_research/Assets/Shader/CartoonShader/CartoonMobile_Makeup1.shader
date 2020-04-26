
Shader "Babybus/Cartoon/cartoonMobile_Makeup1"
{
    Properties
    {
		[KeywordEnum(First, Second)] _Steps ("操作步骤", Float) = 0
        _FaceTex ("脸部贴图", 2D) = "white" {}

		//TOONY COLORS
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
		_HColor("Highlight Color", Color) = (0.6,0.6,0.6,1.0)
		_SColor("Shadow Color", Color) = (0.2,0.2,0.2,1.0)

		//TOONY COLORS RAMP
		_RampThreshold("Ramp Threshold", Range(0,1)) = 0.5
		_RampSmooth("Ramp Smoothing", Range(0.01,1)) = 0.1
		
		//Rim
		_RimColor ("Rim Color", Color) = (0.8,0.8,0.8,0.6)
		_RimMin ("Rim Min", Range(0,1)) = 0.5
		_RimMax ("Rim Max", Range(0,1)) = 1.0 
		
		//Makeup
		_SpotsTex("黑眼圈斑点", 2D) = "white" {}
		_SpotsAmount ("斑点消失", Range(0, 1)) = 0
		_EyeShadowTex("眼影", 2D) = "white" {}
		_LipsTex("嘴唇", 2D) = "white" {}
		
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM

	    #include "Include/Cartoon_Include.cginc"
        #include "UnityCG.cginc"
		#pragma surface surf ToonyColors
		#pragma multi_compile _STEPS_FIRST _STEPS_SECOND
		
		fixed4 _Color;
		sampler2D _FaceTex,_SpotsTex,_EyeShadowTex,_LipsTex;
		float _SpotsAmount;
				
		fixed4 _RimColor;
		fixed _RimMin;
		fixed _RimMax;
		float4 _RimDir;
		
		struct Input
		{
			half2 uv_FaceTex : TEXCOORD0;
			half2 uv2_EyeShadowTex : TEXCOORD1;
			half2 uv3_LipsTex : TEXCOORD2;
			float3 normal;			
			float4 vertex;
		};		
		
		//void vert (inout appdata_full v, out Input o) {
		//       
		//        
		//   //float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
		//	float3 viewDir =normalize((_WorldSpaceCameraPos - mul(unity_ObjectToWorld, v.vertex)));
		//	float3  viewnormal = normalize(UnityObjectToWorldNormal(v.normal));
		//	float Rim =1 - dot(viewDir,viewnormal);
		//	o.Emissive = _RimColor.rgb * pow(Rim,_RimPower) *_RimIntensity;  

		//}
	  
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 main = tex2D(_FaceTex, IN.uv_FaceTex);
			fixed4 col = main;
			//第一操作步骤
			#if _STEPS_FIRST
			
				fixed4 Spotscol = tex2D(_SpotsTex, IN.uv_FaceTex);
				col.rgb = lerp(col.rgb.rgb,Spotscol.rgb,saturate(Spotscol.a-_SpotsAmount));
				
			#endif				
				fixed4 EyeShadowcol = tex2D(_EyeShadowTex, IN.uv2_EyeShadowTex);
				fixed4 Lipscol = tex2D(_LipsTex, IN.uv3_LipsTex);
				col.rgb = lerp(col.rgb.rgb,EyeShadowcol.rgb,EyeShadowcol.a);
				col.rgb = lerp(col.rgb,Lipscol.rgb,Lipscol.a);

			o.Albedo = col.rgb * _Color.rgb;
			o.Alpha = col.a * _Color.a;
			
			//Rim
			float3 viewDir = normalize(WorldSpaceViewDir(IN.vertex));
			half rim = 1.0f - saturate( dot(viewDir, UnityObjectToWorldNormal(IN.normal)) );
			rim = smoothstep(_RimMin, _RimMax, rim);
			o.Albedo = lerp(o.Albedo.rgb, _RimColor.rgb, rim * _RimColor.a);			
		}

        ENDCG
        
    }
}
