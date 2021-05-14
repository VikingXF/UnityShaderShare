﻿Shader "Babybus/Special/FlipBook3"
{
	Properties
	{
		_MainPage1 ("Page1", 2D) = "white" {}
		_MainPage2 ("Page2", 2D) = "white" {}
		_PageAngle ("CurPageAngle", Range(0,1)) = 0 
		[KeywordEnum(TurnLeft,TurnRight)]_Direction("Direction" , Float) = 0	
	}

	SubShader
	{
			
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE

		#include "UnityCG.cginc"
		#define pi 3.1415926
		#pragma multi_compile _DIRECTION_TURNLEFT _DIRECTION_TURNRIGHT
		
		sampler2D _MainPage1;
		float4 _MainPage1_ST;

		sampler2D _MainPage2;
		float4 _MainPage2_ST;

		float _PageAngle;

		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			//UNITY_FOG_COORDS(1)
			float4 vertex : SV_POSITION;
		};


		float4 flip_book(float4 vertex)
		{
			float4 temp = vertex;

			#if _DIRECTION_TURNLEFT
			float theta = _PageAngle * pi;
			float flipCurve = exp(-0.1 * pow(vertex.x - 0.5, 2)) * _PageAngle;
			theta += flipCurve;
			
			#elif _DIRECTION_TURNRIGHT
			float theta = abs(1-_PageAngle) * pi;
			float flipCurve = exp(-0.1 * pow(vertex.x - 0.5, 2)) * _PageAngle;
			theta -= flipCurve;
			#endif

			temp.x = vertex.x * cos(clamp(theta, 0, pi));
			temp.y = vertex.x * sin(clamp(theta, 0, pi));

			vertex = temp;

			return vertex;
		}

		v2f vert_flip (appdata v)
		{
			v2f o;
			o.uv = TRANSFORM_TEX(v.uv, _MainPage1);
			//o.uv.xy = 1 - o.uv.xy;

			float4 vertex = o.uv.x <= 0.5 ? v.vertex : flip_book(v.vertex);
			o.vertex = UnityObjectToClipPos(vertex);

			return o;
		}

		v2f vert_next_page(appdata v)
		{
		    v2f o;
		    o.uv = TRANSFORM_TEX(v.uv, _MainPage1);
		    //o.uv.y = 1 - o.uv.y;

			o.vertex = UnityObjectToClipPos(v.vertex);

		    return o;
		}
		
		fixed4 frag_flip (v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainPage1, i.uv*_MainPage1_ST.xy+_MainPage1_ST.zw);
			//UNITY_APPLY_FOG(i.fogCoord, col);
			return col;
		}

		fixed4 frag_flip_front (v2f i) : SV_Target
		{
			i.uv.x = 1 - i.uv.x;
			fixed4 col = tex2D(_MainPage2, i.uv*_MainPage2_ST.xy+_MainPage2_ST.zw);
			
			return col;
		}
		fixed4 frag_flip_back (v2f i) : SV_Target
		{
			//i.uv.x = 1 - i.uv.x;
			fixed4 col = tex2D(_MainPage2, i.uv*_MainPage2_ST.xy+_MainPage2_ST.zw);
			return col;
		}

		ENDCG


		//用3个pass来实现翻书的效果
		//第一页
		Pass
		{
			Cull Back

			CGPROGRAM
			#pragma vertex vert_flip
			#pragma fragment frag_flip
			
			ENDCG
		}

		//翻起来的背面
		Pass
		{
			Cull Front
			Offset -3, -3

			CGPROGRAM
			#pragma vertex vert_flip
			#pragma fragment frag_flip_front
			ENDCG
		}

		//第二页
		Pass
		{
			Cull Back
			Offset 3, 3

			CGPROGRAM

			#pragma vertex vert_next_page
			#pragma fragment frag_flip_back

			ENDCG
		}

	}
}
