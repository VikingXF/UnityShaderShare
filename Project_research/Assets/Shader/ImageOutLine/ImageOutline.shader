

Shader "Babybus/Special/ImageOutline" {
Properties {
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_OutLcolor ("OutLcolor", Color) = (1,1,1,1)  
	_OutL("OutL", Range(0, 0.03)) = 0.01
	[KeywordEnum(Level0,Level1,Level2)]_Smooth("Smooth" , Float) = 0

}

SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 100

    ZWrite Off
    Blend SrcAlpha OneMinusSrcAlpha
	
    
	
	pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fog
			#pragma shader_feature _SMOOTH_LEVEL0 _SMOOTH_LEVEL1 _SMOOTH_LEVEL2  

            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float4 _OutLcolor;
			fixed _OutL;
            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			fixed4 frag(v2f i):COLOR{

				fixed4 c = fixed4(1, 1, 1, 0);

				#if _SMOOTH_LEVEL0

				float4 uv01 = i.uv.xyxy + float4(0, 1, 0, -1)*_OutL;
				float4 uv10 = i.uv.xyxy + float4(1, 0, -1, 0)*_OutL;
				c += tex2D(_MainTex, uv01.xy);
				c += tex2D(_MainTex, uv01.zw);
				c += tex2D(_MainTex, uv10.xy);
				c += tex2D(_MainTex, uv10.zw);

				#elif _SMOOTH_LEVEL1

				float4 uv01 = i.uv.xyxy + float4(0, 1, 0, -1)*_OutL;
				float4 uv10 = i.uv.xyxy + float4(1, 0, -1, 0)*_OutL;
				
				float4 uv23 = i.uv.xyxy + float4(1/2, 1/2, -1/2, -1/2)*_OutL;
				float4 uv32 = i.uv.xyxy + float4(1/2, -1/2, -1/ 2, 1/2)*_OutL;
				
				c += tex2D(_MainTex, uv01.xy);
				c += tex2D(_MainTex, uv01.zw);
				c += tex2D(_MainTex, uv10.xy);
				c += tex2D(_MainTex, uv10.zw);

				c += tex2D(_MainTex, uv23.xy);
				c += tex2D(_MainTex, uv23.zw);
				c += tex2D(_MainTex, uv32.xy);
				c += tex2D(_MainTex, uv32.zw);

				#elif _SMOOTH_LEVEL2

				float4 uv01 = i.uv.xyxy + float4(0, 1, 0, -1)*_OutL;
				float4 uv10 = i.uv.xyxy + float4(1, 0, -1, 0)*_OutL;
				
				float4 uv23 = i.uv.xyxy + float4(1/2, 1/2, -1/2, -1/2)*_OutL;
				float4 uv32 = i.uv.xyxy + float4(1/2, -1/2, -1/ 2, 1/2)*_OutL;

				float4 uv45 = i.uv.xyxy + float4(1/1.7, 1/1.7, -1/1.7, -1/1.7)*_OutL;
				float4 uv54 = i.uv.xyxy + float4(1/1.7, -1/1.7, -1/1.7, 1/1.7)*_OutL;

				c += tex2D(_MainTex, uv01.xy);
				c += tex2D(_MainTex, uv01.zw);
				c += tex2D(_MainTex, uv10.xy);
				c += tex2D(_MainTex, uv10.zw);

				c += tex2D(_MainTex, uv23.xy);
				c += tex2D(_MainTex, uv23.zw);
				c += tex2D(_MainTex, uv32.xy);
				c += tex2D(_MainTex, uv32.zw);

				c += tex2D(_MainTex, uv45.xy);
				c += tex2D(_MainTex, uv45.zw);
				c += tex2D(_MainTex, uv54.xy);
				c += tex2D(_MainTex, uv54.zw);

				#endif
				c.rgb = _OutLcolor.rgb;			
				c.a *= _OutLcolor.a;

				return c;
			}
			
        ENDCG
    }
	Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.texcoord);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
        ENDCG
    }
}

}
