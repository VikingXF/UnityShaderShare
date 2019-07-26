Shader "Babybus/projector_Caustic"
{
    Properties
    {
        _MainTex ("焦散贴图", 2D) = "white" {}
		_MaskTex("Mask贴图", 2D) = "white" {}
		_CausticIntensity("焦散强度", Range(0.0, 5.0)) = 0.5
		_WaveSpeed("焦散(XY)/Mask(ZW)贴图速度",vector) = (1,1,1,1)
		
		
    }
    SubShader
    {
		Tags {"RenderType" = "Opaque"  "LightMode" = "ForwardBase"}
		LOD 100

        Pass
        {

			Blend DstColor one
			//Blend one OneMinusSrcAlpha
			//Blend one one
			offset -1, -1

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _MaskTex;
            float4 _MainTex_ST, _MaskTex_ST;
			float _CausticIntensity;
			float4 _WaveSpeed;
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;

            v2f vert (appdata v)
            {
                v2f o;
				//calculate uv
				float4 pos = mul(unity_Projector, v.vertex);
				float2 texcoord = float2(pos.x / pos.w, pos.y / pos.w);//ignore z
				o.uv.xy = TRANSFORM_TEX(texcoord, _MainTex)+float2(_Time.x*_WaveSpeed.x,_Time.x*_WaveSpeed.y);
				o.uv.zw = TRANSFORM_TEX(texcoord, _MaskTex)+float2(_Time.x*_WaveSpeed.z,_Time.x*_WaveSpeed.w);
                o.vertex = UnityObjectToClipPos(v.vertex);

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture				
				float4 Maskcol = tex2D(_MaskTex, i.uv.zw);
				float4 col = tex2D(_MainTex, i.uv.xy)*_CausticIntensity;
				col = saturate(col*Maskcol.r);
				
               
				

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
