Shader "Babybus/InternationalRestaurant/RestaurantSoup"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MainTex2 ("Texture2", 2D) = "white" {}
		_Factor ("Factor", Range (0.0, 1.0)) = 0
		
		_LightDir("光照方向", vector) = (3, -7, 0, 0)
		_HColor("Highlight Color", Color) = (0.6,0.6,0.6,1.0)
		_HColor2("Highlight Color2", Color) = (0.6,0.6,0.6,1.0)
		
		_MaskTex ("MaskTex", 2D) = "white" {}
		[Normal]_NormalTex("法线贴图", 2D) = "bump" {}
		_NormalScale ("NormalScale", float) = 0.3
		_Speed("Speed", float) = 0.3	
    }
    SubShader
    {
       Tags { "Queue"="Transparent+1" "IgnoreProjector"="True" "RenderType"="Transparent" }
        LOD 100

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
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                //UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 worldNormal :TEXCOORD2 ;
				float4 uv2 : TEXCOORD3;
            };

            sampler2D _MainTex,_MainTex2;
            float4 _MainTex_ST;
			half4 _LightDir;
			fixed _Factor;
			fixed4 _HColor,_HColor2;
			
			sampler2D _NormalTex;
			float4 _NormalTex_ST;
			sampler2D _MaskTex;
			float4 _MaskTex_ST;
			
			fixed _Speed;
			fixed _NormalScale;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				o.uv2.xy = TRANSFORM_TEX(v.uv, _NormalTex);
				o.uv2.zw = TRANSFORM_TEX(v.uv, _MaskTex);
				
                //UNITY_TRANSFER_FOG(o,o.vertex);
		
				o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal)); 
				
				
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				// sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_MainTex2, i.uv);
				col = lerp(col,col2,_Factor);
				//采样法线贴图
				fixed4 normalCol = (tex2D(_NormalTex, i.uv2.zw + fixed2(_Time.x*_Speed, 0)) + tex2D(_NormalTex, fixed2(_Time.x*_Speed + i.uv2.w, i.uv2.z))) / 2;			
				half3 worldNormal = UnpackNormal(normalCol);
				worldNormal = lerp(half3(0, 0, 1), worldNormal, _NormalScale);
				fixed4 lerpColor = lerp(_HColor,_HColor2,_Factor);
				fixed4 Maskcol = tex2D(_MaskTex, i.uv2.zw+worldNormal)*lerpColor;
				
				//计算光照
				fixed3 lightDir = normalize(_LightDir); 	
				fixed3 ndl = max(0, dot(i.worldNormal, lightDir)*0.5 + 0.5)*lerpColor;
				col.rgb +=ndl+Maskcol;
				//计算光照结束
				
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
