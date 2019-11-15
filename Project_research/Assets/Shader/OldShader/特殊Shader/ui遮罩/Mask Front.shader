// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Babybus/UI/Mask Front" {
	Properties
	{
		_MainTex ("MaskTex", 2D) = "white" {}
		_Color ("Color", Color) = (0,0,0,0.5)
	}
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha 
        Pass {
            Stencil {
                Ref 2
                Comp always
                Pass replace
            }
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#include "UnityCG.cginc"
            struct appdata {
                float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
            };
            struct v2f {
                float4 pos : SV_POSITION;
				half2 texcoord : TEXCOORD0;
            };
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
            v2f vert(appdata v) {
                v2f o;
                o.pos  = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
            half4 frag(v2f i) : SV_Target {
				fixed4 col = tex2D(_MainTex, i.texcoord);
				col.a -= _Color.a ;
                return col;
            }
            ENDCG
        }
    } 
}