// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Babybus/Water/Unilt sufacewater"
{
	Properties
	{
		
		_MainTex ("纹理贴图", 2D) = "white" {}
		[Normal]_NormalTex("法线贴图", 2D) = "bump" {}
			
		_WaterColor("水颜色",Color) = (0,.25,.4,1)//水颜色
		_WaveColor("浪颜色",Color) = (0,.25,.4,1)//浪颜色
		_WaveOffset("WaveOffset(xy&zw)",vector)=(.1,.2,-.2,-.1)//波纹流动方向
		
		_NormalScale ("NormalScale", float) = 0.3
		_Speed("Speed", float) = 0.3	

	
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
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float2 uv2 : TEXCOORD2;			
				float4 vertex : SV_POSITION;

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _NormalTex;
			float4 _NormalTex_ST;
			
			sampler2D _RampTex;
			float4 _WaterColor,_WaveColor;

			float4 _WaveOffset;	
			fixed _Speed;
			fixed _NormalScale;

			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _MainTex)+ _WaveOffset.zw * (_Time.x%100);
				o.uv2 = TRANSFORM_TEX(v.uv, _NormalTex);
			
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//采样法线贴图
				float4 normalCol = (tex2D(_NormalTex, i.uv2 + fixed2((_Time.x%100)*_Speed, 0)) + tex2D(_NormalTex, fixed2((_Time.x%100)*_Speed + i.uv2.y, i.uv2.x))) / 2;			
				float3 worldNormal = UnpackNormal(normalCol);
				worldNormal = lerp(float3(0, 0, 1), worldNormal, _NormalScale);
		
				// sample the texture
				float4 col = tex2D(_MainTex, i.uv.xy+worldNormal+ _WaveOffset.xy * (_Time.x%100))*0.01+tex2D(_MainTex, i.uv.zw*0.7+worldNormal)*0.025;
				col.rgb = lerp(_WaterColor.rgb,_WaveColor.rgb*3,col.r);
				col.a = _WaterColor.a;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
