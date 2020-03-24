Shader "Babybus/Particles/Rim water"
{
    Properties
    {
		_MainTex("Pass1Tex", 2D) = "white" {}
		_MainTex2("Pass2Tex", 2D) = "white" {}
		_MaskTex("Pass2MaskTex", 2D) = "white" {}
		_Alpha("Base Alpha", Range(0,1)) = 1

		//_offsetScale("波偏移", float) = 1
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

			sampler2D _MainTex,_MainTex2,_MaskTex;
			float4 _MainTex_ST,_MainTex2_ST, _MaskTex_ST;
			float4 _RimColor;
			float _RimPower, _RimIntensity;
			float _Alpha;
			half _TimeScale, _remap, _amplitude;
			//half _offsetScale;
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
				float3 normal :NORMAL;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float NdotV : COLOR;

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

				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex2);
				o.uv.zw = TRANSFORM_TEX(v.texcoord2, _MaskTex)+float2(0,-_Time.y);

				float3 normalDirection = normalize(WorldSpaceViewDir(v.vertex));
				float3 normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.NdotV = saturate(dot(normalDir, normalDirection));
				return o;
			};

			v2f vertbase(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex*0.8);
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			};

			fixed4 fragRim(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex2,i.uv.xy);
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.zw);

				float rim = pow((1 - i.NdotV), _RimPower)*_RimIntensity*_RimColor.a;
				float3 Rim = rim * _RimColor.rgb;
				Maskcol.rgb = lerp(Maskcol.rgb*_RimColor.rgb, Rim, rim);
				Maskcol.a = saturate(Maskcol.a+rim);
				col = lerp(col, Maskcol, 1-col.a);
				return col;
			};

			fixed4 fragbase(v2f i) : SV_Target
			{

				fixed4 col = tex2D(_MainTex, i.uv.xy);
				col.a *= _Alpha;
				return col;
			}

		ENDCG
        Pass
        {
			//cull back
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			//Blend One One
			//Blend DstColor SrcColor
			//Blend OneMinusDstColor One
            CGPROGRAM
            #pragma vertex vertbase
            #pragma fragment fragbase       
            ENDCG
        }

		Pass
        {
			//cull back
			ZWrite Off
			//Blend SrcAlpha OneMinusSrcAlpha
			//Blend One One
			//Blend DstColor SrcColor
			Blend OneMinusDstColor One
			//Blend DstColor Zero
		
            CGPROGRAM
            #pragma vertex vertRim
            #pragma fragment fragRim       
            ENDCG
        }
    }
}
