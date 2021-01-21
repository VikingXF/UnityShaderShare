// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/babybus T" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	//_Color1("Color1", Color)= (1,1,1,1)
	//_Color2("Color2", Color)= (1,1,1,1)
	_HueR ("HueR", Range(-1,1)) = 0 
	_HueG ("HueG", Range(-1,1)) = 1.0
    _HueB ("HueB", Range(-1,1)) = 1.0
	_Brightness("Brightness", Range(0,2)) = 1.0
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
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			//float4 _Color1,_Color2;
			half _HueR,_HueG,_HueB,_Brightness;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				col.r += _HueR;
				col.g += _HueG;
				col.b += _HueB; 
				
				col.rgb *=_Brightness;
				//col.rgb = lerp(_Color1.rgb,_Color2.rgb,col.r);

				return col;
			}
		ENDCG
	}
}

}
