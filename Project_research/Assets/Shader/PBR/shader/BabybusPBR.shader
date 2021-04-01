Shader "Babybus/PBR/BabybusPBR"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //Specular	
        [Header(Specular)]
        _SpecularRate("Specular Rate", Range(0, 5)) = 1
        _Gloss("Specular Gloss", Range(0, 50)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

           // #include "UnityLightingCommon.cginc"			
            //#include "AutoLight.cginc"
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir: TEXCOORD2;
                float3 viewDir: TEXCOORD3;
                float3 lightDir: TEXCOORD4;

                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            //Specular
            float _SpecularRate, _Gloss;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));
                o.viewDir = normalize(_WorldSpaceCameraPos.xyz - o.posWorld.xyz);
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz);

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
               
                // 反射光的方向
                fixed3 reflectDir = normalize(reflect(-i.lightDir, i.normalDir)); // 参数：平行光的入射方向，法线方向。而lightDir光照方向是从模型表面到光源的，所以取负数。
  
                /*
                 * 高光反射Specular = 直射光 * pow(max(0, cos(反射光方向和视野方向的夹角)), 高光反射参数)
                 */
                fixed3 specular = pow(max(dot(reflectDir, i.viewDir), 0), _Gloss)* _SpecularRate;


                //Specular
                // float3 halfVector = normalize(i.lightDir + i.viewDir);
                 //float3 directSpecular = pow(max(0, dot(halfVector, normalize(i.normalDir))), _Gloss);
                 //float  specular = directSpecular * _SpecularRate;

                 col.rgb += specular;

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
