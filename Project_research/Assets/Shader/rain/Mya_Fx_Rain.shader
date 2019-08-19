Shader "Mya/Fx_Rain"
{
	Properties
	{
		_Color("Main Color" , Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Speed("speed" , Range(0,10)) = 1
	}
	SubShader
	{
		Tags 
		{
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent" 
		}
		LOD 100
		//Blend SrcAlpha OneMinusSrcAlpha
		Blend One One
		Cull Off 
		ZWrite Off
		Pass
		{
			Name "FORWARD"
			Fog { Mode Off }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				fixed4 col : COLOR;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 uv1 : TEXCOORD0;
				float4 uv2 : TEXCOORD1;
				fixed4 col : COLOR;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			half _Speed;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				half2 uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv1.xy = uv*1.5 + _Time.x * half2(-0.2 , _Speed);
				o.uv1.zw = uv*2 + _Time.x *  half2(0.2 , _Speed);
				o.uv2.xy = uv*3 + _Time.x *  half2(-0.2 , _Speed);
				o.uv2.zw = uv*4 + _Time.x *  half2(0.2 , _Speed);
				o.col = v.col;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col1 = tex2D(_MainTex, i.uv1.xy) *_Color;
				fixed4 col2 = tex2D(_MainTex, i.uv1.zw) *_Color;
				fixed4 col3 = tex2D(_MainTex, i.uv2.xy) *_Color;
				fixed4 col4 = tex2D(_MainTex, i.uv2.zw) *_Color;

				fixed4 col  = col1+ col2 + col3+ col4;

				col.rgb *= col.a;
				return col*0.25* i.col.a;
			}
			ENDCG
		}
	}
}
