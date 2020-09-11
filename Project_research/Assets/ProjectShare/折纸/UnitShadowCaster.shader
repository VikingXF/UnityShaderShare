Shader "Unlit/UnitShadowCaster"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
			Tags { "LightMode"="ForwardBase" }	
			cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog
			#pragma multi_compile_fwdbase 
            #include "UnityCG.cginc"
			#include "AutoLight.cginc"
			
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;               
				float4 worldPos : TEXCOORD1;				
				SHADOW_COORDS(2)
				//UNITY_FOG_COORDS(3)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                //UNITY_TRANSFER_FOG(o,o.vertex);
				TRANSFER_SHADOW(o);//将顶点转换到灯光空间下
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos)//投射shadowmap，并比较深度，以此计算出atten值
				
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);

                return col*atten;
            }
            ENDCG
        }
		Pass{
        Name "ShadowCaster"
        Tags{ "LightMode" = "ShadowCaster" }
 
        cull off//确保正面和背面都正确的渲染到shadowmap
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_shadowcaster
        #include "UnityCG.cginc"
 
        struct v2f {
            V2F_SHADOW_CASTER;
        };
 
        v2f vert(appdata_base v)
        {
            v2f o;
            TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
            return o;
        }
 
        float4 frag(v2f i) : SV_Target
        {
            SHADOW_CASTER_FRAGMENT(i)
        }
        ENDCG
 
    }
    }
	
}
