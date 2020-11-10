/*

模拟转场效果
xf.2020.11.10

*/

Shader "Babybus/Transitions/LensTransitions"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _MaskTex("Mask Texture", 2D) = "white" {}
        _PixelSize ("Pixel Size", Range(1,256)) = 25
		_Dissolution ("变化", Range(0,1)) = 0
		[KeywordEnum(First,Second,Third,Four,Five,Six,Seven)]_Style("样式" , Float) = 0		
		[Toggle]_Flip("Flip?", Float) = 0
		
    }
    SubShader
    {
        //Tags { "Queue"="Transparent" }
        //Blend SrcAlpha OneMinusSrcAlpha
        Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag            
            #include "UnityCG.cginc"
            #pragma shader_feature _STYLE_FIRST _STYLE_SECOND _STYLE_THIRD _STYLE_FOUR _STYLE_FIVE _STYLE_SIX _STYLE_SEVEN
			#pragma shader_feature _FLIP_ON
			
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            sampler2D _MainTex, _MaskTex;
            float4 _MainTex_ST, _MaskTex_ST;
            float _PixelSize;
            float _Dissolution;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
				fixed uvX = i.uv.x;
				fixed uvY = i.uv.y;
				
				fixed4 col = tex2D(_MainTex, i.uv.xy);
               
				
				#if _FLIP_ON
				uvX = 1-i.uv.x;
				uvY = 1-i.uv.y;
				#endif					
				
                //左下右上斜格子切换
				#if _STYLE_FIRST
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.zw* _PixelSize);
                float ratioX = (int)((1-uvX)* _PixelSize) / _PixelSize +1/_PixelSize;
                float ratioY = (int)((1-uvY) * _PixelSize) / _PixelSize+1/_PixelSize;
				float alpha = 1-(ratioX*ratioY+_Dissolution);
				float alpha2 = (ratioX * ratioY );
				col.a = max((1-Maskcol.r * alpha2 - _Dissolution), alpha);
				 
				//左上右下格子切换
				#elif _STYLE_SECOND
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.zw* _PixelSize);
				float ratioX = (int)((1-uvX)* _PixelSize) / _PixelSize +1/_PixelSize;
                float ratioY = (int)( uvY* _PixelSize) / _PixelSize+1/_PixelSize;
				float alpha = 1-(ratioX*ratioY+_Dissolution);
				float alpha2 = (ratioX * ratioY );
				col.a = max((1-Maskcol.r * alpha2 - _Dissolution), alpha);
				 
				//左右格子切换
				#elif _STYLE_THIRD
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.zw* _PixelSize);
				float ratioX = (int)((1-uvX)* _PixelSize) / _PixelSize +1/_PixelSize;
                float ratioY = (int)((1-uvY) * _PixelSize) / _PixelSize+1/_PixelSize;
				float alpha = 1-(ratioY+_Dissolution);                
                float alpha2 = ratioY;
				col.a = max((1-Maskcol.r * alpha2 - _Dissolution), alpha);
				 
				//上下格子切换
				#elif _STYLE_FOUR
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.zw* _PixelSize);
				float ratioX = (int)((1-uvX)* _PixelSize) / _PixelSize +1/_PixelSize;
                float ratioY = (int)((1-uvY) * _PixelSize) / _PixelSize+1/_PixelSize;
				float alpha = 1-(ratioX+_Dissolution);                
                float alpha2 = ratioX;
				col.a = max((1-Maskcol.r * alpha2 - _Dissolution), alpha);
				
				//图形切换 
				#elif _STYLE_FIVE				
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.zw* _PixelSize);
                float Dis = (_Dissolution*-2.0+1.5);
                float alpha = step(Maskcol.r,Dis)+step(Maskcol.g,Dis);				
				col.a -=alpha;
				
				//X百叶窗转场
				#elif _STYLE_SIX 
				float alpha = 1-step( uvX % (1/_PixelSize) ,_Dissolution/_PixelSize);
				col.a -=alpha+0.01;
				
				//Y百叶窗转场
				#elif _STYLE_SEVEN
				float alpha = 1-step( uvY % (1/_PixelSize) ,_Dissolution/_PixelSize);
				col.a -=alpha+0.01;
				
				#endif

				
                clip(col.a);	
                return col;
            }
            ENDCG
        }
    }
}