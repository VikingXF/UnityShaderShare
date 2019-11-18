Shader "Babybus/BeautifyNails2"
{
    Properties
    {
		[KeywordEnum(First, Second,Third)] _Steps ("操作步骤", Float) = 0
        _RoughTex ("粗糙指甲贴图", 2D) = "white" {}
		_SmoothTex ("修好的指甲透明贴图", 2D) = "white" {}	
		_ShadowTex ("指甲暗部贴图", 2D) = "white" {}	
		_ShadowColor ("暗部颜色", Color) = (0.9,0.9,0.9,0.25) 
		_highlights ("高光贴图", 2D) = "white" {}
		_NailPolishTex ("指甲油贴图", 2D) = "white" {}
		_FlowerTex ("花纹贴图", 2D) = "white" {}
		_FlowerColor ("花纹颜色", Color) = (1,1,1,1) 
		_Decals("贴纸", 2D) = "white" {}
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
			#pragma multi_compile _STEPS_FIRST _STEPS_SECOND _STEPS_THIRD
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
				float2 uv2: TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _RoughTex,_SmoothTex,_ShadowTex,_highlights,_MaskTex,_NailPolishTex,_FlowerTex,_Decals;
            float4 _RoughTex_ST,_FlowerTex_ST,_Decals_ST;
			fixed _Switch;
			float4 _FlowerColor,_ShadowColor;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _RoughTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _FlowerTex);
				o.uv2 = TRANSFORM_TEX(v.uv,_Decals);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 Smoothcol = tex2D(_SmoothTex, i.uv.xy);
				fixed4 highlights = tex2D(_highlights, i.uv.xy);
				fixed4 Shadowcol = tex2D(_ShadowTex, i.uv.xy)*_ShadowColor;
							
				float4 Firstcol = Smoothcol;
				Smoothcol.rgb = lerp(Smoothcol.rgb,Smoothcol.rgb*Shadowcol.rgb,Shadowcol.a);
				Firstcol.rgb = lerp(Smoothcol.rgb,highlights.rgb,highlights.a);
				
				//第一操作步骤(剪指甲跟磨指甲)
				#if _STEPS_FIRST
                fixed4 Roughcol = tex2D(_RoughTex, i.uv.xy);								
				Roughcol.a = lerp(Roughcol.a,Smoothcol.a,_Switch);			
				fixed4 col  = Roughcol;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.xy);	
				col.rgb = lerp(Roughcol.rgb,Firstcol.rgb,Maskcol.r);
				
				//第二操作步骤(涂不同颜色指甲油)
				#elif _STEPS_SECOND
				fixed4 col =Firstcol;
				fixed4 NailPolishcol = tex2D(_NailPolishTex, i.uv.xy);
				NailPolishcol.rgb = lerp(NailPolishcol.rgb,NailPolishcol.rgb*Shadowcol.rgb,Shadowcol.a);
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.xy);	
				col.rgb = lerp(Firstcol.rgb,NailPolishcol.rgb,Maskcol.a);
				col.rgb = lerp(col.rgb,highlights.rgb,highlights.a);
				
				//第三操作步骤(上花纹)
				#elif _STEPS_THIRD
				//重复采集(待优化)
				fixed4 NailPolishcol = tex2D(_NailPolishTex, i.uv.xy);
				fixed4 Decalscol = tex2D(_Decals, i.uv2);
				
				fixed4 col =Smoothcol;
				fixed4 Flowercol = tex2D(_FlowerTex, i.uv.zw)*_FlowerColor;
				col.rgb = lerp(NailPolishcol.rgb,Flowercol.rgb,Flowercol.a);
				col.rgb = lerp(col.rgb,col.rgb*Shadowcol.rgb,Shadowcol.a);
				col.rgb = lerp(col.rgb,Decalscol.rgb,Decalscol.a);
				col.rgb = lerp(col.rgb,highlights.rgb,highlights.a);
				#endif
				
                return col;
            }
            ENDCG
        }
    }
}
