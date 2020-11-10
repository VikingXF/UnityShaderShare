// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Babybus/SeawaterDistortion" {
	Properties {
	_NoiseTex ("Noise Texture (RG)", 2D) = "white" {}
	_MainTex ("Alpha (A)", 2D) = "white" {}
	_distortionTime  ("distortion Time", range (0,1.5)) = 0.1
	_distortionForce  ("distortion Force", range (0,0.1)) = 0.01
	
	_distanceFactor("距离系数",float)=1.0  
	_timeFactor("时间系数",float)=1.0  
	_totalFactor("sin函数结果系数",float)=1.0  
	_waveWidth("波纹宽度",float)=1.0  
	_waveSpeed("波纹扩散的速度",float)=1.0
	_waveStartTime("Float value",float)=1.0 
}

Category {
	Tags { "Queue"="Transparent+1" "RenderType"="Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	AlphaTest Greater .01
	Cull Off
	Lighting Off
	ZWrite Off
	

	SubShader {
		GrabPass {							
			Name "BASE"
			Tags { "LightMode" = "Always" }
 		}

		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
			
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#include "UnityCG.cginc"

struct appdata_t {
	float4 vertex : POSITION;
	fixed4 color : COLOR;
	float2 texcoord: TEXCOORD0;
};

struct v2f {
	float4 vertex : POSITION;
	float4 uvgrab : TEXCOORD0;
	float2 uvmain : TEXCOORD1;
};

float _distortionForce;
float _distortionTime;
float4 _MainTex_ST;
float4 _NoiseTex_ST;
sampler2D _NoiseTex;
sampler2D _MainTex;

v2f vert (appdata_t v)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	#if UNITY_UV_STARTS_AT_TOP
	float scale = -1.0;
	#else
	float scale = 1.0;
	#endif
	o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
	o.uvgrab.zw = o.vertex.zw;
	o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
	return o;
}

sampler2D _GrabTexture;
uniform float _distanceFactor;
uniform float _timeFactor;
uniform float _totalFactor;
uniform float _waveWidth;
uniform float _waveSpeed;
uniform float _waveStartTime;
uniform float _curWaveDis;
	
half4 frag( v2f i ) : COLOR
{

	//noise effect
	//half4 offsetColor1 = tex2D(_NoiseTex, i.uvmain + _Time.xz*_distortionTime);
    //half4 offsetColor2 = tex2D(_NoiseTex, i.uvmain - _Time.yx*_distortionTime);
	//i.uvgrab.x += ((offsetColor1.r + offsetColor2.r) - 1) * _distortionForce;
	//i.uvgrab.y += ((offsetColor1.g + offsetColor2.g) - 1) * _distortionForce;
	
	float curWaveDis = (_Time.y - _waveStartTime) * _waveSpeed;
	//计算uv到中间点的向量(向外扩，反过来就是向里缩)
	float2 dv = float2(0.5, 0.5) - i.uvgrab.xy;
		
	//按照屏幕长宽比进行缩放
	dv = dv * float2(_ScreenParams.x / _ScreenParams.y, 1);
	//计算像素点距中点的距离
	float dis = sqrt(dv.x * dv.x + dv.y * dv.y);
	//用sin函数计算出波形的偏移值factor
	//dis在这里都是小于1的，所以我们需要乘以一个比较大的数，比如60，这样就有多个波峰波谷
	//sin函数是（-1，1）的值域，我们希望偏移值很小，所以这里我们缩小100倍，据说乘法比较快,so...
	float sinFactor = sin(dis * _distanceFactor + _Time.y * _timeFactor) * _totalFactor * 0.01;
	//距离当前波纹运动点的距离，如果小于waveWidth才予以保留，否则已经出了波纹范围，factor通过clamp设置为0
	float discardFactor = clamp(_waveWidth - abs(curWaveDis - dis), 0, 1);
	//归一化
	float2 dv1 = normalize(dv);
	//计算每个像素uv的偏移值
	float2 offset = dv1  * sinFactor * discardFactor;
	//像素采样时偏移offset
	i.uvgrab.xy = offset + i.uvgrab.xy;
	

	half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
	//Skybox's alpha is zero, don't know why.
	col.a = 1.0f;
	half4 tint = tex2D( _MainTex, i.uvmain);
	//return tint;
	return col*tint;
}
ENDCG
		}
}

	// ------------------------------------------------------------------
	// Fallback for older cards and Unity non-Pro
	
	SubShader {
		Blend DstColor Zero
		Pass {
			Name "BASE"
			SetTexture [_MainTex] {	combine texture }
		}
	}
}
}
