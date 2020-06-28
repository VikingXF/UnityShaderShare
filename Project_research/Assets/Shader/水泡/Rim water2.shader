Shader "Babybus/Particles/Rim water2"
{
    Properties
    {
		_MainTex("Main Tex", 2D) = "white" {}
		_MaskTex("Mask Tex", 2D) = "white" {}
		_MaskColor("Mask Color", Color) = (1,1,1,1)
		_Alpha("Base Alpha", Range(0,5)) = 1
		_Watertime("水流速度", float) = 1

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

			sampler2D _MainTex,_MaskTex;
			float4 _MainTex_ST, _MaskTex_ST;
			float4 _RimColor,_MaskColor;
			float _RimPower, _RimIntensity;
			float _Alpha;
			half _TimeScale, _remap, _amplitude, _Watertime;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
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

				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord1, _MaskTex)+float2(0,_Time.y*_Watertime);

				float3 normalDirection = normalize(WorldSpaceViewDir(v.vertex));
				float3 normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.NdotV = saturate(dot(normalDir, normalDirection));
				return o;
			};

			fixed4 fragRim(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex,i.uv.xy);
				fixed4 Maskcol = tex2D(_MaskTex, i.uv.zw)*_MaskColor*_Alpha;

				float rim = pow((1 - i.NdotV), _RimPower)*_RimIntensity*_RimColor.a;
				float3 Rim = rim * _RimColor.rgb;
				Maskcol.rgb = lerp(Maskcol.rgb, Rim*_RimColor.rgb, rim);
				Maskcol.a = saturate(Maskcol.r+rim);
				col = saturate(lerp(col, Maskcol, 1-col.a));
				return col;
			};


		ENDCG

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
