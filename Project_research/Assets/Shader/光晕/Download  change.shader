// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*********************************************************************
xf 2018.5.3
实现下载灰到彩色从上到下变化
彩色Rim效果
**********************************************************************/

Shader "Babybus/Download  change"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		
		_RimColor("RimColor",Color) = (0,0,0,1)
		_RimPower("RimPower",Range(0,5)) = 0.5
		_Degree("degree",float)=-1
		_Pow("pow",float)=30		
		_Brightness("brightness",float) =1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		
		//彩色带Rim效果
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			
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
				float rim : TEXCOORD1;
				float3 model : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			float3 _RimColor;
			fixed  _RimPower;
			float _Degree;
			float _Pow;
			float _Brightness;
			v2f vert (appdata v)
			{
				v2f o;
				o.model = v.vertex;
				//菲利尔
				float3 Normal = UnityObjectToWorldNormal(v.normal);
				float3 viewDir = WorldSpaceViewDir(v.vertex);
				o.rim = 1.0 - saturate(dot(normalize(viewDir), normalize(Normal)));		
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				
				float c = 0.299*col.r + 0.587*col.g + 0.184*col.b;
				fixed4 Firstcol =col;
				Firstcol.rgb = fixed3(c,c,c)*_Brightness;
							
				fixed4 Secondcol =col;
				Secondcol.rgb = col.rgb +_RimColor * pow (i.rim, _RimPower); 				
				
				if(i.model.y < (1-_Degree))				
					return col = Firstcol+pow(saturate(i.model.y+_Degree),_Pow); 
				else
					return col =Secondcol;						
				
			}
			ENDCG
		}
	}
}
