// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/Unlit/Texture(Mask2Tex)" {
Properties {
	_MaskTex ("Mask", 2D) = "white" {}	
	_Tex1("texture1", 2D) = "white" {}
	_Tex2("texture2", 2D) = "white" {}
	_Fresnel ("Fresnel", Range(0, 100)) = 5.273504
    _FresnelColor ("FresnelColor", Color) = (0.5,0.5,0.5,1)
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
				float3 normal : NORMAL;
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half4 texcoord : TEXCOORD0;
				 float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;

			};

			sampler2D _MaskTex;
			sampler2D _Tex1,_Tex2;
			float4 _MaskTex_ST,_Tex1_ST;
			float _Fresnel;
            float4 _FresnelColor;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.normalDir = UnityObjectToWorldNormal(v.normal);               
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord1, _MaskTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _Tex1);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{	
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);				
				float rim = 1.0 - saturate(dot(normalize(i.normalDir), viewDirection)); 
				float3 rimColor = _FresnelColor.rgb * pow (rim, _Fresnel); 
				
				fixed4 Maskcol = tex2D(_MaskTex, i.texcoord.xy);
				fixed4 Texcol1 = tex2D(_Tex1, i.texcoord.zw);
				fixed4 Texcol2 = tex2D(_Tex2, i.texcoord.zw);

				float4 col = lerp(Texcol1,Texcol2,Maskcol.r);

				UNITY_OPAQUE_ALPHA(col.a);
				col.rgb += rimColor;
				return col;
			}
		ENDCG
	}
}

}
