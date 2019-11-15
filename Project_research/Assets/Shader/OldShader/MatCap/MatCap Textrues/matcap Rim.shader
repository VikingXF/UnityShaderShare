// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*********************************************************************

实现灯泡效果
Rim+matcap效果

**********************************************************************/

Shader "Babybus/Unlit/matcap Rim"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MatCap("Ramp Texture", 2D) = "white" {}	
		_RimColor("RimColor",Color) = (0,0,0,1)
		_RimPower("RimPower",Range(0,5)) = 0.5		
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
				float2 cap    : TEXCOORD1;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float2 cap    : TEXCOORD1;				
				float4 vertex : SV_POSITION; 
				float3 Normal : TEXCOORD2;
				float3 viewDir : TEXCOORD3;
			};

			sampler2D _MainTex,_MatCap;
			float4 _MainTex_ST;
			float2 cap ;
			float3 _RimColor;
			fixed  _RimPower;
			
			v2f vert (appdata v)
			{
				v2f o;				
				o.Normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = WorldSpaceViewDir(v.vertex);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				half2 capCoord;
                capCoord.x = dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal);
                capCoord.y = dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal);
                o.cap = capCoord * 0.5 + 0.5;
				
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 mc = tex2D(_MatCap, i.cap);
				
				float rim = 1.0 - saturate(dot(normalize(i.viewDir), normalize(i.Normal))); 
				col.rgb = col.rgb +_RimColor * pow (rim, _RimPower)+ (mc.rgb*1.2)-1.0; 
				
				return col;
				//return col;
			}
			ENDCG
		}
	}
}
