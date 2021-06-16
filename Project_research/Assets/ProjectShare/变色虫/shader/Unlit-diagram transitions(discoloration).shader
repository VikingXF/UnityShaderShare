/*
根据模型从不同方向过渡2张贴图，第2张贴图跟第3张贴图根据第3张贴图透明度进行混合，通过数值分别单独控制第2张贴图跟第3张贴图透明
xf.2018.10.30

*/

Shader "Babybus/Special/Unlit-diagram transitions(discoloration)" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_MainTex2 ("Base (RGBA)2", 2D) = "white" {}
	_Alpha1("Alpha（控制Base (RGBA)2）",  Range(0, 1)) = 1	
	_MainTex3 ("Base (RGBA)3", 2D) = "white" {}
	_Alpha2("Alpha（控制Base (RGBA)3）",  Range(0, 1)) = 1
	_length("length", float) = -1.18	
	_Transitions("Transitions", Range(0, 1)) = 0

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
			
			#include "UnityCG.cginc"
			#pragma shader_feature _TRANSFORMPOINT_CENTER _TRANSFORMPOINT_BOTTOM _TRANSFORMPOINT_RIGHT _TRANSFORMPOINT_TOP _TRANSFORMPOINT_LEFT _TRANSFORMPOINT_BEFORE _TRANSFORMPOINT_AFTER
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				float3 posWorld :TEXCOORD2;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex,_MainTex2,_MainTex3;
			float4 _MainTex_ST;
			fixed _Transitions,_length;
			fixed _Alpha1,_Alpha2;
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
				fixed4 col = tex2D(_MainTex, i.texcoord);
				fixed4 col2 = tex2D(_MainTex2, i.texcoord);
				col2.a *=_Alpha1;
				fixed4 col3 = tex2D(_MainTex3, i.texcoord);
				col3.a *=_Alpha2;
				fixed4 color = lerp(col2,col3,col3.a);
				#if _TRANSFORMPOINT_CENTER
				float _BlendRange =_Transitions;
				
				#elif _TRANSFORMPOINT_RIGHT 
				float _BlendRange = saturate(1- (i.posWorld.x + _length ) /_Transitions);
				
				#elif _TRANSFORMPOINT_LEFT
				float _BlendRange = saturate((i.posWorld.x + _length ) /_Transitions);
				
				#elif _TRANSFORMPOINT_BOTTOM
				float _BlendRange = saturate((i.posWorld.y + _length ) /_Transitions);
				
				#elif _TRANSFORMPOINT_TOP 
				float _BlendRange = saturate(1- (i.posWorld.y + _length ) /_Transitions);
				
				#elif _TRANSFORMPOINT_BEFORE 
				float _BlendRange = saturate((i.posWorld.z + _length ) /_Transitions);
				
				#elif _TRANSFORMPOINT_AFTER
				float _BlendRange = saturate(1- (i.posWorld.z + _length ) /_Transitions);
				
				#endif
								
				col.rgba = lerp(col.rgba,color.rgba,_BlendRange);				
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
}

}
