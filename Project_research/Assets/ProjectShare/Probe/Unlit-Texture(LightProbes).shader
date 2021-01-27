

Shader "Babybus/Unlit/Texture(LightProbes)" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_SHLightingScale("LightProbe influence scale",float) = 1
}

SubShader {
	Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
	//Tags { "Queue"="Geometry""LightMode"="ForwardBase""RenderType"="Opaque"   }
	LOD 100
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal :NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed3  SHLighting : COLOR;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _SHLightingScale;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = mul((float3x3)unity_ObjectToWorld, v.normal);//获得世界坐标中的normal     
				o.SHLighting= ShadeSH9(float4(worldNormal,1)) ;
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				col.rgb *=i.SHLighting;
				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_OPAQUE_ALPHA(col.a);
				return col*_SHLightingScale;
			}
		ENDCG
	}
}

}
