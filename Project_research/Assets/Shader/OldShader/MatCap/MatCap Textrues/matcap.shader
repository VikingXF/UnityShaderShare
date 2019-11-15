// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Babybus/Unlit/matcap"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				
				float2 uv : TEXCOORD0;
				float2 cap    : TEXCOORD1;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;

				float2 cap    : TEXCOORD2;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION; 
				
			};

			sampler2D _MainTex,_MatCap;
			float4 _MainTex_ST;
			float2 cap ;

			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				half2 capCoord;
                capCoord.x = dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal);
                capCoord.y = dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal);
                o.cap = capCoord * 0.5 + 0.5;
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 mc = tex2D(_MatCap, i.cap);
				
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				
			
				 return (col + (mc*1.2)-1.0);
				//return col;
			}
			ENDCG
		}
	}
}
