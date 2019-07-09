Shader "Babybus/Unlit/ColorMask0"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,0)
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 100
		ColorMask 0
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

			fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col = _Color;
				UNITY_OPAQUE_ALPHA(col.a);
                return col;
            }
            ENDCG
        }
    }
}
