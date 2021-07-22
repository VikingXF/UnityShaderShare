Shader "Babybus/Special/Stickers"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_LRCockDir("L(0)orR(1)翘起" , Range(0, 1)) = 0
		_CockAngle ("Cock Angle", Range(0,0.5)) = 0		
		//_Cutoff ("Base Alpha cutoff", Range (0,0.98)) = .5
		_UVAngle("UV Angle" , Range(0, 360)) = 0	
	}

	SubShader
	{
		//Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		//Tags {"RenderType"="Opaque""IgnoreProjector"="True" }
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		CGINCLUDE

		#include "UnityCG.cginc"
		#define pi 3.1415926

		
		sampler2D _MainTex;
		float4 _MainTex_ST;

		float _CockAngle;
		//float _Cutoff;
		half  _UVAngle;
		half _LRCockDir;
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

		//UV中心旋转
		float2 rotateUV(float2 srcUV,half angle )
		{
			//角度转弧度
			angle/=57.3;
			float2x2 rotateMat;
			rotateMat[0] = float2(cos(angle) , -sin(angle));
			rotateMat[1] = float2(sin(angle) , cos(angle));
			srcUV -=0.5;
			srcUV = mul(rotateMat , srcUV);
			srcUV +=0.5;
			return srcUV;
		}

		float4 Stickers(float4 vertex,fixed UDCockDir)
		{
			float4 temp = vertex;

			float theta = _CockAngle * pi;
			float flipCurve = exp(-0.1 * pow(vertex.x-0.5, 2)) * _CockAngle;
			theta -= flipCurve;

			temp.x = vertex.x * cos(clamp(theta, 0, pi));
			temp.y = UDCockDir*vertex.x * sin(clamp(theta, 0, pi));
			
			vertex = temp;

			return vertex;
		}

		v2f vert_flip (appdata v)
		{
			v2f o;			
			o.uv.xy = rotateUV(TRANSFORM_TEX(v.uv, _MainTex),_UVAngle);
			float4 vertex = v.uv.x <= 0.5 ? lerp(Stickers(v.vertex,1),v.vertex,_LRCockDir) : lerp(v.vertex,Stickers(v.vertex,-1),_LRCockDir) ;		
			o.vertex = UnityObjectToClipPos(vertex);

			return o;
		}

		
		fixed4 frag_flip (v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.uv);
			//UNITY_APPLY_FOG(i.fogCoord, col);
			//clip(col.a - _Cutoff);
			return col;
		}

		ENDCG

		Pass
		{
			//Cull Back
			Cull off
			CGPROGRAM
			#pragma vertex vert_flip
			#pragma fragment frag_flip
			
			ENDCG
		}


	}
}
