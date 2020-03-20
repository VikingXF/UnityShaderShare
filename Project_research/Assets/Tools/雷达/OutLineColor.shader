

Shader "Babybus/Special/OutLineColor" {
Properties {
	_Color("Main Color", Color) = (1,1,1,1)
	_OutlineColor("Outline Color", Color) = (0,0,0,0)
	_Outline("Outline", Range(0, 20.0)) = .01
	
}

SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 100

    //ZWrite Off
    //Blend SrcAlpha OneMinusSrcAlpha

    Pass {

			Cull Back
			//Offset -10, -10
			ZWrite On
			Lighting Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;              
                UNITY_VERTEX_OUTPUT_STEREO
            };


			float4 _Color;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;

                return col;
            }
        ENDCG
    }

	Pass
		{

				Cull Back
				//ZWrite On

				Offset 5, 5

				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				#pragma shader_feature _OUTL_ON


				float _Outline;
				fixed4 _OutlineColor;
			


				struct appdata {
						float4 vertex : POSITION;
						float3 normal : NORMAL;
				};
				struct v2f
				{
					float4 pos:SV_POSITION;
				};
				float4x4 Scale(float scale)
				{
					return float4x4(scale, 0.0, 0.0, 0.0,
									0.0, scale, 0.0, 0.0,
									0.0, 0.0, scale, 0.0,
									0.0, 0.0, 0.0, 1.0);
				}

				v2f vert(appdata_base v)
				{
					v2f o;
					float4 temp = v.vertex;
					temp.xy = mul(Scale(_Outline), temp.xy);
					
					o.pos = UnityObjectToClipPos(temp);
					//o.pos.xy = mul(Scale(_Outline), o.pos.xy);
					return o;
				}

				fixed4 frag(v2f i) :COLOR
				{
					return _OutlineColor;
				}
				ENDCG
			}
}

}
