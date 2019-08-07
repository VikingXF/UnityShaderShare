// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/Unlit/Texture Mirror" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_Ref ("For Mirror reflection,don't set it!", 2D) = "white" {}
	_RefRate ("Reflective Rate", Range (0, 1)) = 1
	_RefColor("Reflection Color",Color) = (1,1,1,1)
	_Distance ("Distance", Float) = 0.001
	_Pow ("Pow", Float) = 0.001
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 screenPos : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Ref;
			float4 _Ref_ST;
			half _RefRate;
			fixed4 _RefColor;
			fixed _Pow;
			float _Distance;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.screenPos = ComputeScreenPos(o.vertex);
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 screenUV = i.screenPos.xy / i.screenPos.w;
				fixed4 ref = tex2D(_Ref, screenUV);
				float distance = _Distance;
				ref += tex2D(_Ref, half2(screenUV.x + distance , screenUV.y + distance ));
				ref += tex2D(_Ref, half2(screenUV.x + distance , screenUV.y)) ;
				ref += tex2D(_Ref, half2(screenUV.x , screenUV.y + distance ));
				ref += tex2D(_Ref, half2(screenUV.x - distance , screenUV.y - distance )) ;
				ref += tex2D(_Ref, half2(screenUV.x + distance , screenUV.y - distance )) ;
				ref += tex2D(_Ref, half2(screenUV.x - distance , screenUV.y + distance )) ;
				ref += tex2D(_Ref, half2(screenUV.x - distance , screenUV.y));
				ref += tex2D(_Ref, half2(screenUV.x , screenUV.y - distance )) ;
				ref.rgb = ref.rgb / 9  * _RefColor.rgb;
				
				fixed4 col = tex2D(_MainTex, i.texcoord);
				col.rgb = lerp(col.rgb,ref.rgb,_RefRate);
				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
		ENDCG
	}
}

}
