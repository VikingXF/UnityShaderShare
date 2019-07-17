Shader "Babybus/Cartoon/Cartoo2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

		//TOONY COLORS
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
		_HColor("Highlight Color", Color) = (0.6,0.6,0.6,1.0)
		_SColor("Shadow Color", Color) = (0.2,0.2,0.2,1.0)

		//TOONY COLORS RAMP
		_RampThreshold("Ramp Threshold", Range(0,1)) = 0.5
		_RampSmooth("Ramp Smoothing", Range(0.01,1)) = 0.1
		
		//SPECULAR
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range(0.01,2)) = 0.1
		_SpecSmooth ("Smoothness", Range(0,1)) = 0.05
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
			#include "AutoLight.cginc"
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 T2W0 :TEXCOORD2 ;
                float4 T2W1 :TEXCOORD3 ;
                float4 T2W2 :TEXCOORD4 ;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;
			fixed4 _HColor;
			fixed4 _SColor;
			float _RampThreshold;
			float _RampSmooth;
			float _Shininess;
			float _SpecSmooth;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
				
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
				float3 worldPos = float3(i.T2W0.w,i.T2W1.w,i.T2W2.w); 
				
				fixed3 worldNormal = float3(i.T2W0.z,i.T2W1.z,i.T2W2.z);
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos)); 
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				
				//计算光照
				fixed3 ndl = max(0, dot(worldNormal, lightDir)*0.5 + 0.5);
				fixed3 ramp = smoothstep(_RampThreshold - _RampSmooth * 0.5, _RampThreshold + _RampSmooth * 0.5, ndl);
				ramp *= LIGHT_ATTENUATION(i);
				_SColor = lerp(_HColor, _SColor, _SColor.a);	//通过阴影颜色的Alpha控制阴影的强度
				ramp = lerp(_SColor.rgb, _HColor.rgb, ramp);
				//计算光照结束
				
				//计算反射高光
				fixed3 halfDir = normalize(lightDir+viewDir);
				fixed3 specular = _LightColor0.rgb *  pow(max(0,dot(worldNormal,halfDir*_Shininess)),20);
				specular = smoothstep(0.5-_SpecSmooth*0.5, 0.5+_SpecSmooth*0.5, specular);
				
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				
				col.rgb *= _LightColor0.rgb * ramp;
				col.rgb +=specular;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
