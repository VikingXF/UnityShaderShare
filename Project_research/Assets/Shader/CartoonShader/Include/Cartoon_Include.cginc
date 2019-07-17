//卡通渲染CgInclude

#ifndef CARTOON_INCLUDE
#define CARTOON_INCLUDE


//================================================================================================================================
// 基础卡通光照模型
//--------------------------------------------------------------------------------------------------------------------------------

fixed4 _HColor;
fixed4 _SColor;
float _RampThreshold;
float _RampSmooth;

inline half4 LightingToonyColors(SurfaceOutput s, half3 lightDir, half atten)
{
	fixed ndl = max(0, dot(s.Normal, lightDir)*0.5 + 0.5);
	fixed3 ramp = smoothstep(_RampThreshold - _RampSmooth * 0.5, _RampThreshold + _RampSmooth * 0.5, ndl);
	ramp *= atten;
	_SColor = lerp(_HColor, _SColor, _SColor.a);	//Shadows intensity through alpha
	ramp = lerp(_SColor.rgb, _HColor.rgb, ramp);
	fixed4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * ramp;
	c.a = s.Alpha;
	return c;
}

#endif