Shader "Unlit/GetIceCream"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MainColor ("MainColor", Color) = (1,1,1,1) 
		_MaskTex ("MaskTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
		CGINCLUDE
		#include "UnityCG.cginc"	
		
			struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex,_MaskTex;
            float4 _MainTex_ST,_MaskTex_ST;
            float4 _MainColor;
			
            v2f vert (appdata v)
            {
                v2f o;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;

                return col;
            }
			
			v2f vert1 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.9;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag1 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.95;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			
			v2f vert2 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.8;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag2 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.94;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			
			v2f vert3 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.7;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag3 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.93;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			v2f vert4 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.6;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag4 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.92;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			v2f vert5 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.5;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag5 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.89;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			v2f vert6 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.4;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag6 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.89;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			v2f vert7 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.3;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag7 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.86;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			v2f vert8 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.2;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag8 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.86;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			v2f vert9 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.1;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag9 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.84;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
			v2f vert10 (appdata v)
            {
                v2f o;
				v.vertex.y *=0.001;				
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag10 (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_MainTex, i.uv)*_MainColor*0.84;
				fixed4 Maskcol = tex2D(_MaskTex, i.uv);
				col.a = 1-Maskcol.r;
                return col;
            }
		ENDCG
		

		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert10
            #pragma fragment frag10

            ENDCG
        }
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert9
            #pragma fragment frag9

            ENDCG
        }
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert8
            #pragma fragment frag8

            ENDCG
        }
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert7
            #pragma fragment frag7

            ENDCG
        }
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert6
            #pragma fragment frag6

            ENDCG
        }
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert5
            #pragma fragment frag5

            ENDCG
        }
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert4
            #pragma fragment frag4

            ENDCG
        }
		
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert3
            #pragma fragment frag3

            ENDCG
        }
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert2
            #pragma fragment frag2

            ENDCG
        }
		Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert1
            #pragma fragment frag1

            ENDCG
        }
        Pass
        {
			ZWrite Off
		    Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            ENDCG
        }
    }
}
