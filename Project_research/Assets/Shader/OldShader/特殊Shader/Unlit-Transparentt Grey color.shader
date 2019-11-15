

Shader "Babybus/Unlit/Transparent Grey Color" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Intensity ("Intensity", Range(0,2)) = 1
	_Color ("Main Color", Color) = (1,1,1,1)
	[Toggle] _Grey("Grey", Float) = 0
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma shader_feature __ _GREY_ON
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Intensity;
			fixed4 _Color;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				
				#if	_GREY_ON	
				float gray = dot(col.rgb, float3(0.299, 0.587, 0.114));
				col.rgb = float3(gray, gray, gray)*_Intensity*_Color;
				#endif
				
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
}

}
