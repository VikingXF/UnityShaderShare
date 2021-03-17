
// RGB贴图对应单独颜色的明暗

Shader "Babybus/Unlit/Color RGBTex" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_Color ("Main Color", Color) = (1,1,1,1)
	_LightPower("Light Power", Range(0, 5)) = 1  
	_ShadowPower("Shadow Power", Range(0, 1)) = 1  
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed _LightPower,_ShadowPower;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 colRGB = tex2D(_MainTex, i.texcoord);
				fixed4 col = _Color;
				col.rgb = saturate(_Color.rgb*colRGB.r + _Color.rgb*_LightPower*colRGB.g + _Color.rgb*_ShadowPower*colRGB.b);
				
				UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
		ENDCG
	}
}

}
