Shader "Unlit/MOLIsss"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_DiffuseWrap ("Diffuse Wrap", Vector) = (0.75, 0.375, 0.1875, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "IgnoreProjector" = "True" "LightMode" = "ForwardBase" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"
			//#pragma multi_compile_fwdbase
			//#include "AutoLight.cginc"
			#include "Lighting.cginc"
			
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;				
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                //UNITY_FOG_COORDS(1)
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				float3 normalDir : TEXCOORD3;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			uniform float3 _DiffuseWrap;
            v2f vert (appdata v)
            {
				TANGENT_SPACE_ROTATION;
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.viewDir = mul(rotation, ObjSpaceLightDir(v.vertex));
				o.normalDir = mul(rotation,v.normal);
				o.lightDir = mul(rotation, ObjSpaceViewDir(v.vertex));
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				
				float3 L = normalize(i.lightDir);
				float3 V = normalize(i.viewDir);
				float3 N = normalize(i.normalDir);
				float ldn = dot(L, N);
				
				float diffuseWeightFull = max(ldn, 0.0);
				float diffuseWeightHalf = max(0.5 * ldn + 0.5, 0.0);
				float3 diffuseWeight = lerp(diffuseWeightFull.xxx, diffuseWeightHalf.xxx, _DiffuseWrap);
				float3 diffColor = diffuseWeight * _LightColor0.rgb;
				
				
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col * float4(diffColor, 1);
            }
            ENDCG
        }
    }
}
