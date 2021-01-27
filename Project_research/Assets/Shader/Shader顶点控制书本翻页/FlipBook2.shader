// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Unlit alpha-cutout shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/Special/FlipBook2" {
Properties {
    _MainPage ("Page", 2D) = "white" {}
	_PageAngle ("CurPageAngle", Range(0,1)) = 0 
    _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}
SubShader {
    Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
    LOD 100
	Cull off
    Lighting Off

    Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
			#define pi 3.1415926
            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainPage;
            float4 _MainPage_ST;
			float _PageAngle;
            fixed _Cutoff;

			float4 flip_book(float4 vertex)
			{
				float4 temp = vertex;

				float theta = _PageAngle * pi;
				float flipCurve = exp(-0.1 * pow(vertex.x, 2)) * _PageAngle;
				theta += flipCurve;

				temp.x = vertex.x * cos(clamp(theta, 0, pi));
				temp.y = vertex.x * sin(clamp(theta, 0, pi));

				vertex = temp;

				return vertex;
			}

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainPage);
				
				float4 vertex = flip_book(v.vertex);
				
                o.vertex = UnityObjectToClipPos(vertex);
                
				
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainPage, i.texcoord);
                clip(col.a - _Cutoff);

                return col;
            }
        ENDCG
    }
}

}
