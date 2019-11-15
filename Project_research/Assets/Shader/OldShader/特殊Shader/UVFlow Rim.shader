/*********************************************************************

实现水的流动效果
添加方向明暗，Rim效果

**********************************************************************/

Shader "Babybus/Unlit/UVFlow Rim"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RimColor("RimColor",Color) = (0,0,0,1)
		_RimPower("RimPower",Range(0,5)) = 0.5
		_FlowX("Flow for X" , float) = 0
		_FlowY("Flow for Y" , float) = 0
		_DirL("DirL",vector)=(0,0,0,0)
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
				float3 normal : NORMAL; 
				
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 Normal : TEXCOORD2;
				//float3 viewDir : TEXCOORD3; 
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;			
			float3 _RimColor;
			fixed  _RimPower;
			fixed _FlowX,_FlowY;
			float3 _DirL;
			v2f vert (appdata v)
			{
				v2f o;
				o.Normal = UnityObjectToWorldNormal(v.normal);
				//o.viewDir = WorldSpaceViewDir(v.vertex);			
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{						
			
				
				fixed4 col = tex2D(_MainTex, i.uv + _Time.y * float2(_FlowX, _FlowY));	
				float rim = 1.0 - saturate(dot(normalize(_DirL), normalize(i.Normal)));
				//float rim = 1.0 - saturate(dot(normalize(i.viewDir), normalize(i.Normal))); 				
				col.rgb = col.rgb +_RimColor * pow (rim, _RimPower); 
				
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
