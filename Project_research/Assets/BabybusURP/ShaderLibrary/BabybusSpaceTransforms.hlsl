#ifndef BABYBUS_SPACE_TRANSFORMS_INCLUDED
#define BABYBUS_SPACE_TRANSFORMS_INCLUDED

/*
返回矩阵“物体转世界”
*/
float4x4 GetObjectToWorldMatrix()
{
    return UNITY_MATRIX_M;
}

/*
返回矩阵“世界转物体”
*/
float4x4 GetWorldToObjectMatrix()
{
    return UNITY_MATRIX_I_M;
}

float4x4 GetWorldToViewMatrix()
{
    return UNITY_MATRIX_V;
}

float4x4 GetWorldToHClipMatrix()
{
    return UNITY_MATRIX_VP;
}

/* 
Transform to homogenous clip space
返回矩阵“视口转齐次空间”
*/
float4x4 GetViewToHClipMatrix()
{
    return UNITY_MATRIX_P;
}

/*
This function always return the absolute position in WS
返回世界空间下的绝对世界坐标
*/
float3 GetAbsolutePositionWS(float3 positionRWS)
{
#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
    positionRWS += _WorldSpaceCameraPos;
#endif
    return positionRWS;
}

/*
 This function return the camera relative position in WS
返回世界空间下摄像机的相对坐标
*/
float3 GetCameraRelativePositionWS(float3 positionWS)
{
#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
    positionWS -= _WorldSpaceCameraPos;
#endif
    return positionWS;
}


real GetOddNegativeScale()
{
    return unity_WorldTransformParams.w;
}

/*
物体坐标转世界坐标
*/
float3 TransformObjectToWorld(float3 positionOS)
{
    return mul(GetObjectToWorldMatrix(), float4(positionOS, 1.0)).xyz;
}
/*
世界坐标转物体坐标
*/
float3 TransformWorldToObject(float3 positionWS)
{
    return mul(GetWorldToObjectMatrix(), float4(positionWS, 1.0)).xyz;
}
/*
世界坐标转视口坐标
*/
float3 TransformWorldToView(float3 positionWS)
{
    return mul(GetWorldToViewMatrix(), float4(positionWS, 1.0)).xyz;
}

/*
Transforms position from object space to homogenous space
物体坐标转齐次坐标
*/
float4 TransformObjectToHClip(float3 positionOS)
{
     /*
    More efficient than computing M*VP matrix product
    比计算M*VP矩阵乘法效率更高
    */
    return mul(GetWorldToHClipMatrix(), mul(GetObjectToWorldMatrix(), float4(positionOS, 1.0)));
}

/*
 Tranforms position from world space to homogenous space
世界坐标转齐次坐标
*/
float4 TransformWorldToHClip(float3 positionWS)
{
    return mul(GetWorldToHClipMatrix(), float4(positionWS, 1.0));
}

/*
 Tranforms position from view space to homogenous space
视口坐标转齐次坐标
*/
float4 TransformWViewToHClip(float3 positionVS)
{
    return mul(GetViewToHClipMatrix(), float4(positionVS, 1.0));
}

/*
物体方向转世界方向
*/
real3 TransformObjectToWorldDir(real3 dirOS)
{
    /*
    Normalize to support uniform scaling
    标准化，以便支持统一缩放
    */
    return SafeNormalize(mul((real3x3)GetObjectToWorldMatrix(), dirOS));
}

/*
世界方向转物体方向
*/
real3 TransformWorldToObjectDir(real3 dirWS)
{
    /*
    Normalize to support uniform scaling
    标准化，以便支持统一缩放
    */
    return normalize(mul((real3x3)GetWorldToObjectMatrix(), dirWS));
}

/*
世界方向转视口方向
*/
real3 TransformWorldToViewDir(real3 dirWS)
{
    return mul((real3x3)GetWorldToViewMatrix(), dirWS).xyz;
}

/*
 Tranforms vector from world space to homogenous space
世界方向转齐次空间方向
*/
real3 TransformWorldToHClipDir(real3 directionWS)
{
    return mul((real3x3)GetWorldToHClipMatrix(), directionWS);
}

/*
 Transforms normal from object to world space
物体法线转世界法线
*/
float3 TransformObjectToWorldNormal(float3 normalOS)
{
#ifdef UNITY_ASSUME_UNIFORM_SCALING
    return TransformObjectToWorldDir(normalOS);
#else
    /*
    Normal need to be multiply by inverse transpose
    法线变换需要与逆转置矩阵相乘
    */
    return SafeNormalize(mul(normalOS, (float3x3)GetWorldToObjectMatrix()));
#endif
}

/*
 Transforms normal from world to object space
世界法线转物体法线
*/
float3 TransformWorldToObjectNormal(float3 normalWS)
{
#ifdef UNITY_ASSUME_UNIFORM_SCALING
    return TransformWorldToObjectDir(normalWS);
#else
    /*
    Normal need to be multiply by inverse transpose
    法线变换需要与逆转置矩阵相乘
    */
    return SafeNormalize(mul(normalWS, (float3x3)GetObjectToWorldMatrix()));
#endif
}

real3x3 CreateTangentToWorld(real3 normal, real3 tangent, real flipSign)
{
    /*
    For odd-negative scale transforms we need to flip the sign
    对于 odd-negative scale 变换，我们需要反转正负值
    关联知识点：https://blog.csdn.net/weixin_41885426/article/details/109817466
    */
    real sgn = flipSign * GetOddNegativeScale();
    real3 bitangent = cross(normal, tangent) * sgn;

    return real3x3(tangent, bitangent, normal);
}

real3 TransformTangentToWorld(real3 dirTS, real3x3 tangentToWorld)
{
    /* 
    Note matrix is in row major convention with 
    left multiplication as it is build on the fly
    注意左乘矩阵
    */
    return mul(dirTS, tangentToWorld);
}

real3 TransformWorldToTangent(real3 dirWS, real3x3 tangentToWorld)
{
    /* 
    Note matrix is in row major convention with 
    left multiplication as it is build on the fly
    注意左乘矩阵
    */
    float3 row0 = tangentToWorld[0];
	float3 row1 = tangentToWorld[1];
	float3 row2 = tangentToWorld[2];

	/*
     these are the columns of the inverse matrix but scaled by the determinant
     矩阵的列被行列式缩放
     */
	float3 col0 = cross(row1, row2);
	float3 col1 = cross(row2, row0);
	float3 col2 = cross(row0, row1);

	float determinant = dot(row0, col0);
	float sgn = determinant<0.0 ? (-1.0) : 1.0;

	/*
    inverse transposed but scaled by determinant
    通过行列式逆转置
    */
	real3x3 matTBN_I_T = real3x3(col0, col1, col2);

	// remove transpose part by using matrix as the first arg in mul()
	// this makes it the exact inverse of what TransformTangentToWorld() does.
	return SafeNormalize( sgn * mul(matTBN_I_T, dirWS) );
}

real3 TransformTangentToObject(real3 dirTS, real3x3 tangentToWorld)
{
    /*
    Note matrix is in row major convention with 
    left multiplication as it is build on the fly
    注意左乘矩阵
    */
	real3 normalWS = TransformTangentToWorld(dirTS, tangentToWorld);
	return TransformWorldToObjectNormal(normalWS);
}

real3 TransformObjectToTangent(real3 dirOS, real3x3 tangentToWorld)
{
    /*
    Note matrix is in row major convention with 
    left multiplication as it is build on the fly
    注意左乘矩阵
    */
	float3 normalWS = TransformObjectToWorldNormal(dirOS);
	return TransformWorldToTangent(normalWS, tangentToWorld);
}

#endif
