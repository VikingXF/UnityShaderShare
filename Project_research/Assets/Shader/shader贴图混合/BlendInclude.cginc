#ifndef BLEND_INCLUDE_INCLUDED


//正片叠底
inline fixed4 Muitiply(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = Srccol * Destcol;
    return lerp(Srccol, col, Destcol.a);
}
//颜色加深
inline fixed4 ColorBurn(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(1 - (1 - Srccol) / Destcol);
    return lerp(Srccol, col, Destcol.a);
}
			
//颜色减淡
inline fixed4 ColorDodge(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(Srccol / (1 - Destcol));
    return lerp(Srccol, col, Destcol.a);
}
			
//线性加深
inline fixed4 LinearBurn(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(Destcol + Srccol - 1);
    return lerp(Srccol, col, Destcol.a);
}
			
//线性减淡
inline fixed4 LinearDodge(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(Destcol + Srccol);
    return lerp(Srccol, col, Destcol.a);
}
//变亮						
inline fixed4 Lighten(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = Destcol;
    if (Srccol.r <= Destcol.r)
    {
        col.r = saturate(Destcol.r);
    }
    if (Srccol.g <= Destcol.g)
    {
        col.g = saturate(Destcol.g);
    }
				
    if (Srccol.b <= Destcol.b)
    {
        col.b = saturate(Destcol.b);
    }
				
    if (Srccol.r > Destcol.r)
    {
        col.r = saturate(Srccol.r);
    }
    if (Srccol.g > Destcol.g)
    {
        col.g = saturate(Srccol.g);
    }
				
    if (Srccol.b > Destcol.b)
    {
        col.b = saturate(Srccol.b);
    }
    return lerp(Srccol, col, Destcol.a);
}

//变暗
inline fixed4 Darken(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = Destcol;
    if (Srccol.r <= Destcol.r)
    {
        col.r = saturate(Srccol.r);
    }
    if (Srccol.g <= Destcol.g)
    {
        col.g = saturate(Srccol.g);
    }
				
    if (Srccol.b <= Destcol.b)
    {
        col.b = saturate(Srccol.b);
    }
				
    if (Srccol.r > Destcol.r)
    {
        col.r = saturate(Destcol.r);
    }
    if (Srccol.g > Destcol.g)
    {
        col.g = saturate(Destcol.g);
    }
				
    if (Srccol.b > Destcol.b)
    {
        col.b = saturate(Destcol.b);
    }
    return lerp(Srccol, col, Destcol.a);
}
			
//滤色
inline fixed4 Screen(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(1 - (1 - Destcol) * (1 - Srccol));
    return lerp(Srccol, col, Destcol.a);
}
			
//叠加
inline fixed4 Overlay(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(2 * Destcol * Srccol);
    if (Srccol.r > 0.5)
    {
        col.r = saturate(1 - 2 * (1 - Destcol.r) * (1 - Srccol.r));
    }
    if (Srccol.g > 0.5)
    {
        col.g = saturate(1 - 2 * (1 - Destcol.g) * (1 - Srccol.g));
    }
				
    if (Srccol.b > 0.5)
    {
        col.b = saturate(1 - 2 * (1 - Destcol.b) * (1 - Srccol.b));
    }
    return lerp(Srccol, col, Destcol.a);
}
			
//柔光
inline fixed4 SoftLight(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate((2 * Destcol - 1) * (Srccol - Srccol * Srccol) + Srccol);
    if (Destcol.r > 0.5)
    {
        col.r = saturate((2 * Destcol.r - 1) * (sqrt(Srccol.r) - Srccol.r) + Srccol.r);
    }
    if (Destcol.g > 0.5)
    {
        col.g = saturate((2 * Destcol.g - 1) * (sqrt(Srccol.g) - Srccol.g) + Srccol.g);
    }
				
    if (Destcol.b > 0.5)
    {
        col.b = saturate((2 * Destcol.b - 1) * (sqrt(Srccol.b) - Srccol.b) + Srccol.b);
    }
    return lerp(Srccol, col, Destcol.a);
}
			
//强光
inline fixed4 HardLight(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(2 * Destcol * Srccol);
    if (Destcol.r > 0.5)
    {
        col.r = saturate(1 - 2 * (1 - Destcol.r) * (1 - Srccol.r));
    }
    if (Destcol.g > 0.5)
    {
        col.g = saturate(1 - 2 * (1 - Destcol.g) * (1 - Srccol.g));
    }
				
    if (Destcol.b > 0.5)
    {
        col.b = saturate(1 - 2 * (1 - Destcol.b) * (1 - Srccol.b));
    }
    return lerp(Srccol, col, Destcol.a);
}

//亮光
inline fixed4 VividLight(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(1 - (1 - Srccol) / (2 * Destcol));
    if (Destcol.r > 0.5)
    {
        col.r = saturate(Srccol.r / (2 * (1 - Destcol.r)));
    }
    if (Destcol.g > 0.5)
    {
        col.g = saturate(Srccol.g / (2 * (1 - Destcol.g)));
    }
				
    if (Destcol.b > 0.5)
    {
        col.b = saturate(Srccol.b / (2 * (1 - Destcol.b)));
    }
    return lerp(Srccol, col, Destcol.a);
}
			
//点光
inline fixed4 PinLight(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(min(2 * Destcol, Srccol));
    if (Destcol.r > 0.5)
    {
        col.r = saturate(max(2 * (Destcol.r - 0.5), Srccol.r));
    }
    if (Destcol.g > 0.5)
    {
        col.g = saturate(max(2 * (Destcol.g - 0.5), Srccol.g));
    }
				
    if (Destcol.b > 0.5)
    {
        col.b = saturate(max(2 * (Destcol.b - 0.5), Srccol.b));
    }
    return lerp(Srccol, col, Destcol.a);
}

//线性光
inline fixed4 LinearLight(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(Srccol + 2 * Destcol - 1);
    return lerp(Srccol, col, Destcol.a);
}
			
//实色混合
inline fixed4 HardMix(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = Srccol;
    if (Destcol.r < 1 - Srccol.r)
    {
        col.r = 0;
    }
    if (Destcol.g < 1 - Srccol.g)
    {
        col.g = 0;
    }
				
    if (Destcol.b < 1 - Srccol.b)
    {
        col.b = 0;
    }
    if (Destcol.r > 1 - Srccol.r)
    {
        col.r = 1;
    }
    if (Destcol.g > 1 - Srccol.g)
    {
        col.g = 1;
    }
				
    if (Destcol.b > 1 - Srccol.b)
    {
        col.b = 1;
    }
    return lerp(Srccol, col, Destcol.a);
}

//差值
inline fixed4 Difference(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(abs(Destcol - Srccol));
    return lerp(Srccol, col, Destcol.a);
}
			
//排除
inline fixed4 Exclusion(fixed4 Srccol, fixed4 Destcol)
{
    fixed4 col = saturate(Destcol + Srccol - 2 * Destcol * Srccol);
    return lerp(Srccol, col, Destcol.a);
}
			
			
// B：Srccol A：Destcol

#endif