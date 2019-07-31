Shader "Unlit/Screen PositionA"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_A("A",float) = 1
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

            #include "UnityCG.cginc"
			#pragma target 3.0

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
               
                //float4 outpos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _A;
            v2f vert (appdata v, out float4 outpos : SV_POSITION )
            {
                v2f o;
                outpos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i,UNITY_VPOS_TYPE screenPos: VPOS) : SV_Target
            {
				screenPos.xy = floor(screenPos.xy * 0.25*_A) * 0.5;
                float checker = -frac(screenPos.r + screenPos.g);               
                clip(checker);

                fixed4 col = tex2D(_MainTex, i.uv);

                return col;
            }
            ENDCG
        }
    }
}
