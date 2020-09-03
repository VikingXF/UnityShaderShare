/*
xf
主要实现土层挖掘效果
_CementTex：水泥贴图
_CementColor：深色水泥贴图
_TimeTex：水泥表面流光
_ColorTex：根据该贴图Alpha控制土层Y轴降低强度
_pow：图层强度强度倍增值
*/

Shader "Babybus/engineer/cement"
{
	Properties
	{
		_CementTex ("CementTex", 2D) = "white" {}
		_TimeTex ("TimeTex", 2D) = "white" {}
		_CementColor ("CementColor", Color) = (1,1,1,1) 	
		_ColorTex ("ColorTex", 2D) = "white" {}
		_pow("POW",float) = 1
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
			//#pragma target 3.0

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				//float4 vertcolor : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;				
				//float4 vcolor : TEXCOORD1;		
			};

			sampler2D _CementTex,_ColorTex,_TimeTex;
			float4 _CementTex_ST,_ColorTex_ST;
			float _pow;
			float4 _CementColor;
			v2f vert (appdata v)
			{
				v2f o;
				//o.vcolor = tex2Dlod(_ColorTex, float4(TRANSFORM_TEX(v.uv, _ColorTex),0,0)).r;
				//v.vertex.y += o.vcolor*_pow;				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _CementTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 Timecol = tex2D(_TimeTex, i.uv);
				fixed4 Cementcol = tex2D(_CementTex, i.uv+Timecol.r+sin(_Time.x));
				fixed4 Colorcol = tex2D(_ColorTex, i.uv);
				
				
				fixed4 col = lerp(Cementcol*_CementColor,Cementcol,pow(Colorcol.r,1));
				return col;
			}
			ENDCG
		}
	}
}
