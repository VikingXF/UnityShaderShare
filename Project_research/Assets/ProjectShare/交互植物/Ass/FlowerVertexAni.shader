Shader "Babybus/FlowerVertexAni"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
      
        _WindControl("WindControl(x:XSpeed y:YSpeed z:ZSpeed w:windMagnitude)",vector) = (0.02,0.02,0.02,0.5)
        //前面几个分量表示在各个轴向上自身摆动的速度, w表示摆动的强度
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                //float3 tempCol : TEXCOORD1;//用来测试传递noise贴图采样的结果
            };

            sampler2D _MainTex;
            
            half4 _WindControl;


            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				worldPos.x += sin(_Time.y)*v.uv2.y*_WindControl.x;
				worldPos.y += sin(_Time.y)*v.uv2.y*_WindControl.y;
				worldPos.z += sin(_Time.y)*v.uv2.y*_WindControl.z;
				o.pos = mul(UNITY_MATRIX_VP, worldPos);
                o.uv = v.uv;
                //o.tempCol = waveSample;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                //return fixed4(frac(i.tempCol.x), 0, 0, 1);
                return col;
            }
            ENDCG
        }
    }
}
