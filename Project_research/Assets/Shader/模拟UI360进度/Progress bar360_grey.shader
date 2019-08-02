/*

模拟UI360 度时钟进度条效果
贴图由暗360度转变成亮
xf.2018.7.24

*/

Shader "Babybus/Special/Progress bar360_grey"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Intensity ("Intensity", Range(0,2)) = 1
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
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Intensity;
			fixed _Cutoff;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = v.uv;
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col = tex2D(_MainTex, i.uv.xy);
				
				float gray = dot(col.rgb, float3(0.299, 0.587, 0.114));
				float3 graycol = float3(gray, gray, gray)*_Intensity;
				
				float2 uv_center = i.uv.zw*2.0-1;	     							
                float uv_dir = pow(saturate(atan2(uv_center.x,uv_center.y)*0.1592357+0.5+_Cutoff),1000);
								
				col.rgb = lerp(graycol,col,uv_dir);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
				
				
			}
			ENDCG
		}
	}
}
