/*

模拟UI360 度时钟进度条效果
贴图由暗360度转变成亮
xf.2018.7.24

*/

Shader "Babybus/Special/Progress bar360_Texture"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainTex2 ("Texture2", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(-0.01,1)) = 0.5
		
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD2;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_MainTex2;
			float4 _MainTex_ST,_MainTex2_ST;
			fixed _Cutoff;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex); 
				o.uv.zw = TRANSFORM_TEX(v.uv1, _MainTex2);
				o.uv2 = v.uv2;
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col = tex2D(_MainTex, i.uv.xy);
				fixed4 col2 = tex2D(_MainTex2, i.uv.zw);
				
				float2 uv_center = i.uv2*2.0-1;	     							
                float uv_dir = pow(saturate(atan2(uv_center.x,uv_center.y)*0.1592357+0.5+_Cutoff),1000);
								
				col.rgb = lerp(col2,col,uv_dir);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
				
				
			}
			ENDCG
		}
	}
}
