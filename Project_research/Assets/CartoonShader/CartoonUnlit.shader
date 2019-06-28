
Shader "Babybus/Cartoon/CartoonUnlit"
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
			#include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				fixed3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 CarToonColor: TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;
			fixed4 _HColor;
			fixed4 _SColor;
			float _RampThreshold;
			float _RampSmooth;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				//计算光照
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 lightDir = mul((float3x3)unity_ObjectToWorld, ObjSpaceLightDir(v.vertex));
				fixed ndl = max(0, dot(worldNormal, lightDir)*0.5 + 0.5);
				fixed3 ramp = smoothstep(_RampThreshold - _RampSmooth * 0.5, _RampThreshold + _RampSmooth * 0.5, ndl);
				ramp *= LIGHT_ATTENUATION(i);
				_SColor = lerp(_HColor, _SColor, _SColor.a);	//通过阴影颜色的Alpha控制阴影的强度
				ramp = lerp(_SColor.rgb, _HColor.rgb, ramp);
				o.CarToonColor.rgb = _LightColor0.rgb * ramp;
				
				//计算光照结束

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv)*_Color;

				col *= i.CarToonColor;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
