// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/Gray/Texture Grey_2Texture(pos)Transparent" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_MainColor("Color", Color) = (1,1,1,1)
	_GreyColor("GreyColor", Color) = (1,1,1,1)
	_saturation ("saturation", Range(0,1)) = 0
	_Intensity ("Intensity", Range(0,2)) = 1
	_length("length",Range(-2,2)) = 1
	_BlendRange("Blend Range" , Range(0,1)) = 1
	[KeywordEnum(Center,Bottom,Right,Top,Left,Before,After)]_TransFormPoint("Fill Origin" , Float) = 0
}

SubShader {
	Tags {  "Queue"="Transparent"
            "RenderType"="TransparentCutout" }
	LOD 100
	Blend SrcAlpha OneMinusSrcAlpha
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma shader_feature _TRANSFORMPOINT_CENTER _TRANSFORMPOINT_BOTTOM _TRANSFORMPOINT_RIGHT _TRANSFORMPOINT_TOP _TRANSFORMPOINT_LEFT _TRANSFORMPOINT_BEFORE _TRANSFORMPOINT_AFTER
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float3 posWorld :TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Intensity,_saturation;
			float4 _MainColor,_GreyColor;
			float _length,_BlendRange;
			v2f vert (appdata_t v)
			{
				v2f o;
				//o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.posWorld = v.vertex.xyz;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);			
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.texcoord);
				
				float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));				
				half4 col = half4(float3(gray, gray, gray)*_Intensity,color.a)*_GreyColor;	
				col = lerp(col,color,_saturation);
				
				#if _TRANSFORMPOINT_CENTER
				color = lerp(color,col,_BlendRange);
				
				#elif _TRANSFORMPOINT_RIGHT 
				color = lerp(color,col,saturate(1- (i.posWorld.x + _length ) /_BlendRange));
				
				#elif _TRANSFORMPOINT_LEFT

				color = lerp(color,col,saturate((i.posWorld.x + _length ) /_BlendRange));
				
				#elif _TRANSFORMPOINT_BOTTOM

				color = lerp(color,col,saturate((i.posWorld.y + _length ) /_BlendRange));
				
				#elif _TRANSFORMPOINT_TOP 

				color = lerp(color,col,saturate(1- (i.posWorld.y + _length ) /_BlendRange));
			
				#elif _TRANSFORMPOINT_BEFORE 	

				color = lerp(color,col,saturate(1- (i.posWorld.z + _length ) /_BlendRange));
				#elif _TRANSFORMPOINT_AFTER
				color = lerp(color,col,saturate(1- (i.posWorld.z + _length ) /_BlendRange));
				#endif
				
		
				UNITY_APPLY_FOG(i.fogCoord, color);				
				return saturate(color*_MainColor);
			}
		ENDCG
	}
}

}
