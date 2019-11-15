
/*********************************************************************

实现不规则玻璃瓶，液体上升效果，并可进行分段颜色，并加了matcap效果。

**********************************************************************/
Shader "Babybus/Unlit/VSection"
{
	Properties
	{
		_MainColor1 ("Color1 (RGB)", color) = (1, 1, 1, 1)
		_MainColor2 ("Color2 (RGB)", color) = (1, 1, 1, 1)
		_MainColor3 ("Color3 (RGB)", color) = (1, 1, 1, 1)
		_Cut ("CutHeight", Range(-0.5, 1)) = 0
		_MatCap("Ramp Texture", 2D) = "white" {}
		
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag						
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal :NORMAL;
				float2 cap    : TEXCOORD1;
			};

			struct v2f
			{			
				float3 normal :NORMAL;
				float4 vertex : SV_POSITION;
				float4 color : TEXCOORD0;
				float2 cap    : TEXCOORD1;
			};

			float4 _MainColor1;
			float4 _MainColor2;
			float4 _MainColor3;
			sampler2D _MatCap;
			float _Cut;
			
			v2f vert (appdata v)
			{
			v2f o;							
			float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
			float4 worldCut = mul(unity_ObjectToWorld, float4(0, _Cut, 0, 0.5));
			if(worldPos.y > worldCut.y )
			{
				worldPos.y = worldCut.y;				
				v.vertex = mul(unity_WorldToObject, worldPos);
			}
			else
			{
				
			}
			if(worldPos.y>0 && worldPos.y<0.06)
			o.color = _MainColor1;
			if(worldPos.y>0.06 && worldPos.y<0.13)
			o.color = _MainColor2;
			if(worldPos.y>0.13 && worldPos.y<0.2)
			o.color = _MainColor3;
			
				o.vertex = UnityObjectToClipPos(v.vertex);
					
			half2 capCoord;
            capCoord.x = dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal);
            capCoord.y = dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal);
            o.cap = capCoord * 0.5 + 0.5;
			return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{		
				fixed4 mc = tex2D(_MatCap, i.cap);			
				return (i.color+(mc*1.2)-1.0);
			}
			ENDCG
		}
	}
}
