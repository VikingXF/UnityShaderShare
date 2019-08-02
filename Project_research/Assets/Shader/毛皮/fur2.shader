Shader "Unlit/fur2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SubTex ("SubTex", 2D) = "white" {}		
		FUR_OFFSET("FUR_OFFSET",float) = 0.1
		_UVoffset("UV偏移：XY=UV偏移;ZW=UV扰动", Vector) = (0, 0, 0.2, 0.2)
		_SubTexUV("SubTex的UV", Vector) = (0, 0, 0.2, 0.2)
		_Color("Color",COLOR) = (0, 0, 0, 0)
		_BaseColor("BaseColor",COLOR) = (0, 0, 0, 00)
	}
	CGINCLUDE
		
		#include "UnityCG.cginc"
	
		sampler2D _MainTex,_SubTex;
		float4 _MainTex_ST;
		float  FUR_OFFSET;
		float4 _UVoffset;
		float4 _SubTexUV;
		float4 _Color,_BaseColor;
	
		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
			float3 normal : NORMAL;
			float4 color : COLOR;
		};

		struct v2f
		{
			float4 uv : TEXCOORD0;
			float4 vertex : SV_POSITION;
		};

			
		v2f vert_fur1 (appdata v)
		{
			v2f o;
			float3 aNormal = (v.normal.xyz);

			aNormal.xyz += FUR_OFFSET;

			float3 n = aNormal * FUR_OFFSET * (FUR_OFFSET * saturate(v.color.a));
			v.vertex.xyz += n;

			float2 uvoffset= _UVoffset.xy  * FUR_OFFSET;

			uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

			float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

			float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

			o.uv = float4(uv1,uv2);

			o.vertex = UnityObjectToClipPos(v.vertex);

			//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

			return o;
		}
			
		fixed4 frag_fur1 (v2f i) : SV_Target
		{
			half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

			half Noise = NoiseTex.r;
			fixed4 color =_Color;
			color.rgb = lerp(_Color.rgb,_BaseColor.rgb,FUR_OFFSET) ;

			color.a = saturate(Noise-FUR_OFFSET) ;

			return color;
		}
	
	ENDCG
	SubShader
	{
		
		Pass
		{
			//ZTest Off
			//Cull Off
			//ZWrite Off
			Fog{ Mode Off }
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM			
			#pragma vertex vert_fur1
			#pragma fragment frag_fur1
			
			ENDCG
		}
	
	}
}
