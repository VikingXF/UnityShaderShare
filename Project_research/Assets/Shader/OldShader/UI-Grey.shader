// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UI/Default Gray"
{
    Properties
    {
		_MainTex("Sprite Texture", 2D) = "white" {}
		_Brightness("Brightness", Float) = 1
        // required for UI.Mask
        _StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
        _ColorMask("Color Mask", Float) = 15
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }        
        Blend SrcAlpha OneMinusSrcAlpha

        Cull Off ZWrite Off ZTest Always

        Pass
        {

            Stencil
            {
                Ref[_Stencil]
                Comp[_StencilComp]
                Pass[_StencilOp]
                ReadMask[_StencilReadMask]
                WriteMask[_StencilWriteMask]
            }
            ColorMask[_ColorMask]

            CGPROGRAM
            #pragma vertex vert     
            #pragma fragment frag     
            #include "UnityCG.cginc"     

            struct appdata
            {
                float4 vertex   : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
				float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
			fixed _Brightness;
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half4 color = tex2D(_MainTex, i.uv);
                float grey = dot(color.rgb, fixed3(0.22, 0.707, 0.071))*_Brightness;
                return half4(grey,grey,grey,color.a);
            }
            ENDCG
        }
    }
}