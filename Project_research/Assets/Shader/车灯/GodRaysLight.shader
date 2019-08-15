Shader "Mya/GodRaysLight"
{
	Properties
	{
		_Color("Color" , Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Noise("Noise" , 2D) = "Black"{}
		_NoiseIntensity("Noise Intensity" , float) = 0.2
		_NoiseWave("Noise Wave" , vector) = (-1.0,2.0,2.0,-1.0)
		_MaxDistance("Distance Max" , float) = 20.0
		_MinDistance("Distance Min" , float) = 1.0
		_ViewAngleWeight("View Angle weight" , float) = 2
		_MaxBrightness("Max Brightness" , Range(0,8)) = 2
		_ViewClipRange("View SoftClip Range" , Range(0,1)) = 0.5
		_ViewClipNear("Clip Near" , float) = 0.3
	}
	SubShader
	{
	
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		LOD 100
		Blend One One
		//Blend One OneMinusSrcColor
	   	Cull Off 
		Lighting Off 
		ZWrite Off 
		Fog { Color (0,0,0,0) }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex	: POSITION;
				float2 uv		: TEXCOORD0;
				fixed4 color	: COLOR;
				half3 normal	:NORMAL;
			};

			struct v2f
			{
				float4 pos		: SV_POSITION;
				float2 uv		: TEXCOORD0;
				float4 uv_noise : TEXCOORD1;
				float4 viewPos	: TEXCOORD2;
				fixed4 color	: COLOR;
			};

			fixed4		_Color;

			sampler2D	_MainTex;
			float4		_MainTex_ST;

			sampler2D	_Noise;
			float4		_Noise_ST;
			half4		_NoiseWave;
			half		_NoiseIntensity;

			half		_MaxDistance;
			half		_MinDistance;
			half		_ViewAngleWeight;
			half		_MaxBrightness;
			half		_ViewClipRange;
			half		_ViewClipNear;



			v2f vert (appdata v)
			{
				v2f o;

				
				//摄像机空间体中心点的向量
				float3 viewSpacecenterDir = -normalize(float3(UNITY_MATRIX_MV[0].w, UNITY_MATRIX_MV[1].w, UNITY_MATRIX_MV[2].w));
				//摄像机空间法线
				half3 viewSpaceNormalDir =  normalize(mul((float3x3)UNITY_MATRIX_MV,v.normal));
				//法线与摄像机的夹角 VdotL
				half viewAngle = viewSpaceNormalDir.z *0.5 + 0.5;
				half powAngle = pow(viewAngle , _ViewAngleWeight);

				//把顶点转换到摄像机空间
				o.viewPos = mul(UNITY_MATRIX_MV , float4(v.vertex.xyz , 1));

				//顶点偏移
				o.viewPos.xyz += normalize(lerp( viewSpaceNormalDir , viewSpacecenterDir ,viewAngle ))* (_MinDistance + powAngle * _MaxDistance)  * v.color.a;

				//转换到裁切空间
				o.pos = mul(UNITY_MATRIX_P , o.viewPos );

				//主纹理uv
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				//噪音图uv
				float2 noiseUV = TRANSFORM_TEX(v.uv, _Noise); 
				o.uv_noise.xy = noiseUV + _Time.x * _NoiseWave.xy;
				o.uv_noise.zw = noiseUV * 0.7 + _Time.x * _NoiseWave.zw; 
				 
				//用观察角度来控制亮度
				o.color = powAngle * _MaxBrightness ;
				o.color.a = 1-v.color.a;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//当前像素到摄像机的距离
				half viewDistance = length(i.viewPos.xyz);
				//摄像机软裁剪值
				half viewSoftClip = saturate(viewDistance * _ViewClipRange - _ViewClipNear);

				//采样噪音图
				half noise = (tex2D(_Noise, i.uv_noise.xy) + tex2D(_Noise, i.uv_noise.zw) )* _NoiseIntensity;

				//采样主纹理
				fixed4 col = tex2D(_MainTex, i.uv) * _Color;

				//对亮度进行扰动
				col.rgb =  saturate((col.rgb - noise)  * i.color.rgb * i.color.a) ; 

				return col * viewSoftClip;
			}
			ENDCG
		}
	}
}