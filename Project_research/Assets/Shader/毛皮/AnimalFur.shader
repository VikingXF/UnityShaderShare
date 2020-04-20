Shader "Babybus/Special/AnimalFur"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_FurTex("FurTex", 2D) = "white" {}
		_FurLength("FurLength",float) = 0.1
		_Cutoff("Alpha Cutoff", Range(0,1)) = 0.5 
		_CutoffEnd("Alpha Cutoff end", Range(0,1)) = 0.5 


		_Gravity("Gravity",vector) = (0,-1,0,1)
		_GravityStrength("GravityStrength",float) = 0.1
		
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
				float3 normal : NORMAL;
				fixed4 color : COLOR;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD2;
            };

            sampler2D _MainTex,_FurTex;
            float4 _MainTex_ST,_FurTex_ST;
			
			float _FurLength;
			float3 _Gravity;
			float _GravityStrength;
			float4 _Color;
			half _Cutoff;
			half _CutoffEnd;
		
			v2f vert_fur (appdata v , half FUR_OFFSET)
            {
                v2f o;
				//v.vertex.xyz += v.normal * _FurLength * FUR_OFFSET;
				
				half3 direction = _Gravity * _GravityStrength + v.normal * (1 - _GravityStrength);				
				direction = lerp(v.normal, direction, FUR_OFFSET);
				v.vertex.xyz += direction * _FurLength * FUR_OFFSET * v.color.a;
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _FurTex);

				UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }
			fixed4 frag_fur(v2f i,half FUR_OFFSET)
			{

				fixed4 col = tex2D(_MainTex, i.uv.xy)*_Color;
				fixed4 furCol = tex2D(_FurTex,i.uv.zw);
				fixed alpha = furCol.r;

				alpha = step(lerp(_Cutoff, _CutoffEnd, FUR_OFFSET), alpha);
				
				col.a = 1 - FUR_OFFSET * FUR_OFFSET;
				col.a *= alpha;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			//=============================================================================
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}
			v2f vert1(appdata v)
			{				
				return vert_fur(v,0.05);
			}
			v2f vert2(appdata v)
			{
				return vert_fur(v, 0.1);
			}
			v2f vert3(appdata v)
			{
				return vert_fur(v, 0.15);
			}
			v2f vert4(appdata v)
			{
				return vert_fur(v, 0.2);
			}
			v2f vert5(appdata v)
			{
				return vert_fur(v, 0.25);
			}
			v2f vert6(appdata v)
			{
				return vert_fur(v, 0.3);
			}
			v2f vert7(appdata v)
			{
				return vert_fur(v, 0.35);
			}
			v2f vert8(appdata v)
			{
				return vert_fur(v, 0.4);
			}
			v2f vert9(appdata v)
			{
				return vert_fur(v, 0.45);
			}


			fixed4 frag (v2f i) : SV_Target
            {
              
                fixed4 col = tex2D(_MainTex, i.uv.xy);				               
                UNITY_APPLY_FOG(i.fogCoord, col);				
                return col;
            }
			
			fixed4 frag1(v2f i) : SV_Target
			{			
				return frag_fur(i,0.05);
			}
			fixed4 frag2(v2f i) : SV_Target
			{
				return frag_fur(i,0.1);
			}
			fixed4 frag3(v2f i) : SV_Target
			{
				return frag_fur(i,0.15);
			}
			fixed4 frag4(v2f i) : SV_Target
			{
				return frag_fur(i,0.2);
			}
			fixed4 frag5(v2f i) : SV_Target
			{
				return frag_fur(i,0.25);
			}
			fixed4 frag6(v2f i) : SV_Target
			{
				return frag_fur(i,0.3);
			}
			fixed4 frag7(v2f i) : SV_Target
			{
				return frag_fur(i,0.35);
			}
			fixed4 frag8(v2f i) : SV_Target
			{
				return frag_fur(i,0.4);
			}
			fixed4 frag9(v2f i) : SV_Target
			{
				return frag_fur(i,0.45);
			}
		ENDCG

		//Pass0
        Pass
        {
            CGPROGRAM			
			#pragma vertex vert
			#pragma fragment frag
            ENDCG
        }
		
		//Pass0000
        //Pass
        //{
		//	ZWrite Off
		//	Blend SrcAlpha OneMinusSrcAlpha
        //    CGPROGRAM	
		//	//#define FUR_OFFSET 0.05		
		//	#pragma vertex vert_fur
		//	#pragma fragment frag_fur
        //   ENDCG
        //}

		//Pass1
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM					
			#pragma vertex vert1
			#pragma fragment frag1
            ENDCG
        }
			//Pass1
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM					
			#pragma vertex vert1
			#pragma fragment frag1
            ENDCG
        }
			//Pass2
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM					
			#pragma vertex vert2
			#pragma fragment frag2
            ENDCG
        }
			//Pass3
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM					
			#pragma vertex vert3
			#pragma fragment frag3
            ENDCG
        }
			//Pass4
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM					
			#pragma vertex vert4
			#pragma fragment frag4
            ENDCG
        }
			//Pass5
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM					
			#pragma vertex vert5
			#pragma fragment frag5
            ENDCG
        }
			//Pass6
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM					
			#pragma vertex vert6
			#pragma fragment frag6
            ENDCG
        }
			//Pass7
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM					
			#pragma vertex vert7
			#pragma fragment frag7
            ENDCG
        }
			//Pass8
			Pass
		{
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert8
			#pragma fragment frag8
			ENDCG
		}
			//Pass9
			Pass
		{
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert9
			#pragma fragment frag9
			ENDCG
		}
    }
}
