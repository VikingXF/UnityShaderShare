/*
xf.2019.11.21
模拟PS图层混合叠加效果（正片叠底）
*/


Shader "Blend/BlendTex"
{
    Properties
    {
        _SrcTex ("SrcTex(底图)", 2D) = "white" {}
		_DestTex ("DestTex(叠加图)", 2D) = "white" {}
		_DestAlpha("DestAlpha(叠加图Alpha)",Range(0,1)) = 1
		//[KeywordEnum(正片叠底,颜色加深,颜色减淡,线性加深,线性减淡,变亮,变暗,滤色,叠加,柔光,强光,亮光,点光,线性光,实色混合,差值,排除)]_Blend("混合模式" , Float) = 0
		[KeywordEnum(Muitiply,ColorBurn,ColorDodge,LinearBurn,LinearDodge,Lighten,Darken,Screen,Overlay,SoftLight,HardLight,VividLight,PinLight,LinearLight,HardMix,Difference,Exclusion)]_Blend("混合模式" , Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			#include "BlendInclude.cginc"
			#pragma shader_feature _BLEND_MUITIPLY  _BLEND_COLORBURN  _BLEND_COLORDODGE  _BLEND_LINEARBURN  _BLEND_LINEARDODGE  _BLEND_LIGHTEN  _BLEND_DARKEN  _BLEND_SCREEN  _BLEND_OVERLAY _BLEND_SOFTLIGHT  _BLEND_HARDLIGHT _BLEND_VIVIDLIGHT _BLEND_PINLIGHT _BLEND_LINEARLIGHT  _BLEND_HARDMIX _BLEND_DIFFERENCE  _BLEND_EXCLUSION
			
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
			         
			
            sampler2D _SrcTex,_DestTex;
            float4 _SrcTex_ST;
			float _DestAlpha;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _SrcTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 Srccol = tex2D(_SrcTex, i.uv);
				fixed4 Destcol = tex2D(_DestTex, i.uv);
				Destcol.a*=_DestAlpha;
				
				fixed4 col =Srccol;
				
				#if _BLEND_MUITIPLY
				col = Muitiply(Srccol,Destcol);
				
				#elif _BLEND_COLORBURN  
				col = ColorBurn(Srccol,Destcol);
				#elif _BLEND_COLORDODGE  
				col = ColorDodge(Srccol,Destcol);
				#elif _BLEND_LINEARBURN  
				col = LinearBurn(Srccol,Destcol);
				#elif _BLEND_LINEARDODGE 
				col = LinearDodge(Srccol,Destcol);
				#elif _BLEND_LIGHTEN  
				col = Lighten(Srccol,Destcol);			
				#elif _BLEND_DARKEN  
				col = Darken(Srccol,Destcol);
				#elif _BLEND_SCREEN  
				col = Screen(Srccol,Destcol);
				#elif _BLEND_OVERLAY 
				col = Overlay(Srccol,Destcol);
				#elif _BLEND_SOFTLIGHT 
				col = SoftLight(Srccol,Destcol);
				#elif _BLEND_HARDLIGHT 
				col = HardLight(Srccol,Destcol);		
				#elif _BLEND_VIVIDLIGHT 
				col = VividLight(Srccol,Destcol);
				#elif _BLEND_PINLIGHT 
				col = PinLight(Srccol,Destcol);
				#elif _BLEND_LINEARLIGHT  
				col = LinearLight(Srccol,Destcol);
				#elif _BLEND_HARDMIX 
				col = HardMix(Srccol,Destcol);
				#elif _BLEND_DIFFERENCE 
				col = Difference(Srccol,Destcol);
				#elif _BLEND_EXCLUSION
				col = Exclusion(Srccol,Destcol);

				#endif
								
                return col;
            }
            ENDCG
        }
    }
}
