// 透明贴图，通过MaskTex贴图（R通道）擦除第2张贴图 第2张为UV1
//初始贴图可为全透明贴图

Shader "Babybus/Special/Mask2_2Tex_UV1_Transparent" {
	Properties{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_MainTex2("Base (RGB) Trans (A)2", 2D) = "white" {}		
		_MaskTex("MaskTex", 2D) = "white" {}
	}

		SubShader{
			Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
			LOD 100
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
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
						half4 texcoord : TEXCOORD0;

					};

					sampler2D _MainTex,_MainTex2,_MaskTex;
					float4 _MainTex_ST, _MainTex2_ST;
					v2f vert(appdata_t v)
					{
						v2f o;
						o.vertex = UnityObjectToClipPos(v.vertex);
						o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
						o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _MainTex2);

						return o;
					}

					fixed4 frag(v2f i) : SV_Target
					{
						fixed4 col = tex2D(_MainTex, i.texcoord.xy);
						fixed4 col2 = tex2D(_MainTex2, i.texcoord.zw);
						fixed4 Maskcol = tex2D(_MaskTex, i.texcoord.zw);
						fixed lerpA = saturate(col2.a - (1- Maskcol.r));
						col = lerp(col,col2,lerpA);
	
						return col;
					}
				ENDCG
			}
	}

}
