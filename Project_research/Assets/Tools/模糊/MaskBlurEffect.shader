Shader "Babybus/Screen Effects/MaskBlurEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_BlurTex("Base (RGB)", 2D) = "white" {}
		_MaskTex ("MaskTex", 2D) = "white" {}
		_BlurSize("Blur Size",Float) = 1.0
    }
	
	CGINCLUDE
	
	sampler2D _MainTex,_BlurTex,_MaskTex;
	half4 _MainTex_TexelSize;
	float _BlurSize;
	struct appdata_t {
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
	};

	struct v2f {
		float4 vertex : SV_POSITION;
		half4 uv : TEXCOORD0;
		
	};
	
	//高斯模糊权重矩阵参数7x4的矩阵 ||  Gauss Weight
	static const half3 GaussWeight[7] =
	{
		half3(0.0205,0.0205,0.0205),
		half3(0.0855,0.0855,0.0855),
		half3(0.232,0.232,0.232),
		half3(0.324,0.324,0.324),
		half3(0.232,0.232,0.232),
		half3(0.0855,0.0855,0.0855),
		half3(0.0205,0.0205,0.0205)
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

		half4 color = half4(0,0,0,1);
		for (int j = 0; j < 7; j++)
		{			
			half3 texColRGB = tex2D(_MainTex, uv_withOffset).rgb;
			color.rgb += texColRGB * GaussWeight[j];
			uv_withOffset += OffsetWidth;
		}
		return color;
	
	}
	
	//区域模糊顶点着色函数
		v2f vert(appdata_t v)
	{		
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);		
		o.uv.xy = v.texcoord;
		
		
		//计算距离中心点距离
		//float2 dir = float2(0.5, 0.5) - o.uv.xy;
		//o.uv.z = saturate(pow(sqrt(dir.x * dir.x + dir.y * dir.y) + 0, 2));

		return o;
	}

	//【区域模糊片段着色函数
	fixed4 frag(v2f i) : SV_Target
	{
		
		//取原始场景图片进行采样
		fixed4 ori = tex2D(_MainTex, i.uv.xy);

		//取得到的轮廓图片进行采样
	
		fixed Mask = tex2D(_MaskTex, i.uv.xy).r;
		fixed4 blur = tex2D(_BlurTex, i.uv.xy);
		fixed4 color = lerp(ori, blur, 1-Mask);
		//fixed4 color = lerp(ori, blur, i.uv.z);
		return color;
	}
	
	ENDCG

    SubShader
    {
       
		ZTest Always
		//ZTest Off
		Cull Off
		//Zwrite Off
		
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
		//---------------------------------------【通道2 || Pass2 】------------------------------------
		//通道2：通过mask图进行区域模糊 
		Pass
        {
            NAME "GAUSSIAN_BLUR_MASK"
            

			CGPROGRAM
	
			#pragma vertex vert		
			#pragma fragment frag

			ENDCG
        }
		
    }
	FallBack Off
}
