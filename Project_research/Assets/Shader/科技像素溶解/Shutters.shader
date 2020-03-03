/*

模拟百叶窗效果
xf.2020.3.2

*/

Shader "Babybus/Special/Shutters"
{
    Properties
	{
		//[PerRendererData]_MainTex ("Texture", 2D) = "white" {}
		_MainTex ("Texture", 2D) = "white" {}
		
		_Dissolution_Tex ("Dissolution_Tex", 2D) = "white" {}
		[KeywordEnum(First,Second,Third)]_Style("样式" , Float) = 0
		_Dissolution("变化",Range(0,1)) = 0
		
		_line("百叶窗行数",float ) = 5
		_Column("百叶窗列数",float ) = 5
		
		
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
			// make fog work
			//#pragma multi_compile_fog
			
			#pragma shader_feature _STYLE_FIRST _STYLE_SECOND _STYLE_THIRD
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
 
			sampler2D _MainTex,_Dissolution_Tex;
			float4 _MainTex_ST;

			float _line,_Column;
			float _Dissolution;

			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);	
				
				#if _STYLE_FIRST
				col.a -= 1-step( i.uv.x % (1/_Column) ,_Dissolution/_Column);
				
				#elif _STYLE_SECOND
				col.a -= 1-step( i.uv.y % (1/_line) ,_Dissolution/_line);
				
				#elif _STYLE_THIRD
				
				fixed4 Discol = tex2D(_Dissolution_Tex, i.uv*float2(_line,_Column));	
				float Dis = (_Dissolution*-2.0+1.5);
                col.a -= step(Discol.r,Dis)+step(Discol.g,Dis);

				//float2 ce1= i.uv*2 -1;
				//float2 ce2= (1-i.uv)*2 -1;
				//float2 ce= 1-(saturate(ce1)+saturate(ce2));

				#endif 
				
				return col;
			}
			ENDCG
		}
	}

}
