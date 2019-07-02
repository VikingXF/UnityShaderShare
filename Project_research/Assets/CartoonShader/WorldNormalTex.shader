Shader "Unlit/WorldNormalTex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MainNormalTex("NormalTex",2D) = "white"{}
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

            #include "Lighting.cginc"
			
            struct appdata
            {
                 float4 vertex : POSITION; 
				 float2 uv : TEXCOORD0; 
				 float3 normal:NORMAL; 
				 float4 tangent:TANGENT;

            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 T2W0 :TEXCOORD2 ;
                float4 T2W1 :TEXCOORD3 ;
				float4 T2W2 :TEXCOORD4 ;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _MainNormalTex;
            float4 _MainNormalTex_ST;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv,_MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv,_MainNormalTex);
				
                UNITY_TRANSFER_FOG(o,o.vertex);
				
				float3 worldPos = mul(unity_ObjectToWorld,v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldTangent = UnityObjectToWorldDir(v.tangent);
				float3 worldBitangent = cross(worldNormal ,worldTangent) * v.tangent.w;
				o.T2W0 = float4 (worldTangent.x,worldBitangent.x,worldNormal.x,worldPos .x);
				o.T2W1 = float4 (worldTangent.y,worldBitangent.y,worldNormal.y,worldPos .y); 
				o.T2W2 = float4 (worldTangent.z,worldBitangent.z,worldNormal.z,worldPos .z);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
			
				float3 worldPos = float3(i.T2W0.w,i.T2W1.w,i.T2W2.w); 
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos)); 
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos)); 
				fixed4 tangentNormal = tex2D(_MainNormalTex,i.uv.zw); 
				fixed3 bump = UnpackNormal(tangentNormal); 
				fixed3 worldBump = normalize(half3( dot(i.T2W0.xyz,bump), dot(i.T2W1.xyz,bump), dot(i.T2W2.xyz,bump))); 
				float3 albedo = tex2D(_MainTex,i.uv.xy).rgb; 
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT; 
				fixed3 diffuse = _LightColor0.rgb * albedo* max(0,dot(worldBump,lightDir)); 
				fixed3 halfDir = normalize(lightDir+viewDir); 
				fixed3 specular = _LightColor0.rgb * pow(max(0,dot(worldBump,halfDir)),20); 
				
				 // apply fog
                UNITY_APPLY_FOG(i.fogCoord, ambient);
				return fixed4( diffuse+ambient+specular,1.0);
            }
            ENDCG
        }
    }
}
