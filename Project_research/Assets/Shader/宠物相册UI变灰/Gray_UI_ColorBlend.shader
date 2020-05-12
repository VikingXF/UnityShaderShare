// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Babybus/Gray/Gray_UI_ColorBlend"
{
	Properties
	{
		[PerRendererData]_MainTex ("Base (RGB), Alpha (A)", 2D) = "white" {}
		_Saturation ("Saturation", Range(0,1)) = 1
		_Brightness ("Brightness", Range(0,2)) = 1
		_Contrast ("Contrast", Range(0,2)) = 1
		_Lightness("Lightness", Range(0,1)) = 1
	}
	
	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			ColorMask RGB
			AlphaTest Greater .01
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMaterial AmbientAndDiffuse
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Brightness;
			fixed _Saturation;
			fixed _Contrast;
			fixed _Lightness;
			struct appdata_t
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				return o;
			}




			half4 frag (v2f IN) : COLOR
			{
				// Sample the texture
				half4 col = tex2D(_MainTex, IN.texcoord);
				
				half gray = dot(col.rgb, half3(0.299, 0.587, 0.114));
				half3 graycol = float3(gray, gray, gray);			
				col.rgb = lerp(graycol,col.rgb,_Saturation)*_Brightness;
	
				col.rgb =lerp(IN.color.rgb*col.rgb,col.rgb,saturate(gray*_Contrast));
				
				fixed3 avgColor = fixed3(0.5, 0.5, 0.5);    
                col.rgb = lerp(avgColor, col.rgb, _Lightness);  
		
				return saturate(col);
			}
			ENDCG
		}
	}
}
