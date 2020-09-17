Shader "Unlit/csSSS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_RampTex ("RampTexture", 2D) = "white" {}
		[LightDir]_LightDir("Light Dir" , Vector) = (0,0,-1,0)		
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
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex,_RampTex;
            float4 _MainTex_ST;
			half4 _LightDir;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				
				//001===========================
				float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
				float3  viewnormal = normalize(v.normal);				
				float3  Light = normalize(_LightDir);
				
				float  Fil = 0.8*dot(viewDir,viewnormal);
				float  LFil = 0.3*dot(Light,viewnormal)+0.5;
				o.uv.zw = float2(Fil,LFil);
				
				//001===========================
				
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv.xy);
				
				fixed4 Rampcol = tex2D(_RampTex, i.uv.zw);
				col *=Rampcol;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
