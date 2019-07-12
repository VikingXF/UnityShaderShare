Shader "Babybus/BeautifyNails"
{
    Properties
    {
		[KeywordEnum(First, Second,Third)] _Steps ("操作步骤", Float) = 0
        _RoughTex ("粗糙指甲贴图", 2D) = "white" {}
		_SmoothTex ("修好的指甲透明贴图", 2D) = "white" {}		
		_highlights ("高光贴图", 2D) = "white" {}
		_NailPolishTex ("指甲油贴图", 2D) = "white" {}
		_FlowerTex ("花纹贴图", 2D) = "white" {}
		_FlowerColor ("花纹颜色", Color) = (1,1,1,1) 
		_Switch ("剪指甲", Range(0, 1)) = 0
		_MaskTex ("MaskTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
	
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha 

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma shader_feature _STEPS_FIRST _STEPS_SECOND _STEPS_THIRD
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _RoughTex,_SmoothTex,_highlights,_MaskTex,_NailPolishTex,_FlowerTex;
            float4 _RoughTex_ST;
			fixed _Switch;
			float4 _FlowerColor;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _RoughTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 Smoothcol = tex2D(_SmoothTex, i.uv);
				fixed4 highlights = tex2D(_highlights, i.uv);
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				float4 Firstcol = Smoothcol;
				Firstcol.rgb = lerp(Smoothcol.rgb,highlights.rgb,highlights.a);
				
				//第一操作步骤(剪指甲跟磨指甲)
				#if _STEPS_FIRST
                fixed4 Roughcol = tex2D(_RoughTex, i.uv);								
				Roughcol.a = lerp(Roughcol.a,Smoothcol.a,_Switch);			
				fixed4 col  = Roughcol;
				col.rgb = lerp(Roughcol.rgb,Firstcol.rgb,Maskcol.r);
				
				//第二操作步骤(涂不同颜色指甲油)
				#elif _STEPS_SECOND
				fixed4 col =Firstcol;
				fixed4 NailPolishcol = tex2D(_NailPolishTex, i.uv);
				col.rgb = lerp(Firstcol.rgb,NailPolishcol.rgb,Maskcol.r);
				col.rgb = lerp(col.rgb,highlights.rgb,highlights.a);
				
				//第三操作步骤(上花纹)
				#elif _STEPS_THIRD
				//重复采集
				fixed4 NailPolishcol = tex2D(_NailPolishTex, i.uv);
				
				fixed4 col =Firstcol;
				fixed4 Flowercol = tex2D(_FlowerTex, i.uv)*_FlowerColor;
				col.rgb = lerp(NailPolishcol.rgb,Flowercol.rgb,Flowercol.a);
				col.rgb = lerp(col.rgb,highlights.rgb,highlights.a);
				#endif
                return col;
            }
            ENDCG
        }
    }
}
