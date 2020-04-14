Shader "Babybus/Special/VertexWaveWater"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		
		_TimeScale1("波速1", float) = 1
		_remap("振幅1", Range(0, 100)) = 6.8  //振幅		
		_amplitude1("振幅强度1", Range(0, 10)) = 0   //振幅强度
		_TimeScale2("波速2", float) = 1
		_remap2("振幅2", Range(0, 100)) = 6.8  //振幅
		_amplitude2("振幅强度2", Range(0, 10)) = 0   //振幅强度
    }
    SubShader
    {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
	
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha 
		
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			half _TimeScale1, _remap1, _amplitude1,_amplitude2,_remap2,_TimeScale2;
			
            v2f vert (appdata v)
            {
                v2f o;
				//顶点Y轴sin位移
				fixed4 offset = float4(0, 0, 0, 0);
				offset.y = _amplitude2 * sin((v.uv.x)*_remap2 + _Time.y*_TimeScale2);
				offset.x = _amplitude1 * sin((v.uv.x)*_remap1 + _Time.y*_TimeScale1);
				o.vertex = UnityObjectToClipPos(v.vertex + offset.x+ offset.y);
				
				
                //o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
