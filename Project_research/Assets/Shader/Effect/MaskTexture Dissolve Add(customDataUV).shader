
/*
如果特效系统需要开启custom Vertex Streams 需要添加UV2占用下texcoord0.zw通道
_MainTex  UV : Custonm(TEXCOORD1.xy)
_MaskTex  UV:Custonm(TEXCOORD1.zw)
_T_mask   UV:Custonm(TEXCOORD2.xy)
_mask : Custonm(TEXCOORD2.z)

*/

Shader "Babybus/Particles/MaskTexture Dissolve Add(customDataUV)" {
	Properties{
		_TintColor("Color&Alpha", Color) = (1,1,1,1)
		_MainTex("Diffuse Texture", 2D) = "white" {}
		_MaskTex("MaskTex", 2D) = "white" {}
		
		_T_mask("T_mask", 2D) = "white" {}
		_Solfvalue ("Solf value", Float ) = 1		
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4  //声明外部控制开关
	}
		SubShader{
			Tags {
				"IgnoreProjector" = "True"
				"Queue" = "Transparent"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
			}
			Pass {
				//Name "FORWARD"
				//Tags {
				//	"LightMode" = "ForwardBase"
				//}
				Blend SrcAlpha One
				Cull Off Lighting Off ZWrite off
				ZTest[_ZTest] //获取值应用
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				sampler2D _MainTex, _T_mask,_MaskTex;
				float4 _MainTex_ST,_T_mask_ST,_MaskTex_ST;
				float4 _TintColor;
				float _Solfvalue;
				struct VertexInput {
					float4 vertex : POSITION;
					float2 texcoord0 : TEXCOORD0;
					float4 vertexColor : COLOR;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
				};
				struct VertexOutput {
					float4 pos : SV_POSITION;
					float4 uv0 : TEXCOORD0;
					float2 maskuv : TEXCOORD1;
					float4 vertexColor : TEXCOORD2;
					float4 DataUV : TEXCOORD3;
					float4 custom : TEXCOORD4;

				};
				VertexOutput vert(VertexInput v) {
					VertexOutput o = (VertexOutput)0;
					o.uv0.xy = TRANSFORM_TEX(v.texcoord0, _MainTex);
					o.uv0.zw = TRANSFORM_TEX(v.texcoord0, _MaskTex);	
					o.DataUV.xy = v.texcoord1.xy;
					o.DataUV.zw = v.texcoord1.zw;
					
					o.maskuv = TRANSFORM_TEX(v.texcoord0, _T_mask);
					o.custom.xy = v.texcoord2.xy;
					o.custom.zw = v.texcoord2.zw;
				
					o.vertexColor = v.vertexColor;
	
					
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				}
				float4 frag(VertexOutput i) : SV_Target {
					fixed4 MainCol = tex2D(_MainTex, i.uv0.xy+i.DataUV.xy);
					fixed4 _MaskTexCol = tex2D(_MaskTex, i.uv0.zw +i.DataUV.zw);					
					fixed4 _T_mask_Col = tex2D(_T_mask, i.maskuv+ i.custom.xy);
										
					MainCol.rgb *= 2.0f *_TintColor.rgb*i.vertexColor.rgb;
					_T_mask_Col = saturate(_T_mask_Col*_Solfvalue-lerp(_Solfvalue,(-1.5),i.custom.z));
					
					MainCol.a = saturate(MainCol.a*_TintColor.a*_T_mask_Col.r*_MaskTexCol.r*i.vertexColor.a);

					return MainCol;
				  }
				  ENDCG
			  }
		}
			FallBack "Babybus/Particles/Alpha Blended"
}
