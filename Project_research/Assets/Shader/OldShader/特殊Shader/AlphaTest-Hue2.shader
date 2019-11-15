// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*********************************************************************

透明，调整色相，饱和度，明度

**********************************************************************/
Shader "Babybus/Cutout/AlphaTest-Hue2" {
Properties {

	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	_Cutoff ("Base Alpha cutoff", Range (0,.9)) = .5
    _Hue ("Hue", Range(0,359)) = 0 
	_Saturation ("Saturation", Range(0,3.0)) = 1.0
    _Value ("Value", Range(0,3.0)) = 1.0

	_SubTex ("Base (RGB) Alpha (A)", 2D) = "white" {}	
	_Cutoff2("Base Alpha cutoff", Range(0,1)) = .5
}

SubShader {
	Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
	Lighting off
	
	// Render both front and back facing polygons.
	Cull Off
	
	// first pass:
	//   render any pixels that are more than [_Cutoff] opaque
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutoff;
			half _Saturation;
			half _Value;
			
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			half _Hue;

			
			
		//RGB to HSV
        float3 RGBConvertToHSV(float3 rgb)
        {
            float R = rgb.x,G = rgb.y,B = rgb.z;
            float3 hsv;
            float max1=max(R,max(G,B));
            float min1=min(R,min(G,B));
            if (R == max1) 
            {
                hsv.x = (G-B)/(max1-min1);
            }
            if (G == max1) 
            {
                hsv.x = 2 + (B-R)/(max1-min1);
                }
            if (B == max1) 
            {
                hsv.x = 4 + (R-G)/(max1-min1);
                }
            hsv.x = hsv.x * 60.0;   
            if (hsv.x < 0) 
                hsv.x = hsv.x + 360;
            hsv.z=max1;
            hsv.y=(max1-min1)/max1;
            return hsv;
        }

        //HSV to RGB
        float3 HSVConvertToRGB(float3 hsv)
        {
            float R,G,B;
            //float3 rgb;
            if( hsv.y == 0 )
            {
                R=G=B=hsv.z;
            }
            else
            {
                hsv.x = hsv.x/60.0; 
                int i = (int)hsv.x;
                float f = hsv.x - (float)i;
                float a = hsv.z * ( 1 - hsv.y );
                float b = hsv.z * ( 1 - hsv.y * f );
                float c = hsv.z * ( 1 - hsv.y * (1 - f ) );
                switch(i)
                {
                    case 0: R = hsv.z; G = c; B = a;
                        break;
                    case 1: R = b; G = hsv.z; B = a; 
                        break;
                    case 2: R = a; G = hsv.z; B = c; 
                        break;
                    case 3: R = a; G = b; B = hsv.z; 
                        break;
                    case 4: R = c; G = a; B = hsv.z; 
                        break;
                    default: R = hsv.z; G = a; B = b; 
                        break;
                }
            }
            return float3(R,G,B);
        } 
		
			fixed4 frag (v2f i) : SV_Target
			{
				half4 col = tex2D(_MainTex, i.texcoord);
				
				clip(col.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, col);	
				float3 colorHSV;    
				colorHSV.xyz = RGBConvertToHSV(col.xyz);   //转换为HSV
				colorHSV.x += _Hue; //调整偏移Hue值
				colorHSV.x = colorHSV.x%360;    //超过360的值从0开始    
				colorHSV.y *= _Saturation;  //调整饱和度
				colorHSV.z *= _Value;  				
				col.xyz = HSVConvertToRGB(colorHSV.xyz);   //将调整后的HSV，转换为RGB颜色
								
				return col;
			}
		ENDCG
	}
		
	//Pass 2
	Pass {  
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _SubTex;
			float _Cutoff2;	
			float _Cutoff;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 colSub = tex2D(_SubTex, i.texcoord);
				half4 col = tex2D(_MainTex, i.texcoord);
				
				clip(col.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, col);
				colSub.a -= _Cutoff2;
				return colSub;
			}
		ENDCG
	}
	
	
	
}

}
