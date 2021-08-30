Shader "MyUnlit/FrameAnimation"
{
    Properties
    {
        _Color("Color Tint",color)=(1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _CutX("CutX Amount",float)=4
        _CutY("CutY Amount",float)=4
        _Speed("Speed",range(0,100))=30
    }
    SubShader
    {
        Tags { "RenderType"="transparent" "queue"="transparent" "ignoreprojector"="true" }
        ZWrite off
        blend srcalpha oneminussrcalpha

        Pass
        {
            Tags{"lightmode"="forwardbase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
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
            fixed4 _Color;
            float _CutX;
            float _CutY;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //取得整数的时间
                float time = floor(_Time.y*_Speed);
                //整除部分为行（因为播放顺序是从左到右，先行后列）
                float row = floor(time / _CutX);
                //余数部分为列
                float column = time - row * _CutX;

                //计算偏移值，其中u向为列索引值，v向为行索引的相反数（播放原点是左上角，而uv采样原点是左下角，所以v向偏移应该取反）
                half2 uv = i.uv + half2(column,-row);
                //除以行列得到最终的采样值
                uv.x /= _CutX;
                uv.y /= _CutY;

                fixed4 col = tex2D(_MainTex,uv);
                col.rgb *= _Color;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Transparent/VertexLit"
}