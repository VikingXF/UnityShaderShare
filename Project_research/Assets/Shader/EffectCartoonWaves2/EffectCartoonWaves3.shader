Shader "Babybus/Particles/EffectCartoonWaves3"
{
	Properties
	{		
		_TintColor ("Color&Alpha", Color) = (1,1,1,1)
		_N_mask ("N_mask", Float ) = 0.3
		_B_mask ("B_mask", Range(0, 1) ) = 1
		_B_mask2("B_mask2", Range(0, 1)) = 0	
		
        _T_mask ("T_mask", 2D) = "white" {}
		_WaveParams ("RG各个方向偏移速度", vector) = (0,0,0,0)	
		_length("length", Range(0, 1)) = 0.2	
		_Transitions("Transitions", Range(0, 1)) = 0		
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4  //声明外部控制开关
	}
	SubShader
	{
		Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

		Pass
		{
		
			 Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off
            ZTest [_ZTest] //获取值应用
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 vertexColor : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 vertexColor : TEXCOORD2;
				float4 uv2 : TEXCOORD3;
			};

			 sampler2D _T_mask; 
			float4 _T_mask_ST;

            float4 _TintColor;
            float _N_mask,_B_mask,_B_mask2;
			float4 _WaveParams;
			fixed _Transitions,_length;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _T_mask)+fixed2(_Time.x*_WaveParams.x, _Time.x*_WaveParams.y);
				o.uv.zw = TRANSFORM_TEX(v.uv, _T_mask)+fixed2(_Time.x*_WaveParams.z, _Time.x*_WaveParams.w);
				o.uv2.xy = TRANSFORM_TEX(v.uv, _T_mask);
				o.uv2.zw =v.uv;
				o.vertexColor = v.vertexColor;
				 
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				float4 col = _TintColor;				
				float _T_mask_var_R = tex2D(_T_mask, i.uv.xy).x;
				float _T_mask_var_G = tex2D(_T_mask, i.uv.zw).y;
				float _T_mask_var_B = tex2D(_T_mask, i.uv2.xy).z;
				//计算alpha   
				
				float _BRange = saturate((i.uv2.w - _B_mask )/_B_mask2);
				
				//float leB = step(_T_mask_var_R+_T_mask_var_G+_T_mask_var_B,_N_mask);
				float leB = step(_T_mask_var_R+_T_mask_var_G+_BRange,_N_mask);
				
				float _BlendRange = saturate((i.uv2.w - _length ) /_Transitions);
				
				col.a *= (1-leB)*i.vertexColor.a*_BlendRange;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
