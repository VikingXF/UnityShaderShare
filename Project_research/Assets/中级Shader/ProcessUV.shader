Shader "IntermediateShader/ProcessUV"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_GridSize("GridSize",Float) =0.1
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
                float rnd : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };
			float2 Hash12(float2 p) {
				float h=dot(p,float2(127.1,311.7));
				return -1.0 + 2.0*frac(sin(h)*43758.5453123);
			}
            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _GridSize;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				float2 uv = TRANSFORM_TEX(v.uv, _MainTex);
				float2 coord = uv*_GridSize;
				if (abs(fmod(coord.y,2.0))<1.0) //让格子交错
				coord.x += 0.5;
				
				float2 gridIndex = float2(floor(coord));
				o.rnd = Hash12(gridIndex);//根据ID 获取hash值
				
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col = fixed4(i.rnd,0,0,1);
				
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
