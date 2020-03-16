// 使用同样底板

Shader "Babybus/Unlit/double texture3"
{
	Properties {
	
	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	_MainTex1 ("Base (RGB) Alpha (A)1", 2D) = "white" {}
	_MainTex2 ("Base (RGB) Alpha (A)2", 2D) = "white" {}
	_Cutoff ("Base Alpha cutoff", Range (0,0.98)) = .5
}

SubShader {
	Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
	Lighting off
	// Render both front and back facing polygons.
	
	
	// first pass:
	//   render any pixels that are more than [_Cutoff] opaque
	
	Cull front
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
					
			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float4 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex1,_MainTex;
			float4 _MainTex1_ST,_MainTex_ST;
			float _Cutoff;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _MainTex1);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 col = tex2D(_MainTex, i.texcoord.xy);
				half4 col1 = tex2D(_MainTex1, i.texcoord.zw);
				col.rgb = lerp(col.rgb,col1.rgb,col1.a);
				clip(col.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, col);				
				return col;
			}
		ENDCG
	}
	//=====================================================================
	// Second pass:
	//   render the semitransparent details.
	Pass {
	Cull front
		Tags { "RequireOption" = "SoftVegetation" }
		
		// Dont write to the depth buffer
		ZWrite off
		
		// Set up alpha blending
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float4 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex1,_MainTex;
			float4 _MainTex1_ST,_MainTex_ST;
			float _Cutoff;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _MainTex1);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 col = tex2D(_MainTex, i.texcoord.xy);
				half4 col1 = tex2D(_MainTex1, i.texcoord.zw);
				col.rgb = lerp(col.rgb,col1.rgb,col1.a);
				
				clip(-(col.a - _Cutoff));
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
	//=====================================================================
	// Three  pass:
	//   render any pixels that are more than [_Cutoff] opaque
	Pass {  
	Cull back
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float4 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex2,_MainTex;
			float4 _MainTex2_ST,_MainTex_ST;
			float _Cutoff;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _MainTex2);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 col = tex2D(_MainTex, i.texcoord.xy);
				half4 col1 = tex2D(_MainTex2, i.texcoord.zw);
				col.rgb = lerp(col.rgb,col1.rgb,col1.a);
				clip(col.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, col);				
				return col;
			}
		ENDCG
	}
	//=====================================================================
	
	// four pass:
	//   render the semitransparent details.
	Pass {
	Cull back
		Tags { "RequireOption" = "SoftVegetation" }
		
		// Dont write to the depth buffer
		ZWrite off
		
		// Set up alpha blending
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float4 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex2,_MainTex;
			float4 _MainTex2_ST,_MainTex_ST;
			float _Cutoff;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _MainTex2);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 col = tex2D(_MainTex, i.texcoord.xy);
				half4 col1 = tex2D(_MainTex2, i.texcoord.zw);
				col.rgb = lerp(col.rgb,col1.rgb,col1.a);
				clip(-(col.a - _Cutoff));
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
	}
}

}
