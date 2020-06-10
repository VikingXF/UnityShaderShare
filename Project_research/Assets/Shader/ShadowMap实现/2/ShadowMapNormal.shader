Shader "Shadow/ShadowMapNormal"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;


			struct v2f {
				float4 pos: SV_POSITION;
				float4 worldPos: TEXCOORD0;
				float2 uv : TEXCOORD1;
				float4 ShadowCoord : TEXCOORD3;
				float2 depth : TEXCOORD4;
			};


			float4x4 _ProjectionMatrix,_WorldToViewMatrix;
			sampler2D _DepthTexture;
			float _ShadowBias;

			
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				// 通过投影矩阵变换到light空间(摄像机为原点)
				o.ShadowCoord = mul(_ProjectionMatrix, mul(unity_ObjectToWorld, v.vertex));
				// 这一步不太懂
				o.ShadowCoord.z = -(mul(_WorldToViewMatrix, mul(unity_ObjectToWorld, v.vertex)).z * 1 / 200.0);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//fixed4 col = fixed4(1,1,1,1);
				fixed4 col = tex2D(_MainTex, i.uv);
				float planeDepth = i.ShadowCoord.z;

				fixed4 dcol = tex2Dproj(_DepthTexture, i.ShadowCoord);
				float boxDepth = DecodeFloatRGBA(dcol);

				float  shadow = planeDepth + 0.0025 > boxDepth ? 0.5 : 1.0;

				return col * shadow;
			}
			ENDCG
		}
	}
}
