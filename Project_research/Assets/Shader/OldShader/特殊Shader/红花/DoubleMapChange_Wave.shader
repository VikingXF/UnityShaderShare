
/*********************************************************************
xf 2020.8.4
实现2张贴图从上到下水波浪变化

**********************************************************************/

Shader "Babybus/Special/DoubleMapChange_Wave"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainTex2 ("Texture2", 2D) = "white" {}		
		_Degree("degree",float)=0
		_Pow("pow",float)=10		
		
		//波浪
		_WaveSpeed ("WaveSpeed", float) = 2.8
		_WaveHeight ("WaveHeight", float) = 00.5
		_WaveRange ("WaveRange", float) = 8
		
		_Scale("Scale", Float) = 900  //缩放
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

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;			
				float4 vertex : SV_POSITION;

				float3 model : TEXCOORD1;
			};

			sampler2D _MainTex,_MainTex2;
			float4 _MainTex_ST;
			
			float _Scale;
			float _Degree;
			float _Pow;

			
			half _WaveSpeed;
			half _WaveHeight;
			half _WaveRange;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.model = v.vertex;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_MainTex2, i.uv);
				
				float y = _Degree + sin(_Time.y * _WaveSpeed + i.model.x/_Scale * _WaveRange) * _WaveHeight;
				float t = pow(saturate(y+1+ i.model.y/_Scale),_Pow);				
				float n =step(saturate(y+ i.model.y/_Scale),0) ;				
				col.rgb =saturate(col.rgb+t);

				col.rgb = lerp(col2.rgb,col.rgb,n);
				return col;
			}
			ENDCG
		}
	}
}
