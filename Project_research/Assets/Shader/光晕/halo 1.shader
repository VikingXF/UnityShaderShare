// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*********************************************************************
xf 2018.4.25
实现星球光晕材质效果
Rim效果
顶点沿法线挤压描边
星球外发光效果
**********************************************************************/

Shader "Babybus/halo"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RimColor("RimColor",Color) = (0,0,0,1)
		_RimPower("RimPower",Range(0,5)) = 0.5
		
		_GlowColor("Glow Color" , Color) = (0,0.5,1,1)		//外发光颜色
		_GlowPow("Glow Pow" , Range(0,8)) = 2				//外发光强度
		_Glowstrength("Glow strength" , Range(0,8)) = 1  	//外发光范围

	}
	SubShader
	{		
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100
		Cull Off
		
		//渲染外发光
		Pass
		{			
			Stencil {
				Ref 2
                Comp NotEqual
                Pass keep 
                ZFail decrWrap

			}
			Blend One One
			ZWrite On
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				
			};

			struct v2f
			{
				fixed4 color : TEXCOORD0;
				float4 pos : SV_POSITION;
				
			};

			fixed4 _GlowColor;
			half _Glowstrength , _GlowPow;
			v2f vert (appdata v)
			{
				v2f o;
			
				float3 Normal = UnityObjectToWorldNormal(v.normal);
				v.vertex.xyz += v.normal*_Glowstrength;
				o.pos = UnityObjectToClipPos(v.vertex);
				half3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				
				half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);  
				
				float rim = max(0, dot(viewDir, Normal));  
				o.color = pow(rim,_GlowPow) * _GlowColor;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
 
				float4 col = i.color * i.color *2;				
				return col ;
			}
			ENDCG
		}
		
	}
}
