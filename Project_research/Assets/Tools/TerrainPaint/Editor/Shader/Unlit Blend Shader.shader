// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
2017.6.2修改
支持4张贴图进行基于Splatting算法的地表混合

利用贴图的A通道影响混合的强度，实现更自然的过渡
不受灯光影响(vertex编写)
*/

Shader "Babybus/Terrain Blend/Unlit Blend Shader"
{
	Properties
	{
		_Splat0 ("Layer 1(RGBA)", 2D) = "white" {}
    	_Splat1 ("Layer 2(RGBA)", 2D) = "white" {}
    	_Splat2 ("Layer 3(RGBA)", 2D) = "white" {}
    	_Splat3 ("Layer 4(RGBA)", 2D) = "white" {}
        _Tiling3("_Tiling4 x/y", Vector)=(1,1,0,0)
    	_Control ("Control (RGBA)", 2D) = "white" {}
        _Weight("Blend Weight" , Range(0.001,1)) = 0.2
	}
	SubShader
	{
		Tags {  "SplatCount" = "4" "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag					
			#include "UnityCG.cginc"
			#pragma target 2.0
			#pragma multi_compile_fog
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv_Control : TEXCOORD0;
				float2 uv_Splat0 : TEXCOORD1;
				float2 uv_Splat1 : TEXCOORD2;
				float2 uv_Splat2 : TEXCOORD3;
				
			
			};

			struct v2f
			{	
				float4 vertex : SV_POSITION;
				float2 uv_Control : TEXCOORD0;
				float2 uv_Splat0 : TEXCOORD1;
				float2 uv_Splat1 : TEXCOORD2;
				float2 uv_Splat2 : TEXCOORD3;
				UNITY_FOG_COORDS(4)
				
			};

			sampler2D _Control;
			sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
			float4 _Tiling3;
			float _Weight;
			float4 _Splat0_ST,_Splat1_ST,_Splat2_ST,_Control_ST;
			inline half4 Blend(half depth1 ,half depth2,half depth3,half depth4 , fixed4 control) 
			{
				half4 blend ;				
				blend.r =depth1 * control.r;
				blend.g =depth2 * control.g;
				blend.b =depth3 * control.b;
				blend.a =depth4 * control.a;
				
				half ma = max(blend.r, max(blend.g, max(blend.b, blend.a)));
				blend = max(blend - ma +_Weight , 0) * control;
				return blend/(blend.r + blend.g + blend.b + blend.a);
			}
			
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);	
				UNITY_TRANSFER_FOG(o,o.vertex);
				o.uv_Splat0 = TRANSFORM_TEX(v.uv_Splat0, _Splat0);
				o.uv_Splat1 = TRANSFORM_TEX(v.uv_Splat1, _Splat1);
				o.uv_Splat2 = TRANSFORM_TEX(v.uv_Splat2, _Splat2);				
				o.uv_Control = TRANSFORM_TEX(v.uv_Control, _Control);
				
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 splat_control = tex2D (_Control, i.uv_Control).rgba;
    		
				half4 lay1 = tex2D (_Splat0, i.uv_Splat0);
				half4 lay2 = tex2D (_Splat1, i.uv_Splat1);
				half4 lay3 = tex2D (_Splat2, i.uv_Splat2);

				//SM2.0超过4张贴图的UV会出BUG，所以用control来算出第四张贴图的UV
				half4 lay4 = tex2D (_Splat3, i.uv_Control *_Tiling3.xy);
				
				half4 blend = Blend(lay1.a,lay2.a,lay3.a,lay4.a,splat_control);
				
				fixed4 col = blend.r * lay1 + blend.g * lay2 + blend.b * lay3 + blend.a * lay4;		
				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_OPAQUE_ALPHA(col.a);				
				return col;
			}
			ENDCG
		}
	
	}
	 FallBack "Diffuse"
}
