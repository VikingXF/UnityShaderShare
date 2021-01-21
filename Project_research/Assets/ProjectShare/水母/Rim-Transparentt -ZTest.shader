// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Babybus/Unlit/Rim Transparent ZTest" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_RimColor("Rim Color", Color) = (0.5,0.5,0.5,1)  
    _RimPower("Rim Power", Range(0.0, 5)) = 0.1 
	_RimIntensity("Rim Intensity", Range(0.0, 10)) = 3 
	
	[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4  //声明外部控制开关
	
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	ZTest [_ZTest] //获取值应用
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 NdotV:COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _RimColor;
            float _RimPower,_RimIntensity;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				
				float3 normalDirection = normalize(WorldSpaceViewDir(v.vertex));
				float3 normalDir =  normalize( mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.NdotV.x = saturate(dot(normalDir,normalDirection));
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				col.rgba += pow((1-i.NdotV.x) ,_RimPower)* _RimColor.rgba *_RimIntensity;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
}

}
