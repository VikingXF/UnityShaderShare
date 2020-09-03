/*
xf
主要实现水跟水泥混合搅拌效果
_LightDir:灯光方向
_WaterTex：水贴图
_CementTex：水泥贴图
_TimeTex：水泥表面流光
_TimeSpeed :水泥表面流光流动速度
_CementColor：深色水泥贴图
_BlendRange：水从中间过渡到水泥参数

*/

Shader "Babybus/engineer/WaterToCement"
{
	Properties
	{
		_LightDir("光照方向", vector) = (3, -7, 0, 1)
		_WaterTex ("ColorTex", 2D) = "white" {}
		_CementTex ("CementTex", 2D) = "white" {}
		_TimeTex ("TimeTex", 2D) = "white" {}
		_TimeSpeed ("Time Speed", Range(0,5.0)) = 1.0
		_CementColor ("CementColor", Color) = (1,1,1,1) 
		_BlendRange("Blend Range", Range(-1, 2)) = 1
		[Enum(Off, 0, On, 1)]_ZWriteMode ("ZWriteMode", float) = 0	
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off 
		Lighting Off 
		ZWrite[_ZWriteMode]
		LOD 100
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag						
			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 uv2 : TEXCOORD1;
				float4 vertex : SV_POSITION;				
				float3 worldNormal : TEXCOORD2;

			};

			sampler2D _CementTex,_WaterTex,_TimeTex;
			float4 _CementTex_ST,_WaterTex_ST,_TimeTex_ST;
			float _TimeSpeed;
			float4 _CementColor;
			float _BlendRange;
			half4 _LightDir;
			v2f vert (appdata v)
			{
				v2f o;	
	
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _WaterTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _CementTex);
				o.uv2.xy = TRANSFORM_TEX(v.uv,_TimeTex);
				o.uv2.zw = v.uv;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);  
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 Watercol = tex2D(_WaterTex, i.uv.xy);
				fixed4 Timecol = tex2D(_TimeTex, i.uv2.xy);
				fixed4 Cementcol = tex2D(_CementTex, i.uv.zw+Timecol.r+sin(_Time.x*_TimeSpeed));								
				float2 uv_center = i.uv2.zw*2.0-1;	
				float2 uv_dir = distance(uv_center,fixed2(0,0)); 
				
				fixed4 col = lerp(Cementcol,Watercol,saturate(uv_dir.x-_BlendRange));
				col.rgb = lerp(col.rgb*_CementColor.rgb,col.rgb,pow(Timecol.r,1));
				//计算光照
				fixed3 lightDir = normalize(_LightDir); 
				fixed3 ndl = max(0, dot(i.worldNormal, lightDir)*0.5 + 0.5);
				col .rgb +=ndl/_LightDir.w;
				//fixed4 col = lerp(Cementcol*_CementColor,Cementcol,pow(Timecol.r,1));

				return col;
			}
			ENDCG
		}
	}
}
