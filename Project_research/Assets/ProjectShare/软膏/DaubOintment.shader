

Shader "Babybus/Makeup/DaubOintment" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_ParticleTex ("Particle RT", 2D) = "white" {}
	_MaskTex ("Mask RT", 2D) = "white" {}
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

			sampler2D _MainTex,_MaskTex,_ParticleTex;
			float4 _MainTex_ST;

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
				fixed4 Maskcol = tex2D(_MaskTex, i.texcoord);
				fixed4 Particlecol = tex2D(_ParticleTex, i.texcoord);
				col.rgb = lerp(col.rgb,Particlecol.rgb,Particlecol.a);
				col.a = saturate((col.a-Maskcol.r));
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
}

}
