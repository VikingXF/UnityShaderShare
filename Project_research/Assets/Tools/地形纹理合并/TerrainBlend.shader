Shader "Unlit/TerrainBlend"
{
    Properties
    {      
		_BlockMainTex("BlockMainTex", 2D) = "white" {}
		_BlendTex ("BlendTex", 2D) = "white" {}
		_BlockScale("BlockScale", float) = 0.5 
		
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
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;

            };

            sampler2D _BlendTex,_BlockMainTex;
            float4 _BlendTex_ST,_BlockMainTex_ST;
			float	_BlockScale;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
			
                o.uv = TRANSFORM_TEX(v.uv, _BlockMainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                
				
				float2 encodedIndices = tex2D(_BlendTex, i.uv).xy;

				float2 twoVerticalIndices = floor((encodedIndices * 16.0));
				float2 twoHorizontalIndices = (floor((encodedIndices * 256.0)) - (16.0 * twoVerticalIndices));

				float4 decodedIndices;
				decodedIndices.x = twoHorizontalIndices.x;
				decodedIndices.y = twoVerticalIndices.x;
				decodedIndices.z = twoHorizontalIndices.y;
				decodedIndices.w = twoVerticalIndices.y;
				decodedIndices = floor(decodedIndices/4)/4;
				
				float3 worldPos = normalize(mul(unity_ObjectToWorld, i.vertex));
				
				float blendRatio = tex2D(_BlendTex, i.uv).z;
				float2 worldScale = (worldPos.xz * _BlockScale);
				float2 worldUv = 0.234375 * frac(worldScale) + 0.0078125; // 0.0078125 ~ 0.2421875, the range of a block
				
				float2 dx = clamp(0.234375 * ddx(worldScale), -0.0078125, 0.0078125);
				float2 dy = clamp(0.234375 * ddy(worldScale), -0.0078125, 0.0078125);
				
				float2 uv0 = worldUv.xy + decodedIndices.xy;
				float2 uv1 = worldUv.xy + decodedIndices.zw;
				
                // Sample the two texture
				float4 col0 = tex2D(_BlockMainTex, uv0, dx, dy);
				float4 col1 = tex2D(_BlockMainTex, uv1, dx, dy);
				// Blend the two textures
				float4 col = lerp(col0, col1, blendRatio);
			   
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
