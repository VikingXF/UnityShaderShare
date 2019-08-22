Shader "Unlit/cubemap_5Face"
{
    Properties
    {
		_MainCubemap ("MainCubeMap", CUBE) = ""{}  
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
		Cull front
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
                float3 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };


			samplerCUBE _MainCubemap;
			
			inline float3 line_face(float3 WorldPos,float3 ViewDir,float3 P,float3 N)
			{
				float3 lineface = WorldPos+dot((P - WorldPos),N)%dot(ViewDir,N)*normalize(N);
				return lineface;				
			}
			
            v2f vert (appdata v)
            {
                v2f o;
				float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
				float3 worldPos = normalize(mul(unity_ObjectToWorld, v.vertex));
				float3 normalDir = UnityObjectToWorldNormal(v.normal);
				float3 Vnormal = normalize(v.normal);
				
				//dot((worldPos - viewDir),Vnormal)
				
				o.uv = line_face(worldPos,viewDir,float3(-5,0,0),float3(1,0,0)) - float3(0,-5,0);
				
					
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = v.vertex.xyz;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

				fixed4 col = texCUBE(_MainCubemap, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
