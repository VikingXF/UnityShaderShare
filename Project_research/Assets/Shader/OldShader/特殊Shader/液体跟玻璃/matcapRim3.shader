// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*********************************************************************

实现Rim+matcap效果
无透明
**********************************************************************/

Shader "Babybus/matcap/matcapRim3"
{
	Properties
	{	
		_MainTex ("Texture", 2D) = "white" {}
		_MatCap("Ramp Texture", 2D) = "white" {}
		_MatCapAlpha("Ramp Texture Alpha" , Range(0,1)) = 1		
		_RimColor("Rim Color" , Color) = (0,0.5,1,1)
		_RimPower("Rim Power" , Range(0,8)) = 2
		_RimIntensity("Rim Intensity", Range(0.0, 10)) = 3  	
		
	}
	SubShader
	{
		//Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		Tags { "RenderType"="Opaque" }
		LOD 100
	
		//ZWrite Off
		//Blend SrcAlpha OneMinusSrcAlpha
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
				float4 NdotV : TEXCOORD2;
			};

			sampler2D _MainTex,_MatCap;
			float4 _MainTex_ST;
			half _MatCapAlpha;	

			fixed4 _RimColor;
			half _RimPower,_RimIntensity;
			
			v2f vert (appdata v)
			{
				v2f o;				

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				half2 capCoord;
                float3 worldNorm = normalize(unity_WorldToObject[0].xyz * v.normal.x + unity_WorldToObject[1].xyz * v.normal.y + unity_WorldToObject[2].xyz * v.normal.z);
				worldNorm = mul((float3x3)UNITY_MATRIX_V, worldNorm);
				o.cap.xy = worldNorm.xy * 0.5 + 0.5;
				
				float3 normalDirection = normalize(WorldSpaceViewDir(v.vertex));
				float3 normalDir =  normalize( mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.NdotV.x = saturate(dot(normalDir,normalDirection));
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);				
				fixed4 mc = tex2D(_MatCap, i.cap);
				float rim = pow((1-i.NdotV.x) ,_RimPower)*_RimIntensity*_RimColor.a;	
				
				col.rgb = lerp(col.rgb,mc.rgb,_MatCapAlpha)+ rim * _RimColor.rgb;
				//col.a = saturate(mc.a*_MatCapAlpha+col.a)+rim;
				
				return col;				
			}
			ENDCG
		}		
		
	}
}
