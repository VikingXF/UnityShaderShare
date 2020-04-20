Shader "Mya/UVTransfrom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Angle("Angle" , float) = 0
        [Toggle] _ScaleOnCenter("Scale On Center", Float) = 1
		_Dissolution("变化",Range(0,1)) = 0
		_line("百叶窗行数",float ) = 5
		_Column("百叶窗列数",float ) = 5
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
            #include "UnityCG.cginc"
            #pragma shader_feature __ _SCALEONCENTER_ON

            struct appdata
            {
                float4 vertex   : POSITION;
                float2 uv       : TEXCOORD0;
            };
            struct v2f
            {
                float4 uv       : TEXCOORD0;
                float4 vertex   : SV_POSITION;
            };

            sampler2D   _MainTex;
            float4      _MainTex_ST;
            half        _Angle;
			float _Dissolution;
			float _line,_Column;
            float2 rotateUV(float2 srcUV,half angle )
            {
                //角度转弧度
                angle/=57.3;
                float2x2 rotateMat;
                rotateMat[0] = float2(cos(angle) , -sin(angle));
                rotateMat[1] = float2(sin(angle) , cos(angle));

                return mul(rotateMat , srcUV);
            }
            float2 TransfromUV(float2 srcUV,half4 argST ,half angle )
            {
                #if _SCALEONCENTER_ON
                    srcUV -= 0.5;
                #endif
                srcUV = rotateUV(srcUV, angle);
                srcUV = srcUV * argST.xy + argST.zw+float2(1,0);
                #if _SCALEONCENTER_ON
                    srcUV += 0.5;
                #endif
                return srcUV;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv , _MainTex);
				o.uv.zw = TransfromUV(v.uv , _MainTex_ST ,_Angle);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv.xy);
				col.a =saturate(col.a - (1-step( i.uv.z % (1/_Column) ,_Dissolution/_Column)));
                return col;
            }
            ENDCG
        }
    }
}