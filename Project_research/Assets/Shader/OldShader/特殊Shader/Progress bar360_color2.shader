/*

模拟UI360 度时钟进度条效果
贴图由暗360度转变成亮
xf.2018.7.24

*/

Shader "Babybus/Special/Progress bar360_color2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("MainColor",Color)= (1,1,1,1)
		_Cutoff ("Alpha cutoff", Range(-0.01,1)) = 0.5
		[KeywordEnum(Bottom,Right,Top,Left)]_TransFormPoint("Fill Origin" , Float) = 0
		[KeywordEnum(clockwise,counterclockwise)]_Direction("Fill Origin" , Float) = 0
		
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
			#pragma shader_feature _TRANSFORMPOINT_BOTTOM _TRANSFORMPOINT_RIGHT _TRANSFORMPOINT_TOP _TRANSFORMPOINT_LEFT
			#pragma shader_feature _DIRECTION_CLOCKWISE _DIRECTION_COUNTERCLOCKWISE
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Cutoff;
			fixed4 _MainColor;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = v.uv2;
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col = tex2D(_MainTex, i.uv.xy);
				
				
				float3 graycol = col.rgb*_MainColor.rgb;
				
				float2 uv_center = i.uv.zw*2.0-1;	 

				#if _DIRECTION_CLOCKWISE
					#if _TRANSFORMPOINT_BOTTOM					
					float uv_dir = pow(saturate(atan2(-uv_center.x,uv_center.y)*0.1592357+0.5+_Cutoff),1000);
					
					#elif _TRANSFORMPOINT_RIGHT 
					float uv_dir = pow(saturate(atan2(-uv_center.y,-uv_center.x)*0.1592357+0.5+_Cutoff),1000);
					
					#elif _TRANSFORMPOINT_TOP 
					float uv_dir = pow(saturate(atan2(uv_center.x,-uv_center.y)*0.1592357+0.5+_Cutoff),1000);
					
					#elif _TRANSFORMPOINT_LEFT
					float uv_dir = pow(saturate(atan2(uv_center.y,uv_center.x)*0.1592357+0.5+_Cutoff),1000);	
					
					#endif	
				#elif _DIRECTION_COUNTERCLOCKWISE
					#if _TRANSFORMPOINT_BOTTOM					
					float uv_dir = pow(saturate(atan2(uv_center.x,uv_center.y)*0.1592357+0.5+_Cutoff),1000);
					
					#elif _TRANSFORMPOINT_RIGHT 
					float uv_dir = pow(saturate(atan2(uv_center.y,-uv_center.x)*0.1592357+0.5+_Cutoff),1000);
					
					#elif _TRANSFORMPOINT_TOP 
					float uv_dir = pow(saturate(atan2(-uv_center.x,-uv_center.y)*0.1592357+0.5+_Cutoff),1000);	
					
					#elif _TRANSFORMPOINT_LEFT
					float uv_dir = pow(saturate(atan2(-uv_center.y,uv_center.x)*0.1592357+0.5+_Cutoff),1000);
							
					#endif	
										
				#endif
				
				col.rgb = lerp(graycol,col,uv_dir);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;				
				
			}
			ENDCG
		}
	}
}
