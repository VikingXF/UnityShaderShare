Shader "Babybus/Particles/Rim water"
{
    Properties
    {
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_MainTex2("Base (RGB) Trans (A)2", 2D) = "white" {}
		_Alpha("Base Alpha", Range(0,1)) = 1

		_offsetScale("波偏移", float) = 1
		_TimeScale("波速", float) = 1
		_remap("振幅", Range(0, 100)) = 6.8  //振幅
		_amplitude("振幅强度", Range(0, 10)) = 0   //振幅强度

		_RimColor("Rim Color", Color) = (0.5,0.5,0.5,1)
		_RimPower("Rim Power", Range(0.0, 5)) = 0.1
		_RimIntensity("Rim Intensity", Range(0.0, 10)) = 3
    }
    SubShader
    {
		Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		LOD 100

		CGINCLUDE
			#include "UnityCG.cginc"

			sampler2D _MainTex,_MainTex2;
			float4 _MainTex_ST,_MainTex2_ST;
			float4 _RimColor;
			float _RimPower, _RimIntensity;
			float _Alpha;
			half _TimeScale, _remap, _amplitude, _offsetScale;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal :NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 NdotV : COLOR;
			};

			v2f vertRim(appdata_t v)
			{
				v2f o;

				//顶点Y轴sin位移
				fixed4 offset = float4(0, 0, 0, 0);
				//offset.y = _amplitude*sin( (v.texcoord.x)*_remap+_Time.y*_TimeScale+_offsetScale);
				offset.x = _amplitude * sin((v.texcoord.y)*_remap + _Time.y*_TimeScale);
				o.vertex = UnityObjectToClipPos(v.vertex + offset.y + offset.x);

				//o.vertex = UnityObjectToClipPos(v.vertex);

				o.uv = v.texcoord;
				float3 normalDirection = normalize(WorldSpaceViewDir(v.vertex));
				float3 normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.NdotV.x = saturate(dot(normalDir, normalDirection));
				return o;
			};

			v2f vertbase(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex*0.8);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			};

			fixed4 fragRim(v2f i) : SV_Target
			{
				half4 col = tex2D(_MainTex2,i.uv);		
				float3 Rim = pow((1 - i.NdotV.x), _RimPower)* _RimColor.rgb *_RimIntensity*_RimColor.a;
				col.rgb = lerp(col.rgb,Rim,1-col.a);
				//col.a *= _Alpha;
				col.a = saturate(col.a+Rim.r);
				return col;
			};

			fixed4 fragbase(v2f i) : SV_Target
			{

				fixed4 col = tex2D(_MainTex, i.uv);
				col.a *= _Alpha;
				return col;
			}

		ENDCG
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vertbase
            #pragma fragment fragbase       
            ENDCG
        }

		Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vertRim
            #pragma fragment fragRim       
            ENDCG
        }
    }
}
