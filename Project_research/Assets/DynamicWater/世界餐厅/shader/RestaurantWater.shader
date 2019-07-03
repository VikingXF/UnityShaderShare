Shader "Babybus/InternationalRestaurant/RestaurantWater"
{
    Properties
    {
        _WaterColor("WaterColor", Color) = (0.6,0.6,0.6,1.0)
		_Color("Color", Color) = (0.6,0.6,0.6,1.0)
		_Ramp("Ramp", Range(0,1)) = 0.5
		_LightDir("光照方向", vector) = (3, -7, 0, 0)
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

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

            struct v2f
            {

                //UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 object : TEXCOORD0;
				float3 worldNormal : TEXCOORD2;
            };

            fixed4 _WaterColor,_Color;
            fixed _Ramp;
			half4 _LightDir;
			
            v2f vert (appdata v)
            {
                v2f o;
				o.object = v.vertex;
                o.vertex = UnityObjectToClipPos(v.vertex);  
				o.worldNormal = UnityObjectToWorldNormal(v.normal);  
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				//计算光照
				fixed3 lightDir = normalize(_LightDir); 
				fixed3 ndl = max(0, dot(i.worldNormal, lightDir)*0.5 + 0.5);	
				
                fixed4 col = lerp(_Color,_WaterColor,saturate(pow(i.object.g,20)+_Ramp));
				col .rgb +=ndl;
				col .a += ndl.x;
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
