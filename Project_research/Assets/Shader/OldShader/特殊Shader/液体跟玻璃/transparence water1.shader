// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
xf
2017-10-11

透明液体
水面sin波运动
目标项目：能调颜色的普通透明液体
液体倾斜根据世界坐标做水平
用双pass分别渲染模型内外面，里面稍微亮起造成视觉误差做液面使用
*/
Shader "Babybus/Water/transparence water1"
{
	Properties
	{		
		_high ("high", Range(-0.5, 1.5)) = 0.01738615  //液面高度
        _amplitude ("amplitude", Range(0, 0.1)) = 0   //振幅强度
        _Color ("Color", Color) = (0,0.8333333,1,1)
		_Intensity("Intensity of surface", Range(-1, 10)) = 1.3 //液面亮度
		_Speed("wave Speed", Range(0, 10)) = 1     //波速度
        _Fresnel ("Fresnel", Range(0, 100)) = 5.273504
        _FresnelColor ("FresnelColor", Color) = (0.5,0.5,0.5,1)
        _remap1_oMax ("remap1_oMax", Range(0, 30)) = 11.16234   //振幅1
        _remap2_oMax ("remap2_oMax", Range(0, 30)) = 6.8  //振幅2
		_Scale("Scale", Float) = 900  //振幅2
	}
	SubShader
	{
		Tags {
            "Queue"="Transparent+10"
            "RenderType"="TransparentCutout"
        }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
		
			Cull Back
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag						
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
			};
			
            float _high;
            float _amplitude;
            float4 _Color;
            float _Fresnel;
            float4 _FresnelColor;
            float _remap1_oMax;
            float _remap2_oMax,_Speed;
			float _Scale;
			v2f vert (appdata v)
			{
				v2f o;
				o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
				
				
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				
				float rim = 1.0 - saturate(dot(normalize(i.normalDir), viewDirection)); 
				float3 rimColor = _FresnelColor.rgb * pow (rim, _Fresnel); 
							
				clip((saturate((objPos.g-i.posWorld.g)/_Scale+_high+0.5)+(_amplitude*(sin(i.uv0.r * _remap1_oMax+_Time.y*_Speed)
				+sin( i.uv0.r  * _remap2_oMax +_Time.y*_Speed)))) - 0.5);
				
				float4 Color = _Color;
				Color.rgb += rimColor;
				return Color;
			}
			ENDCG
		}
		
		Pass
		{
			Cull Front 
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag						
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
			};

            float _high;
            float _amplitude;
            float4 _Color;
            float _Fresnel;
            float4 _FresnelColor;
            float _remap1_oMax;
            float _remap2_oMax;
			float _Intensity,_Speed;
			float _Scale;
			v2f vert (appdata v)
			{
				v2f o;
				o.uv0 = v.texcoord0;

                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
				
				
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );              							              		
				clip((saturate((objPos.g-i.posWorld.g)/_Scale+_high+0.5)+(_amplitude*(sin(i.uv0.r * _remap1_oMax+_Time.y*_Speed)
				+sin( i.uv0.r  * _remap2_oMax +_Time.y*_Speed)))) - 0.5);
				float4 Color = _Color;
				Color.rgb +=_Intensity;
				return Color;
			}
			ENDCG
		}
	}
}
