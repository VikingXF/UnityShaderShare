Shader "Babybus/Special/PourTheJuice"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Maincol("MainColor", Color) = (1,1,1,1)   
		_Color1 ("Color1", Color) = (1,1,1,1)   
		_Color2 ("Color2", Color) = (1,1,1,1)   
		


		_StartPoint("Start Point", Vector) = (0, 0, 0, 0)	
		_ShadowAmount("Shadow Amount", Range(0, 1)) = 1
		
		
		_offsetScale ("波偏移", float) = 1
		_TimeScale ("波速", float) = 1
		_remap ("振幅", Range(0, 100)) = 6.8  //振幅
		_amplitude ("振幅强度", Range(0, 10)) = 0   //振幅强度
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
		
		//Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		//LOD 100

		//ZWrite Off
		//Blend SrcAlpha OneMinusSrcAlpha
		
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

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                //UNITY_FOG_COORDS(1)
				float3 objPos : TEXCOORD1;
				float3 objStartPos : TEXCOORD2;
			
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
			sampler2D _MatCap;
            float4 _MainTex_ST;
			half _TimeScale,_remap,_amplitude,_offsetScale;
			float4 _StartPoint;
			float _ShadowAmount;
			float4 _Maincol,_Color1,_Color2;
            v2f vert (appdata v)
            {
                v2f o;
				
				//o.objPos = mul(unity_ObjectToWorld, v.vertex);
				o.objPos = v.vertex.xyz;
				o.objStartPos = mul(unity_ObjectToWorld, _StartPoint/500);
				
				//顶点Y轴sin位移
				fixed4 offset = float4(0,0,0,0);				
				offset.y = _amplitude*sin( (v.uv.x)*_remap+_Time.y*_TimeScale+_offsetScale);
				offset.x = _amplitude*sin( (v.uv.y)*_remap+_Time.y*_TimeScale);					
				o.vertex = UnityObjectToClipPos(v.vertex+offset.y+offset.x);
				
                //o.vertex = UnityObjectToClipPos(v.vertex);
				
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

			
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float dist1 = saturate(length(i.objStartPos.xyz-i.objPos.xyz)+ _ShadowAmount);
				dist1 = pow(dist1,10);
				
				float dist2 = saturate(length(float3(0,0,0)-i.objPos.xyz)+ 0.8);
				dist2 = pow(dist2,40);
				
				//dist1 = floor(dist1 * 2) / 2;				
				//dist1 = 1-clamp(dist1,0.85,1);
				//_Color1 = lerp(_Color1,_Maincol,dist2);
				//_Color2 = lerp(_Color2,_Maincol,dist2);
				
				float4 color = lerp(_Color2,_Color1,dist1);

                fixed4 col = tex2D(_MainTex, i.uv)*color;
				//col = lerp(col,color,col.a);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
				
                return col;
            }
            ENDCG
        }
    }
}
