
/*
_MainTex : Diffuse Texture主纹理
_ScaleOnCenter ：_MainTex旋转中心&非中心
_AngleSpeed : _MainTex旋转速度
_MainUV :XY为控制_MainTex的UV位移速度
_MaskTex:遮罩贴图
_T_mask:溶解贴图（R）
_MaskUV :XY为控制_MaskTex的UV位移速度
_MaskUV :ZW为控制T_mask的UV位移速度
_Solfvalue ：控制溶解边缘软硬程度
_mask  : _Dissolve ：1-0溶解

_MainTex  UV : _MainUV.xy
_MaskTex  UV : _MaskUV.xy
_T_mask   UV : _MaskUV.zw


*/

Shader "Babybus/Particles/MaskTexture Dissolve Blend" {
	Properties{
		_TintColor("Color&Alpha", Color) = (1,1,1,1)
		[Header(Diffuse Texture)]_MainTex("Diffuse Texture", 2D) = "white" {}
		[Toggle] _ScaleOnCenter("Scale On Center", Float) = 1
		_AngleSpeed("Angle Speed" , Range(0, 10)) = 0
		_MainUV("X&Y(Diffuse Texture UV),Z&W(null)",vector) = (1,1,1,1)	
		
		[Header(MaskTex)]_MaskTex("MaskTex", 2D) = "white" {}	
		[Header(T_mask)]_T_mask("T_mask", 2D) = "white" {}		
		[Header(XY MaskTex UV    ZW T_mask UV)]_MaskUV("X&Y(MaskTex UV),Z&W(T_mask UV)",vector) = (1,1,1,1)
		
		_Dissolve("Dissolve", Range(0, 1)) = 1
		
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
				Blend SrcAlpha OneMinusSrcAlpha
				Cull Off Lighting Off ZWrite off
				ZTest[_ZTest] //获取值应用
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				#pragma shader_feature __ _SCALEONCENTER_ON
				
				sampler2D _MainTex, _T_mask,_MaskTex;
				float4 _MainTex_ST,_T_mask_ST,_MaskTex_ST;
				float4 _TintColor;
				float _Solfvalue;
				float4 _MainUV,_MaskUV;
				float _Dissolve;
				 half        _AngleSpeed;
				struct VertexInput {
					float4 vertex : POSITION;
					float2 texcoord0 : TEXCOORD0;
					float4 vertexColor : COLOR;
				};
				struct VertexOutput {
					float4 pos : SV_POSITION;
					float4 uv0 : TEXCOORD0;
					float4 maskuv : TEXCOORD1;
					float4 vertexColor : TEXCOORD2;


				};
				
				float2 rotateUV(float2 srcUV,half angle )
				{
					//角度转弧度
					angle/=57.3;
					float2x2 rotateMat;
					rotateMat[0] = float2(cos(angle) , -sin(angle));
					rotateMat[1] = float2(sin(angle) , cos(angle));

					return mul(rotateMat , srcUV);
				}
				float2 TransfromUV(float2 srcUV,half4 argST ,half angle )
				{
					#if _SCALEONCENTER_ON
						srcUV -= 0.5;
					#endif
					srcUV = rotateUV(srcUV, angle);
					srcUV = srcUV * argST.xy + argST.zw+float2(1,0);
					#if _SCALEONCENTER_ON
						srcUV += 0.5;
					#endif
					return srcUV;
				}
			
				VertexOutput vert(VertexInput v) {
					VertexOutput o = (VertexOutput)0;
					o.uv0.xy = TRANSFORM_TEX(v.texcoord0, _MainTex);
					o.uv0.zw = TRANSFORM_TEX(v.texcoord0, _MaskTex);
					o.maskuv.xy = TRANSFORM_TEX(v.texcoord0, _T_mask);				
					o.maskuv.zw = TransfromUV(v.texcoord0, _MainTex_ST ,(_Time.y*100*_AngleSpeed)%360);
					o.vertexColor = v.vertexColor;
	
					
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				}
				float4 frag(VertexOutput i) : SV_Target {

					fixed4 MainCol = tex2D(_MainTex, i.maskuv.zw + _MainUV.xy*_Time.y);
					fixed4 _MaskTexCol = tex2D(_MaskTex, i.uv0.zw +_MaskUV.xy*_Time.y);					
					fixed4 _T_mask_Col = tex2D(_T_mask, i.maskuv.xy+ _MaskUV.zw*_Time.y);
										
					MainCol.rgb *=2.0* _TintColor.rgb*i.vertexColor.rgb;					
					_T_mask_Col = saturate(_T_mask_Col*_Solfvalue-lerp(_Solfvalue,(-1.5),_Dissolve));
					MainCol.a = saturate(MainCol.a*_TintColor.a*_T_mask_Col.r*_MaskTexCol.r*i.vertexColor.a);

					return MainCol;

				  }
				  ENDCG
			  }
		}
			FallBack "Babybus/Particles/Alpha Blended"
}
