Shader "Babybus/BeautifyNails"
{
    Properties
    {
		[KeywordEnum(First, Second)] _Steps ("操作步骤", Float) = 0
        _RoughTex ("粗糙指甲贴图", 2D) = "white" {}
		_SmoothTex ("修好的指甲透明贴图", 2D) = "white" {}
		_Switch ("修剪指甲", Range(0, 1)) = 0
		_highlights ("highlights", 2D) = "white" {}
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
			#pragma shader_feature _STEPS_FIRST _STEPS_SECOND
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
            };

            sampler2D _RoughTex,_SmoothTex,_highlights;
            float4 _RoughTex_ST;
			fixed _Switch;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _RoughTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 Roughcol = tex2D(_RoughTex, i.uv);
				fixed4 Smoothcol = tex2D(_SmoothTex, i.uv);
				fixed4 highlights = tex2D(_highlights, i.uv);
				float4 Firstcol = Smoothcol;
				Firstcol.rgb = lerp(Smoothcol.rgb,highlights.rgb,highlights.a);
				
				fixed4 col  = lerp(Roughcol,Firstcol,_Switch);
				
				
                return col;
            }
            ENDCG
        }
    }
}
