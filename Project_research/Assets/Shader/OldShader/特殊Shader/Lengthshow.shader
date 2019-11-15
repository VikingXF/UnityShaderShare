// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
xf
2017-11-1
实现木头修补效果
_FlowX：线框向X轴速度
_Rang：控制线框跟完整贴图的插值
_length：实现沿着X轴方向的裁切

*/

Shader "Babybus/LittleGame/LengthShow"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RimColor("Rim Color", Color) = (0.26,0.19,0.16,0.0)
		_RimPower("Rim Power", Range(0,8.0)) = 0.7
		_length("length", float) = -1.18
		_MainColor("MainColor",Color) = (0.26,0.19,0.16,0.0)
	}
	SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite On
	Blend SrcAlpha OneMinusSrcAlpha 
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				float3 normalDir : TEXCOORD2;
				float4 posWorld : TEXCOORD3;

			};

			sampler2D _MainTex,_LineTex;
			float4 _MainTex_ST;
	
			fixed4 _RimColor,_Color,_MainColor;
			fixed _RimPower;
			fixed _length;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.normalDir = UnityObjectToWorldNormal(v.normal);
				//o.posWorld = mul(unity_ObjectToWorld, v.vertex);
					o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 Rim = (pow(1.0-max(0,dot(i.normalDir, viewDirection)),_RimPower)*_RimColor);

				//float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
				float4 objPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));

				clip(pow((objPos.y-i.posWorld.y-_length),1.0) - 0.93);
				//clip(pow((i.posWorld.y-objPos.y   - _length), 1.0) - 0.93);
				
				fixed4 Maincol = tex2D(_MainTex, i.texcoord);				
				//_Color.rgb += Rim;
				Maincol = Maincol*_MainColor;
				return Maincol;
			}
		ENDCG
	}
}
}
