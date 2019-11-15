// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Babybus/UI/Mask Back" {
	Properties
	{
		
		_Color ("Color", Color) = (0,0,0,0.5)
		
	}
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha 
        Pass {
            Stencil {
                Ref 2
                Comp NotEqual
                Pass keep 
                ZFail decrWrap
            }
        
           CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata {
                float4 vertex : POSITION;

            };
            struct v2f {
                float4 pos : SV_POSITION;

            };
			sampler2D _MainTex;
			float4 _Color;
            v2f vert(appdata v) {
                v2f o;
                o.pos  = UnityObjectToClipPos(v.vertex);

                return o;
            }
            half4 frag(v2f i) : SV_Target {
				
                return _Color;
            }
            ENDCG
        }
    } 
}