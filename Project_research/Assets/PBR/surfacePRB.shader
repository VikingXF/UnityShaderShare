Shader "Unlit/surfacePRB"
{
 Properties {

//[Header(SURFACE PROPERTICE)]这个表示分类，里面不可以有中文

[Header(SURFACE PROPERTICE)]

_CutOff("CutOff", Range(0,1)) = 1.0

_Color ("Main Color", Color) = (1,1,1,1)

[NoScaleOffset]_MainTex ("Albedo (RGB)", 2D) = "white" {}

[NoScaleOffset]_BurnMap("法线图 (RGB)", 2D) = "white" {}

//NoScaleOffset有这个关键字，就不可以

[Header(MICROFACET LOD 0 PHASE PROPERTICE)]

[NoScaleOffset]_PBRTex("pbr图 (RGB),R粗糙度，G 金属性，B AO", 2D) = "white" {}

[Header(TESTCODE)]

[FloatRange]_MetallicAdjust("Metallic Adjust", Range(0,1.5)) = 1.0

[FloatRange]_RoughnessAdjust("Roughness Adjust", Range(0,1.5)) = 1.0

[FloatRange]_AOAdjust ("A Occulusion Adjust", Range(0,2)) = 1.0

//自发光

[Header(SELF ILLUMINATTON)]

[NoScaleOffset]_EmissionTex( "Emission" ,2D) = "white"{}

_EmissionScale( "Emission Scale" , Range(0,1))=0

//受伤效果

[Header(BE SHOT EFFECT)]

// KeywordEnum表示一个开关,如下图

[KeywordEnum(Off,On)]_HitEffect("HitEffect state",Float) = 0

_GlowColor("Glow Color",Color)=(1,1,1,1)

[PowerSlider(3.0)]_RimPower("Rim Power",Range(0.0,10))=1

//隐匿效果

[Header(DISSOLVE FX)]

[KeywordEnum(Off,On)]_DissolveEffect("Death state",Float) = 0

_BurnSize("Burn Size" , Range(0.0,1.0)) = 0.05

[NoScaleOffset]_BurnRamp("Burn Ramp(RGB)" ,2D) = "white"{}

[NoScaleOffset]_DissolveTex("Dissolve Texture" ,2D) = "white"{}

_DissolvePower("Dissolve Power" , Range(-0.2,0.25)) = -0.2

_DissolveEmissionColor("Dissolve Emission Color" , Color) = (1,1,1)

}

SubShader{

//不透明材质，不可以版本检查

Tags { "RenderType" = "Opaque" "PerformanceChecks"="false" }

LOD 400

AlphaTest Greater[_DissolvePower]//透明度测试，大于这个值不渲染出来

CGPROGRAM

//#include "../PanguShaderCommon.cginc"

// Physically based Standard lighting model, and enable shadows on all light types

//表面标准材质，不接受灯光，动态光，没有雾，没有前置，没有meta

#pragma surface surf Standard nolightmap nodynlightmap nofog nometa noforwardadd vertex:vert

//手机上要加这个，表示最快ARB，不明白加就是行了

#pragma fragmentoption ARB_precision_hint_fastest

//下面是两个预置宏

#pragma multi_compile _HITEFFECT_OFF _HITEFFECT_ON

#pragma multi_compile _DISSOLVEFFECT_OFF _DISSOLVEEFFECT_ON

//不能在手机gles

#pragma exclude_renderers gles

//只有dx11，opengl,gles3,苹果的metal 苹果5s以上

#pragma only_renderers d3d11 glcore gles3 metal

//glsl编译到移动平台GLSL时，关闭顶点着色器中对法线和切线进行自动规范化

#pragma glsl_no_auto_normalization

//sampler2d的半浮点型

sampler2D_half _MainTex;

sampler2D_half _BumpMap;

sampler2D_half _PBRTex;

half _CutOff;

fixed4 _Color;

sampler2D_half _EmissionTex;

#pragma target 3.5 //3.5以上，就是sm3以上

fixed _MetallicAdjust, _RoughnessAdjust, _AOAdjust, _EmissionScale;

//受到伤害时表面内发光

#if _HITEFFECT_ON

fixed4 _GlowColor;

fixed _RimPower;

#endif

//消去材质

#if _DISSOLVEEFFECT_ON

sampler2D_half _DissolveTex;

sampler2D_half _BurnRamp;

fixed3 _DissolveEmissionColor;

fixed _DissolvePower;

fixed _BurnSize;

#endif

struct Input {

float2 uv_MainTex;

half2 uv_DissolveTex;

float viewDir;

fixed color;

INTERNAL_DATA

};

//INTERNAL_DATA声明，可以访问经过法线贴图修改后的平面的法线信息

void vert(inout appdata_full v, out Input o)

{

UNITY_INITIALIZE_OUTPUT(Input, o);

o.color = v.color;

}

void surf (Input IN, inout SurfaceOutputStandard o) {

// Albedo comes from a texture tinted by color

fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

o.Albedo = c.rgb;

//clip就是消去

#if _DISSOLVEEFFECT_ON

clip(tex2D(_DissolveTex, IN.uv_DissolveTex).rgb - (_DissolvePower));

half4 dissolveTex = tex2D(_DissolveTex, IN.uv_DissolveTex);

#endif

fixed3 pbrTexRGB = tex2D(_PBRTex, IN.uv_MainTex).rgb;

o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));

o.Smoothness = pbrTexRGB.r*_RoughnessAdjust;

o.Metallic = pbrTexRGB.r*_MetallicAdjust;

o.Occlusion = lerp(pbrTexRGB.b, 1, 1 - _AOAdjust);

half3 e = tex2D(_EmissionTex, IN.uv_MainTex).rgb;

o.Emission = e.rgb*_EmissionScale;

#if _HITEFFECT_ON

half rimFactor = 1 - max(min(dot(normalize(IN.viewDir), o.Normal), 1),0);

half4 r_c = ((rimFactor *rimFactor) + (rimFactor*(rimFactor*0.425)))*_RimPower*_GlowColor;

o.Albedo += r_c;

#else

o.Albedo;

#endif

#if _DISSOLVEEFFECT_ON

o.Alpha = (_DissolvePower - dissolveTex.r);

if (( o.Alpha < 0 ) && ( o.Alpha > - 0.05))

{

o.Alpha = 1;

o.Emission = tex2D(_BurnRamp, fixed2(dissolveTex.r*(1 / _BurnSize), 0));

o.Albedo = _DissolveEmissionColor*o.Emission;

}

#endif

o.Alpha = c.a- _CutOff;//透明度就透明度减于cutoff值

if (c.a < _CutOff)

{

discard;

}

}

ENDCG

}

FallBack "Diffuse"

}