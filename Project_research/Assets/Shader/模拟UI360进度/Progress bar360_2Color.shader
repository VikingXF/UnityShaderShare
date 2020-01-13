/*

模拟UI360 度时钟进度条效果
2种颜色时钟变化
xf.2020.1.9
可选择4个方向过度
*/

Shader "Babybus/Special/Progress bar360_2Color"
{
	Properties
	{
		_Color1("Color1",Color)= (1,1,1,1)
		_Color2("Color2",Color)= (1,1,1,1)

		_Cutoff ("Alpha cutoff", Range(-0.01,1.01)) = -0.01
		[KeywordEnum(Counterclockwise,clockwise)]_TransFormPoint("Fill Origin" , Float) = 0
		[KeywordEnum(Bottom,Right,Top,Left)]_Direction("Direction" , Float) = 0
		
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
			#pragma shader_feature _TRANSFORMPOINT_COUNTERCLOCKWISE _TRANSFORMPOINT_CLOCKWISE
			#pragma shader_feature _DIRECTION_BOTTOM _DIRECTION_RIGHT _DIRECTION_TOP _DIRECTION_LEFT
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};


			float4 _Color1,_Color2;
			fixed _Cutoff;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv; 				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				float4 col = _Color1;
				
				float2 uv_center = i.uv*2.0-1;	
				
              
				
				#if _DIRECTION_BOTTOM
				float uv_dir = atan2(uv_center.x,uv_center.y)*0.1592357+0.5;
				
				#elif _DIRECTION_TOP
				float uv_dir = atan2(-uv_center.x,-uv_center.y)*0.1592357+0.5;
				
				#elif _DIRECTION_LEFT
				float uv_dir = atan2(uv_center.y,uv_center.x)*0.1592357+0.5;
				
				#elif  _DIRECTION_RIGHT
				float uv_dir = atan2(-uv_center.y,-uv_center.x)*0.1592357+0.5;
				
				#endif
				
				uv_dir = saturate(step(uv_dir,_Cutoff));
				#if _TRANSFORMPOINT_COUNTERCLOCKWISE
				col.rgb = lerp(_Color1,_Color2,uv_dir);
				#elif _TRANSFORMPOINT_CLOCKWISE
				col.rgb = lerp(_Color1,_Color2,1-uv_dir);
				#endif
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
				
				
			}
			ENDCG
		}
	}
}
