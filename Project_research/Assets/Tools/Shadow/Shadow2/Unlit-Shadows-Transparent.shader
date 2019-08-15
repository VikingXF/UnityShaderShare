// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/Unlit/Unlit-Shadows-Transparent" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Color ("Main Color", Color) = (1,1,1,1)
	[Toggle] _Transition ("Invert Transition?", Float) = 0
	[KeywordEnum(XL,XR,YL,YR)]_AxialXY("X Y axial" , Float) = 0
	_Transitions("Transitions", float) = 0
	_BlendRange("Blend Range" , Range(0,1)) = 1
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#pragma shader_feature _TRANSITION_ON
			#pragma shader_feature _AXIALXY_XL _AXIALXY_XR _AXIALXY_YL _AXIALXY_YR
			
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed _Transition,_Transitions,_BlendRange;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord.zw = v.texcoord;
				
				
			
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 Maincol = tex2D(_MainTex, i.texcoord.xy);
				
				#if _TRANSITION_ON
				
				#if _AXIALXY_XL				
				Maincol.a *= saturate((i.texcoord.z-_Transitions)/_BlendRange);
				
				#elif _AXIALXY_YL
				Maincol.a *= saturate((i.texcoord.w-_Transitions)/_BlendRange);
				
				#elif _AXIALXY_XR				
				Maincol.a *= saturate((-i.texcoord.z-_Transitions)/_BlendRange);
				
				#elif _AXIALXY_YR
				Maincol.a *= saturate((-i.texcoord.w-_Transitions)/_BlendRange);
				
				#endif
				
				#endif
				
				
				fixed4 col = fixed4(_Color.rgb,_Color.a*Maincol.a);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
}

}
