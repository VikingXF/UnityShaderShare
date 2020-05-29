// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-cutout shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/CutFruit/CutFruit_CastShadow" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Color ("Main Color", Color) = (1,1,1,1)
	_Cutoff ("Alpha cutoff", Range(-2,2)) = 0.5
}
SubShader {
	Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 100

	Lighting Off
	Cull Off
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half4 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutoff;
			fixed4 _Color;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				//o.texcoord.zw = v.texcoord1;
				o.texcoord.zw = v.vertex.xy;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord.xy)*_Color;
				col.a = i.texcoord.z+0.5;
				clip(col.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
	// shadow caster Alpha
    Pass {
        Name "Caster"
        Tags { "LightMode" = "ShadowCaster" }

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 2.0
		#pragma multi_compile_shadowcaster
		#pragma multi_compile_instancing // allow instanced shadow pass for most of the shaders
		#include "UnityCG.cginc"

		struct v2f {			
			V2F_SHADOW_CASTER;
			float4  uv : TEXCOORD1;
			UNITY_VERTEX_OUTPUT_STEREO
		};

		uniform float4 _MainTex_ST;

		v2f vert( appdata_base v )
		{
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
			o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
			o.uv.zw = v.vertex.xy;
			return o;
		}

		uniform sampler2D _MainTex;
		uniform fixed _Cutoff;
		uniform fixed4 _Color;

		float4 frag( v2f i ) : SV_Target
		{
			fixed4 col = tex2D( _MainTex, i.uv.xy );			
			col.a = i.uv.z+0.5;
			clip(col.a - _Cutoff);
			SHADOW_CASTER_FRAGMENT(i)
		}
		ENDCG

    }
}

}
