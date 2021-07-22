Shader "Unlit/Shining"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MainColor ("Diffuse Color", Color) = (1,1,1,1)
		_ShiningTex ("Shining Texture", 2D) = "white" {}
		_ShiningColor("Shining Color",color) = (1,1,1,1)
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
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 viewDir:TEXCOORD2;
            };

            sampler2D _MainTex,_ShiningTex;
            float4 _MainTex_ST,_ShiningTex_ST;
			fixed4 _MainColor,_ShiningColor;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _ShiningTex);
				float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv.xy)*_MainColor;
				fixed4 Shiningcol = tex2D(_ShiningTex, i.uv.zw);
				fixed4 Shiningcol2 = tex2D(_ShiningTex, i.uv.zw+float2(_Time.y*0.02,0)+ i.viewDir.xy);
				col.rgb += (Shiningcol.rgb*Shiningcol2.rgb*_ShiningColor);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
