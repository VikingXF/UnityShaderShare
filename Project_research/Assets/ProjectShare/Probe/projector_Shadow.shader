Shader "Babybus/projector_Static"
{
    Properties
    {
        _MainTex ("贴图", 2D) = "white" {}
		_MaskTex("Mask贴图", 2D) = "white" {}
		_ShadowIntensity("影子强度", Range(0.0, 5.0)) = 0.5
		
    }
    SubShader
    {
		Tags {"RenderType" = "Opaque"  "LightMode" = "ForwardBase"}
		LOD 100

        Pass
        {

			Blend DstColor one
			//Blend one OneMinusSrcAlpha
			//Blend one one
			offset -1, -1

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
				float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _MaskTex;
            float4 _MainTex_ST, _MaskTex_ST;
			float _ShadowIntensity;
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;

            v2f vert (appdata v)
            {
                v2f o;
				//calculate uv
				float4 pos = mul(unity_Projector, v.vertex);
				float2 texcoord = float2(pos.x / pos.w, pos.y / pos.w);//ignore z
				o.uv.xy = TRANSFORM_TEX(texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(texcoord, _MaskTex);
                o.vertex = UnityObjectToClipPos(v.vertex);

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture				
				float4 Maskcol = tex2D(_MaskTex, i.uv.zw);
				float4 col = tex2D(_MainTex, i.uv.xy)*_ShadowIntensity;
				col = saturate(col*Maskcol.r);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
