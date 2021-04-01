Shader "Babybus/Grass/SeaweedVertexAni"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		
		_TimeScale("波速(x/y/z)",vector) = (1,1,1,1)
		_remap("振幅(x/y/z)",vector) = (1,1,1,1)
		_amplitude("振幅强度(x/y/z)",vector) = (1,1,1,1)
        _WindControl("摆动速度(x/y/z)",vector) = (0.02,0.02,0.02,0.5)
        //前面几个分量表示在各个轴向上自身摆动的速度, w表示摆动的强度
    }
    SubShader
    {
        Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
		}
        LOD 100
		Blend SrcAlpha OneMinusSrcAlpha 
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
			float4 _MainTex_ST;
            
			half4 _TimeScale,_remap,_amplitude;
			half4 _WindControl;
			
            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				half4 offset = half4(1,1,1,1);
				offset.x = _amplitude.x*sin(v.uv2.y*_remap.x +_Time.y*_TimeScale.x)*v.uv2.y+sin(_Time.y)*v.uv2.y*_WindControl.x;
				offset.y = _amplitude.y*sin(v.uv2.y*_remap.y +_Time.y*_TimeScale.y)*v.uv2.y+sin(_Time.y)*v.uv2.y*_WindControl.y;
				offset.z = _amplitude.z*sin(v.uv2.y*_remap.z +_Time.y*_TimeScale.z)*v.uv2.y+sin(_Time.y)*v.uv2.y*_WindControl.z;
				
				worldPos.x += offset.x;
				worldPos.y += offset.y;
				worldPos.z += offset.z;

				o.pos = mul(UNITY_MATRIX_VP, worldPos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
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
