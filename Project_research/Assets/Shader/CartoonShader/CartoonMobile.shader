Shader "Babybus/Cartoon/cartoonMobile"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

		//TOONY COLORS
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
		_HColor("Highlight Color", Color) = (0.6,0.6,0.6,1.0)
		_SColor("Shadow Color", Color) = (0.2,0.2,0.2,1.0)

		//TOONY COLORS RAMP
		_RampThreshold("Ramp Threshold", Range(0,1)) = 0.5
		_RampSmooth("Ramp Smoothing", Range(0.01,1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM

	    #include "Include/Cartoon_Include.cginc"
        #include "UnityCG.cginc"
		#pragma surface surf ToonyColors

		fixed4 _Color;
		sampler2D _MainTex;

		struct Input
		{
			half2 uv_MainTex : TEXCOORD0;

		};
          
		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 main = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = main.rgb * _Color.rgb;
			o.Alpha = main.a * _Color.a;

		}

        ENDCG
        
    }
}
