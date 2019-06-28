
Shader "Babybus/outL/vertex outL3" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}		
		_Color("Main Color", Color) = (1,1,1,1)
	
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline("Outline", Range(0, .2)) = .01
		_Factor("Factor", Range(0,1)) = .5
				
    }
    SubShader {
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

                v2f vert (appdata_base v) {
                    v2f o;
                    o.pos = UnityObjectToClipPos (v.vertex);										
                    o.uv = v.texcoord.xy;
                    return o;
                }

             
                fixed4 frag(v2f i) : COLOR {
                    fixed4 texcol = tex2D(_MainTex, i.uv);
                    texcol *= _Color;					
                    return texcol;
                }
            ENDCG
        }
	    Pass
		{
			
			Cull Front
			ZWrite On			
			
			Offset 50, 50
			
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma shader_feature _OUTL_ON

			
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
				o.pos = UnityObjectToClipPos(v.vertex);

				float3 dir = normalize(v.vertex.xyz);
				float3 dir2 = normalize(v.normal);
				dir = lerp(dir, dir2,_Factor);
				dir = mul((float3x3)UNITY_MATRIX_IT_MV, dir);	
				float2 offset = TransformViewToProjection(dir.xy);
				offset = normalize(offset);
				o.pos.xy += offset * o.pos.z * _Outline;				
				
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