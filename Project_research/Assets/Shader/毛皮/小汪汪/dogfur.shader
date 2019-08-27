// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unlit/dogfur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplacementMap ("DisplacementMap", 2D) = "white" {}
		_Displacement ("Displacement", float) = 0.3 
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members norm)
#pragma exclude_renderers d3d11 xbox360
			#pragma target 3.0  
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal :NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 norm ：TEXCOORD2;
			};

			sampler2D _MainTex,_DisplacementMap;
			float4 _MainTex_ST,_DisplacementMap_ST;
			float _Displacement;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);				
				o.uv = TRANSFORM_TEX(v.uv, _DisplacementMap);
				float3 norm = UnityObjectToWorldNormal(v.normal);				
				norm.x *= UNITY_MATRIX_P[0][0];
				norm.y *= UNITY_MATRIX_P[1][1];					
				//float Displacecol = tex2Dlod(_DisplacementMap, o.uv).r * _Displacement;
				v.vertex.xyz += norm * _Displacement;				
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
