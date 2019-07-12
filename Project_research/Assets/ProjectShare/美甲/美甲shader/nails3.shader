// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Babybus/BeautyShop/nails3" {
	Properties{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_DesignTex("DesignTex", 2D) = "white" {}
		_edgeAlpha ("edgeAlpha", Range(0, 1)) = 0.5
	}

		SubShader{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 100

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass{
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
		half4 texcoord : TEXCOORD0;
	};

	sampler2D _MainTex,_DesignTex;
	float4 _MainTex_ST;
	fixed _edgeAlpha;
	v2f vert(appdata_t v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.texcoord.zw = v.texcoord;
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		fixed4 Maincol = tex2D(_MainTex, i.texcoord.xy);
		fixed4 Designcol = tex2D(_DesignTex, i.texcoord.zw);		
		Designcol.a  += Designcol.a-(1-Maincol.a)-_edgeAlpha;
		return Designcol;
	}
		ENDCG
	}
	}

}
