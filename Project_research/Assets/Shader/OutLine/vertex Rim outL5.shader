
Shader "Babybus/Rim/vertex Rim outL5" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}		
		_Color("Main Color", Color) = (1,1,1,1)

		_RimColor("RimColor", Color) = (1,1,1,1)  
		_RimPower("RimPower", Range(0, 10.0)) = 0.1  
		_RimIntensity("RimIntensity", Range(0, 3.0)) = 0.1 
		
		_OutlineColor ("Outline Color", Color) = (0,0,0,0)
		_Outline("Outline", Range(0, .2)) = .01
		_Factor("Factor", Range(0,1)) = .5
		//Z Offset
		_Offset1 ("Z Offset 1", Float) = 0
		_Offset2 ("Z Offset 2", Float) = 0		
    }
    SubShader {
		Tags{"RenderType" = "Transparent" "Queue" = "Transparent" }
		LOD 200
	    Pass {
			Cull Back
			//Offset 10, 10
			ZWrite On
       		Lighting Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

				
                struct appdata {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 texcoord : TEXCOORD0;
                };

                struct v2f {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
					float3 Emissive : TEXCOORD1;
                   
                };
				
				sampler2D _MainTex;
                float4 _MainTex_ST;
				fixed4 _Color;
				fixed4 _RimColor;  
				float _RimPower,_RimIntensity; 

                v2f vert (appdata_base v) {
                    v2f o;
                    o.pos = UnityObjectToClipPos (v.vertex);
					
			
                    float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
					float3  viewnormal = normalize(v.normal);
					float Rim=1 -dot(viewDir,viewnormal);
					
					o.Emissive = _RimColor.rgb * pow(Rim,_RimPower) *_RimIntensity;  
		
					
                    o.uv = v.texcoord.xy;
                    return o;
                }

             
                fixed4 frag(v2f i) : COLOR {
                    fixed4 texcol = tex2D(_MainTex, i.uv);
                    fixed4 col = _Color;
					//col.rgb = lerp(*_Color,_Color.rgb,1-texcol.a);
					col.rgb =lerp(saturate(col.rgb+i.Emissive),texcol.rgb,texcol.a);
					//col.a = saturate(texcol.a+i.Emissive.r);
					col.a = saturate(col.a+i.Emissive+texcol.a);
                    return col;
                }
            ENDCG
        }
	    Pass
		{
			
			Cull Front
			ZWrite On			

			Offset [_Offset1],[_Offset2]
			
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			
			float _Outline;			
			fixed4 _OutlineColor;
			fixed _Factor;
			
			
			struct appdata {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
            };			
			struct v2f
			{
				float4 pos:SV_POSITION;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				
				
				
				
				//o.pos = UnityObjectToClipPos(v.vertex);
				
				float3 dir = normalize(v.vertex.xyz);
				float3 dir2 = normalize(v.normal);
				dir = lerp(dir, dir2,_Factor);
				float4 pos = mul( UNITY_MATRIX_MV, v.vertex + float4(dir,0) * _Outline );
				o.pos = mul(UNITY_MATRIX_P, pos);

				
				return o;
			}

			fixed4 frag(v2f i):COLOR
			{
				return _OutlineColor;
			}
			ENDCG
		}
        
		
    }
	Fallback "Unlit/Texture"
}