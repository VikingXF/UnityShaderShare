// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'

Shader "Shadow/Shadow_0" {
	Properties {
		_ShadowTex ("Shadow", 2D) = "gray" {}
		_FadeTex ("FadeTex", 2D) = "white" {}
		_Indentity ("Indentity", range(0,1)) = 0.3
	}
	SubShader {
		Tags { "Queue"="Transparent" }
		Pass {
			ZWrite Off
			Fog { Color (1, 1, 1) }
			AlphaTest Greater 0
			ColorMask RGB
			Blend DstColor Zero
			Offset -1, -1

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos:POSITION;
				float4 sproj:TEXCOORD0;
				float4 fproj:TEXCOORD1;
				float vdn:TEXCOORD2;
			};

			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;

			sampler2D _ShadowTex;
			sampler2D _FadeTex;

			half _Indentity;

			v2f vert(appdata_base v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.sproj = mul(unity_Projector, v.vertex);
				o.fproj = mul(unity_ProjectorClip, v.vertex);
				float3 wn = UnityObjectToWorldNormal(v.normal);
				o.vdn = max(0, dot(wn, float3(0,1,0)));
				return o;
			}

			float4 frag(v2f i):COLOR{
				float4 c = tex2Dproj(_ShadowTex, UNITY_PROJ_COORD(i.sproj));
				float fade = tex2Dproj(_FadeTex, UNITY_PROJ_COORD(i.sproj)).r;
				float fadeout = tex2Dproj(_FadeTex, UNITY_PROJ_COORD(i.fproj)).g;
				float4 result;
				result.rgb = lerp(fixed3(1,1,1), min(1,1-c.a+_Indentity), fadeout);
				result.rgb += 1 - fade + 1 - i.vdn;
				result.a = 1;
				return result;
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}
