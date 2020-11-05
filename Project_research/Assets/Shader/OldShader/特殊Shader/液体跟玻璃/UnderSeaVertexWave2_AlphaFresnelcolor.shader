Shader "Babybus/Special/UnderSeaVertexWave2_AlphaFresnelcolor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MainColor ("Main Color", Color) = (0,0.8333333,1,1)
		_Intensity("Intensity of surface", Range(-1, 10)) = 1.3 //液面亮度
		_V("顶点", float) = 1
		 _Fresnel ("Fresnel", Range(0, 100)) = 2.4
        _FresnelColor ("FresnelColor", Color) = (0.5,0.5,0.5,1)
		
		_TimeScale1("波速1", float) = 1
		_remap("振幅1", Range(0, 100)) = 6.8  //振幅		
		_amplitude1("振幅强度1", Range(0, 10)) = 0   //振幅强度
		_TimeScale2("波速2", float) = 1
		_remap2("振幅2", Range(0, 100)) = 6.8  //振幅
		_amplitude2("振幅强度2", Range(0, 10)) = 0   //振幅强度
		
    }
    SubShader
    {
        //Tags { "RenderType"="Opaque" }
		Tags {
            "Queue"="Transparent+10"
            "RenderType"="TransparentCutout"
        }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		
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
                
                float4 vertex : SV_POSITION;
				float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
				//UNITY_FOG_COORDS(1)
            };
			half _V;
			fixed4 _MainColor;
			fixed _Intensity;
            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed _Fresnel;
            fixed4 _FresnelColor;
			
			half _TimeScale1, _remap1, _amplitude1,_amplitude2,_remap2,_TimeScale2;
            v2f vert (appdata v)
            {
                v2f o;
				//顶点Y轴sin位移
				fixed4 offset = float4(0, 0, 0, 0);
				offset.y = _amplitude2 * sin((v.uv.x)*_remap2 + _Time.y*_TimeScale2);
				offset.x = _amplitude1 * sin((v.uv.x)*_remap1 + _Time.y*_TimeScale1);
				if(v.vertex.y > _V)
				{
					v.vertex.y +=offset.x+ offset.y;
				}
				
				
				//o.vertex = UnityObjectToClipPos(v.vertex + offset.x+ offset.y);				
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.normalDir = UnityObjectToWorldNormal(v.normal);
				
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {	
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float rim = 1.0 - saturate(dot(normalize(i.normalDir), viewDirection)); 
				float3 rimColor = _FresnelColor.rgb * pow (rim, _Fresnel); 
				
                // sample the texture
                fixed4 Texcol = tex2D(_MainTex, i.uv);
				fixed4 col = lerp(_MainColor*_Intensity,_MainColor,Texcol.r);
				col.rgb += rimColor;
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
