Shader "Babybus/Specila/InhalePoint"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Control("Control Inhale",Range(0,2))=0
		_Scope("Scope",Range(0,50))=0
		_InhalePos("Inhale Postion",Vector) =(0,0,0,0)
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
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                ///UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _InhalePos;
			float _Scope,_Control;
            v2f vert (appdata v)
            {
                v2f o;
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				float dist = length( worldPos-_InhalePos);
				float normalizedDist = saturate(dist/_Scope);

				float val = max(0,_Control-normalizedDist);

				float3 toInhalePos = mul(unity_WorldToObject, (_InhalePos-worldPos)).xyz;
				
				float3 Vertex = v.vertex.xyz;
				
				v.vertex.xyz += toInhalePos*val;
				
				if(length(v.vertex.xyz - Vertex) > dist){
					v.vertex.xyz = Vertex+ toInhalePos;
				}
				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
