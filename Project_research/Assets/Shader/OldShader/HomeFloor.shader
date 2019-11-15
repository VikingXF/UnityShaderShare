// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Home/Floor" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_HidenTex ("HidenTex (RGB)", 2D) = "white" {}
		_LerpValue ("Lerp Value", float) = 0
		_ExtenValue ("Exten", float) = 0
		[HideInInspector] _Center ("Center Point", vector) = (0, 0, 0, 0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
			LOD 200

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		
		sampler2D _MainTex;
		sampler2D _HidenTex;
		fixed4 _Color;

		half _LerpValue;
		half _ExtenValue;

		float4 _Center;

		struct Input {
			float2 uv_MainTex;
			float worldDis;
		};

		void vert(inout appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input, o);
			float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
			worldPos.xyzw /= worldPos.w;
			o.worldDis = length(worldPos.xyz - _Center.xyz);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 hide = tex2D(_HidenTex, IN.uv_MainTex);
			float lerpValue = saturate((IN.worldDis - _ExtenValue);
			c.rgb = c.rgb * lerpValue + hide.rgb * (1 - lerpValue);
			o.Albedo = c.rgb * _Color;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback "Legacy Shaders/VertexLit"
	CustomEditor "HomeFloorShaderGUI"
}
