Shader "Babybus/DepthAlpha" {
	Properties {
		_MainColor ("Color" , Color) = (1,1,1,1)
		_MainTex("Main Tex" , 2D) = "white"{}
		_EdgePow("Threshold" , Range(0.01 , 50)) = 0.5
	}

	SubShader {

	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "DisableBatching"="True"}
	
	Pass{
		Tags { "LightMode"="ForwardBase" }	
		
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite On
		Cull Off
		
		CGPROGRAM

		#include "UnityCG.cginc"

		#pragma vertex vert
		#pragma fragment frag

		#define UNITY_PASS_FORWARDBASE
        #pragma multi_compile_fwdbase

		float4 _MainColor;
		sampler2D _MainTex;
		float4 _MainTex_ST;
		sampler2D _CameraDepthTexture;
		float _EdgePow;
		
		struct a2v{
			float4 vertex:POSITION;
			float3 normal:NORMAL;
			float2 tex:TEXCOORD0;
		};

		struct v2f{
			float4 pos:POSITION;
			float4 scrPos:TEXCOORD0;
			half3 worldNormal:TEXCOORD1;
			half3 worldViewDir:TEXCOORD2;
			float2 uv:TEXCOORD3;
		};

		v2f vert (a2v v )
		{
			v2f o;

			o.pos = UnityObjectToClipPos ( v.vertex );

			o.scrPos = ComputeScreenPos ( o.pos );

			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; 
		
			o.worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
			o.worldNormal = UnityObjectToWorldNormal(v.normal); 

			o.uv = TRANSFORM_TEX(v.tex , _MainTex);

			COMPUTE_EYEDEPTH(o.scrPos.z);
			return o;
		}
	
		fixed4 frag ( v2f i ) : SV_TARGET
		{
			
			fixed4 mainColor = tex2D(_MainTex , i.uv)*_MainColor;

		
			//获取深度图和clip space的深度值
			float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)));
			float partZ = i.scrPos.z;

			//diff为比较两个深度值
 			float diff = saturate((sceneZ-i.scrPos.z)*_EdgePow);
			mainColor.a *= diff;


			return mainColor;
		}

		ENDCG
		}
	}
}
