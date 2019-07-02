Shader "Babybus/InternationalRestaurant/RestaurantWater"
{
    Properties
    {

		_WaterColor("WaterColor", Color) = (0.6,0.6,0.6,1.0)
		_LightDir("光照方向", vector) = (3, -7, 0, 0)
		_HColor("Highlight Color", Color) = (0.6,0.6,0.6,1.0)
		
		//SPECULAR
		//_SpecColor("Specular Color", Color) = (0.6,0.6,0.6,1.0)
		_Shininess ("Shininess", Range(0.01,2)) = 0.1
	
    }
    SubShader
    {
       Tags { "Queue"="Transparent+1" "IgnoreProjector"="True" "RenderType"="Transparent" }
        LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite On
		
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
			
            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				
            };

            struct v2f
            {

                //UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 T2W0 :TEXCOORD2 ;
                float4 T2W1 :TEXCOORD3 ;
                float4 T2W2 :TEXCOORD4 ;
				
            };


			half4 _LightDir;
			fixed4 _WaterColor,_HColor;
			//fixed4 _SpecColor;
			fixed _Shininess;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);               				
                //UNITY_TRANSFER_FOG(o,o.vertex);

				float3 worldPos = mul(unity_ObjectToWorld,v.vertex); 
				float3 worldNormal = UnityObjectToWorldNormal(v.normal); 
				float3 worldTangent = UnityObjectToWorldDir(v.tangent); 
				float3 worldBitangent = cross(worldNormal ,worldTangent) * v.tangent.w; 
				// 一个插值寄存器最多存储float4大小的变量 
				o.T2W0 = float4 (worldTangent.x,worldBitangent.x,worldNormal.x,worldPos .x); 
				o.T2W1 = float4 (worldTangent.y,worldBitangent.y,worldNormal.y,worldPos .y); 
				o.T2W2 = float4 (worldTangent.z,worldBitangent.z,worldNormal.z,worldPos .z);
				
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				
                fixed4 col = _WaterColor;
				float3 worldPos = float3(i.T2W0.w,i.T2W1.w,i.T2W2.w); 
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos)); 
				
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				fixed3 worldNormal = float3(i.T2W0.z,i.T2W1.z,i.T2W2.z);
				//计算光照
				//fixed3 lightDir = normalize(_LightDir); 
				lightDir = normalize(lightDir); 
				fixed3 ndl = max(0, dot(worldNormal, lightDir)*0.5 + 0.5)*_HColor;
				col.rgb +=ndl;
				//计算光照结束
				
				//计算反射高光
				fixed3 halfDir = normalize(lightDir+viewDir);
				fixed3 specular = _LightColor0.rgb *  pow(max(0,dot(worldNormal,halfDir*_Shininess)),20);
	
				col.rgb +=specular;
				
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
