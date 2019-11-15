// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Babybus/Cutout/AlphaTest-Hue1" {
Properties {

	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	_Cutoff ("Base Alpha cutoff", Range (0,.9)) = .5
    _HueR ("HueR", Range(-1,1)) = 0 
	_HueG ("HueG", Range(-1,1)) = 1.0
    _HueB ("HueB", Range(-1,1)) = 1.0
	_Prow ("Prow", Range(-1,2)) = 1.0

}

SubShader {
	Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
	Lighting off
	
	// Render both front and back facing polygons.
	Cull Off
	
	// first pass:
	//   render any pixels that are more than [_Cutoff] opaque
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutoff;
;
			
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			half _HueR,_HueG,_HueB;
			fixed _Prow;
		
			fixed4 frag (v2f i) : SV_Target
			{
				half4 col = tex2D(_MainTex, i.texcoord);
				
				clip(col.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, col);					
				col.r += _HueR;
				col.g += _HueG;
				col.b += _HueB; 
				
				return col*_Prow;
			}
		ENDCG
	}
		
	
	
}

}
