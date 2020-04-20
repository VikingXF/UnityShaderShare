Shader "Babybus/Special/AnimalFur2"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
		_FurTex("FurTex", 2D) = "white" {}
		_Color("Color",COLOR) = (0, 0, 0, 0)
		_FurLength("FurLength",float) = 0.1		
		_WindSpeed("WindSpeed",float) = 0.1		
		_Wind("Wind",float) = 0.1
		_FurAOInstensity("FurAOInstensity",float) = 0.1
		_Thinkness("Thinkness",float) = 0.1
		_FurDensity("FurDensity",float) = 0.1
		_Gravity("Gravity",vector) = (1,1,1,1)
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
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD2;
            };

            sampler2D _MainTex,_FurTex;
            float4 _MainTex_ST;
			float4 _Color;			
			float _FurLength,_WindSpeed,_Wind,_FurAOInstensity;
			float4 _Gravity;
			float _Thinkness,_FurDensity;

			
			
			
			v2f vert_fur (appdata v,half STEP)
            {
                v2f o;
                float3 newPos = v.vertex.xyz + v.normal *_FurLength *  STEP;
                float3 gravity = mul(unity_ObjectToWorld,_Gravity + sin(_WindSpeed * _Time.y) * _Wind);
                float k = pow(STEP,3);
                newPos = newPos + gravity *k;
                o.vertex = UnityObjectToClipPos(float4(newPos,1.0f));
                //加入毛发阴影，越是中心位置，阴影越明显，边缘位置阴影越浅
                float znormal = 1 - dot(v.normal,float3(0,0,1));
                o.uv.xy = v.uv ;
                o.uv.zw = float2(znormal,znormal)*0.001;
                o.normal = mul(v.normal,(float3x3)unity_WorldToObject);

                return o;
            }

			fixed4 frag_fur(v2f i, half STEP)
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv.xy)*_Color;

				//增加毛发阴影，毛发越靠近根部的像素点颜色越暗
				col.rgb -= (pow(1 - STEP, 3))*_FurAOInstensity;

				fixed3 lightDir = normalize(_WorldSpaceLightPos0);
				//_Thinkness 毛发细度，改变tile增强毛发细度
				float4 furCol = tex2D(_FurTex, i.uv.xy* _Thinkness);
				fixed4 ColOffset = tex2D(_FurTex, i.uv.xy*_Thinkness + i.uv.zw);
				float3 final = dot(float3(0.299, 0.587, 0.114), col.rgb - ColOffset.rgb);
				col.rgb -= final * _FurAOInstensity;

				//fixed3 diffuse = _LightColor0.rgb*col.rgb * max(0,dot(normalize(i.normal),lightDir));
				fixed3 diffuse = col.rgb * max(0, dot(normalize(i.normal), lightDir));
				fixed alpha = clamp(col.a*_FurDensity*(2 - STEP * 4), 0, 1);
				return float4(col.rgb + diffuse, alpha);
			}

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
				return vert_fur(v, 0.05);
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
			
			fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }

			fixed4 frag1(v2f i) : SV_Target
			{
				return frag_fur(i, 0.05);
			}
			fixed4 frag2(v2f i) : SV_Target
			{
				return frag_fur(i, 0.1);
			}
			fixed4 frag3(v2f i) : SV_Target
			{
				return frag_fur(i, 0.15);
			}
			fixed4 frag4(v2f i) : SV_Target
			{
				return frag_fur(i, 0.2);
			}
			fixed4 frag5(v2f i) : SV_Target
			{
				return frag_fur(i, 0.25);
			}
			fixed4 frag6(v2f i) : SV_Target
			{
				return frag_fur(i, 0.3);
			}
			fixed4 frag7(v2f i) : SV_Target
			{
				return frag_fur(i, 0.34);
			}
			fixed4 frag8(v2f i) : SV_Target
			{
				return frag_fur(i, 0.4);
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
		
		
    }
}
