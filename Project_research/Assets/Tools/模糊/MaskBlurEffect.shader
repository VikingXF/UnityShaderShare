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
		half2 uv[5] : TEXCOORD0;
		
	};
	v2f vertBlurVertical (appdata_t v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		half2 uv = v.texcoord;
		o.uv[0] = uv;
		o.uv[1] = uv + float2(0.0,_MainTex_TexelSize.y*1.0)*_BlurSize;
		o.uv[2] = uv - float2(0.0,_MainTex_TexelSize.y*1.0)*_BlurSize;
		o.uv[3] = uv + float2(0.0,_MainTex_TexelSize.y*2.0)*_BlurSize;
		o.uv[4] = uv - float2(0.0,_MainTex_TexelSize.y*2.0)*_BlurSize;
	
		
		return o;
	};
	
	
	fixed4 fragBlur (v2f i) : SV_Target
	{
		float3 GaussWeight = {0.4026,0.2442,0.0545};
		fixed3 sum = tex2D(_BlurTex,i.uv[0]).rgb*GaussWeight[0];
		for(int it = 1;it<3;it++)
		{
			sum += tex2D(_BlurTex,i.uv[it]).rgb * GaussWeight[it];
			sum += tex2D(_BlurTex,i.uv[2*it]).rgb * GaussWeight[it];
		}
		
		//fixed4 col = tex2D(_MainTex, i.texcoord);
		return fixed4(sum,1);
	}
	
	
	ENDCG

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
           
            ZTest Off
			Cull Off

			CGPROGRAM
	
			#pragma vertex vertBlurVertical
		
			#pragma fragment fragBlur

			ENDCG
        }
    }
}
