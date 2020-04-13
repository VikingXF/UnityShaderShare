// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Projector/Water" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_ShadowTex ("Cookie", 2D) = "" {}
		_Speed ("WaterSpeed", float) = 0
	}
	SubShader {
		Tags {"Queue"="Transparent"}
		Pass {
		zwrite off
		Blend SrcAlpha One
		offset -1, -1
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _ShadowTex;
			float4 _Color;
			float _Speed;

			float4x4 unity_Projector;

			struct v2f {
				float4 uvShadow : TEXCOORD0;
				float ldif : TEXCOORD1;
				float4 pos : SV_POSITION;
			};

			struct verInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			v2f vert(verInput v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				float3 vDir = ObjSpaceViewDir(v.vertex);
				float3 wnormal = mul(unity_ObjectToWorld, float4(v.normal, 0));
				o.ldif = max(0, dot(float3(0, 1, 0), wnormal));
				o.uvShadow = mul(unity_Projector, v.vertex);
				return o;
			}

			fixed4 frag(v2f i):COLOR{
				float2 uv = i.uvShadow.xy / i.uvShadow.w;

				fixed4 texS = (tex2D(_ShadowTex, uv + float2(_Time.x * _Speed, 0)) + tex2D(_ShadowTex, uv + float2(0, _Time.x * _Speed))) * 0.5;

				texS.rgb *= _Color.rgb;
				return texS * i.ldif;
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}
