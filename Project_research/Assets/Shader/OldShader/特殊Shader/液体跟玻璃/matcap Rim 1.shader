// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*********************************************************************

实现Rim+matcap效果
顶点演法线挤压描边

**********************************************************************/

Shader "Babybus/Unlit/matcap Rim 1"
{
	Properties
	{	
		_MainTex ("Texture", 2D) = "white" {}
		_MatCap("Ramp Texture", 2D) = "white" {}			
		_RimColor("Rim Color" , Color) = (0,0.5,1,1)
		_RimPower("Rim Power" , Range(0,8)) = 2
		_Rimstrength("Rim strength" , Range(0,8)) = 1
		
	}
	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
	
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		//Blend One One
		//Cull Off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;				
				float2 cap    : TEXCOORD0;
				float2 uv : TEXCOORD1;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;	
				float2 cap    : TEXCOORD1;				
				float4 vertex : SV_POSITION; 

			};

			sampler2D _MainTex,_MatCap;
			float4 _MainTex_ST;
								
			v2f vert (appdata v)
			{
				v2f o;				

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				half2 capCoord;
                float3 worldNorm = normalize(unity_WorldToObject[0].xyz * v.normal.x + unity_WorldToObject[1].xyz * v.normal.y + unity_WorldToObject[2].xyz * v.normal.z);
				worldNorm = mul((float3x3)UNITY_MATRIX_V, worldNorm);
				o.cap.xy = worldNorm.xy * 0.5 + 0.5;
				
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.cap);				
				fixed4 mc = tex2D(_MatCap, i.cap);
				col.rgb = lerp(col.rgb,mc.rgb,1-col.a);
				col.a = saturate(mc.a+col.a);
				return col;				
			}
			ENDCG
		}
		
		Pass
		{
			//Blend One One
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			//Cull Back 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				fixed color : TEXCOORD0;
				float4 pos : SV_POSITION;
				float3 Normal : TEXCOORD2;
				float3 viewDir : TEXCOORD3;
			};

			fixed4 _RimColor;
			half _Rimstrength , _RimPower;
			v2f vert (appdata v)
			{
				v2f o;
				v.vertex.xyz += v.normal*_Rimstrength;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				o.Normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = WorldSpaceViewDir(v.vertex);
				
				float rim = 1.0 - saturate(dot(normalize(o.viewDir), normalize(o.Normal)));  				  
				o.color = pow(rim,_RimPower);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = _RimColor;
				col.a = i.color*_RimColor.a;
				return col;
			}
			ENDCG
		}
	}
}
