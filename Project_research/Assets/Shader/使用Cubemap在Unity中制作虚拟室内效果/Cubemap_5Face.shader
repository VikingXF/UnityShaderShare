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
			half4 _Tex_HDR;
			
			inline float3 line_face(float3 WorldPos,float3 ViewDir,float3 P,float3 N)
			{
				float s = dot((P - WorldPos),N)%dot(ViewDir,N);
				float3 lineface = s*normalize(N)+WorldPos;
				return lineface;				
			}
			
            v2f vert (appdata v)
            {
                v2f o;
				
				float3 worldPos = normalize(mul(unity_ObjectToWorld, v.vertex));
				float3 viewDir = UnityWorldSpaceViewDir(worldPos);
				float3 normViewDir = normalize(viewDir);
				
				float3 normalDir = UnityObjectToWorldNormal(v.normal);
				float3 Vnormal = normalize(v.normal);
				
				//dot((worldPos - viewDir),Vnormal)
				float3 lineface = line_face(worldPos,normViewDir,float3(-5,0,0),float3(1,0,0))- float3(0,-5,0);
				//float3 Break =  floor(abs(lineface/5));				
				float mask = 1-saturate(max(floor(abs(lineface/5)).y,floor(abs(lineface/5)).z));
				o.uv = lineface;
					
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = v.vertex.xyz;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

				fixed4 col = texCUBE(_MainCubemap, i.uv);
				//fixed4 col = fixed4(DecodeHDR (tex, _Tex_HDR),1);
				
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
