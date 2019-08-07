Shader "Babybus/InternationalRestaurant/KantoCookSoup2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MColor("MainTex颜色", Color) = (1,1,1,1)

		[Normal]_NormalTex("法线贴图", 2D) = "bump" {}
		_NormalScale ("NormalScale", float) = 0.3
		_Speed("Speed", float) = 0.3	
		
		_offsetScale ("波偏移", float) = 1
		_TimeScale ("波速", float) = 1
		_remap ("振幅", Range(0, 100)) = 6.8  //振幅
		_amplitude ("振幅强度", Range(0, 10)) = 0   //振幅强度
		
    }
    SubShader
    {
        //Tags { "Queue"="Transparent+1" "IgnoreProjector"="True" "RenderType"="Transparent" }
		//Blend SrcAlpha OneMinusSrcAlpha
		//ZWrite On		
		Tags { "RenderType"="Opaque" }
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
				float2 uv2 : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			fixed4 _MColor;
			
			sampler2D _NormalTex;
			float4 _NormalTex_ST;
		
			fixed _Speed;
			fixed _NormalScale;
			half _TimeScale,_remap,_amplitude,_offsetScale;
			
            v2f vert (appdata v)
            {
                v2f o;
				//顶点Y轴sin位移
				fixed4 offset = float4(0,0,0,0);				
				offset.y = _amplitude*sin( (v.uv.x)*_remap+_Time.y*_TimeScale+_offsetScale);				
				o.vertex = UnityObjectToClipPos(v.vertex+offset);
             
				
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				o.uv2 = TRANSFORM_TEX(v.uv, _NormalTex);

				
                //UNITY_TRANSFER_FOG(o,o.vertex);
		
				o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal)); 
				
				
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				

				//采样法线贴图
				fixed4 normalCol = (tex2D(_NormalTex, i.uv2 + fixed2(_Time.x*_Speed, 0)) + tex2D(_NormalTex, fixed2(_Time.x*_Speed + i.uv2.y, i.uv2.x))) / 2;			
				half3 worldNormal = UnpackNormal(normalCol);
				worldNormal = lerp(half3(0, 0, 1), worldNormal, _NormalScale);

				// sample the texture
                fixed4 col = tex2D(_MainTex, i.uv + worldNormal.xy)*_MColor;
				
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
