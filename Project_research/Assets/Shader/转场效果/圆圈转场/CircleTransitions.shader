Shader "Babybus/Special/CircleTransitions"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Dissolution("变化", Range(0,1)) = 0
        _RoundPositionX("消失点X轴偏移",Range(-1,1)) = 0
        _RoundPositionY("消失点Y轴偏移",Range(-1,1)) = 0
        [Toggle]_Soft("边缘柔化?", Float) = 0
        _Pow("边缘柔化程度", Range(0,100)) = 10
    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
        LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _SOFT_ON
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Dissolution,_Pow;
            fixed _RoundPositionX, _RoundPositionY;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);   
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float2 screenPos = i.screenPos.xy/i.screenPos.w * _ScreenParams.xy;
                float dir = distance(fixed2(_ScreenParams.xy/2+ _ScreenParams.xy / 2*fixed2(_RoundPositionX, _RoundPositionY)), screenPos);
                
                col.a = step(max(_ScreenParams.x, _ScreenParams.y) * _Dissolution, dir);
                #if _SOFT_ON
                float dir2 = 128*dir/max(_ScreenParams.x, _ScreenParams.y); 
                          
                col.a =saturate(pow((1-lerp(-2,1,_Dissolution))*(dir2),_Pow));
                #endif		
                
                return col;
            }
            ENDCG
        }
    }
}
