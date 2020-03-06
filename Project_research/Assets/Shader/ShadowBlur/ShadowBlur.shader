Shader "Babybus/ShadowBlur"
{
   Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_ShadowColor("ShadowColor", Color) = (1,1,1,1) 

		_BlurSize("Blur Size",Float) = 1.0
		
    }
	
	CGINCLUDE
	
	
	sampler2D _MainTex;
	half4 _MainTex_TexelSize;
	float _BlurSize;
	half4 _ShadowColor;
	struct appdata_t {
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
	};

	struct v2f {
		float4 vertex : SV_POSITION;
		half4 uv : TEXCOORD0;
		
	};
	
	//高斯模糊权重矩阵参数7x4的矩阵 ||  Gauss Weight
	/*static const half4 GaussWeight[7] =
	{
		half4(0.0205,0.0205,0.0205,0.0205),
		half4(0.0855,0.0855,0.0855,0.0855),
		half4(0.232,0.232,0.232,0.232),
		half4(0.324,0.324,0.324,0.324),
		half4(0.232,0.232,0.232,0.232),
		half4(0.0855,0.0855,0.0855,0.0855),
		half4(0.0205,0.0205,0.0205,0.0205)
	};*/
	static const half GaussWeight[7] =
	{
		0.0205,
		0.0855,
		0.232,
		0.324,
		0.232,
		0.0855,
		0.0205
	};
	v2f vertBlurVertical (appdata_t v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv.xy = v.texcoord;
		o.uv.zw = _MainTex_TexelSize.xy * half2(0.0, 1.0)*_BlurSize;
	
		
		return o;
	};
	
	v2f vertBlurHorizontal (appdata_t v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv.xy = v.texcoord;
		o.uv.zw = _MainTex_TexelSize.xy * half2(1.0, 0.0)*_BlurSize;
	
		
		return o;
	};
	

	
	half4 fragBlur (v2f i) : SV_Target
	{
	
		half2 uv = i.uv.xy;
		half2 OffsetWidth = i.uv.zw;	
		half2 uv_withOffset = uv - OffsetWidth * 3.0;

		half4 color = half4(_ShadowColor.rgb,0);
		for (int j = 0; j < 7; j++)
		{			
			half texColRGB = tex2D(_MainTex, uv_withOffset).a;
			color.a += texColRGB * GaussWeight[j];
			uv_withOffset += OffsetWidth;
		}
		color.a *= _ShadowColor.a;
		return color;
	
	}	
	
	ENDCG

    SubShader
    {
       
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
	
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha 
		
		//---------------------------------------【通道0 || Pass0 】------------------------------------
		//通道0：垂直方向模糊处理通道 ||Pass 0: Vertical Pass
        Pass
        {
            NAME "GAUSSIAN_BLUR_VERTICAL"
            

			CGPROGRAM
	
			#pragma vertex vertBlurVertical		
			#pragma fragment fragBlur

			ENDCG
        }
		
		//---------------------------------------【通道1 || Pass1 】------------------------------------
		//通道1：水平方向模糊处理通道 ||Pass 1: Horizontal Pass
		Pass
        {
            NAME "GAUSSIAN_BLUR_HORIZONTAL"
            

			CGPROGRAM
	
			#pragma vertex vertBlurHorizontal		
			#pragma fragment fragBlur

			ENDCG
        }
		
		
    }
	FallBack Off
}
