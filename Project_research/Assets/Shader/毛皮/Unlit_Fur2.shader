﻿// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Unlit/Fur2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_LayerTex("Layer", 2D) = "white" {}
		_NoiseTex("Noise", 2D) = "white" {}
		_UVoffset("UV偏移：XY=UV偏移;ZW=UV扰动", Vector) = (0, 0, 0.2, 0.2)

		_FurLength("Fur Length", Range(.0002, 1)) = .25
		_Cutoff("Alpha Cutoff", Range(0,1)) = 0.5 // how "thick"
		_CutoffEnd("Alpha Cutoff end", Range(0,1)) = 0.5 // how thick they are at the end
		_EdgeFade("Edge Fade", Range(0,1)) = 0.4

		_Gravity("Gravity Direction", Vector) = (0,-1,0,0)
		_GravityStrength("Gravity Strength", Range(0,1)) = 0.25
	}

	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityCG.cginc"

		struct appdata_t {
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
			half3 normal	: NORMAL;
			fixed4 color : COLOR;
		};

		struct v2f {
			float4 vertex : SV_POSITION;
			fixed4 color : COLOR;
			half2 texcoord : TEXCOORD0;
			UNITY_FOG_COORDS(1)
			half4 posWorld : TEXCOORD2;
			half3 normalDir : TEXCOORD3;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;

		sampler2D _LayerTex;
		float4 _LayerTex_ST;

		sampler2D _NoiseTex;
		float4 _NoiseTex_ST;

		half4 _UVoffset;
		half _FurLength;
		half _Cutoff;
		half _CutoffEnd;
		half _EdgeFade;

		half3 _Gravity;
		half _GravityStrength;
		
		v2f vert_internal(appdata_t v, half FUR_OFFSET)
		{
			v2f o;

			half3 direction = lerp(v.normal, _Gravity * _GravityStrength + v.normal * (1 - _GravityStrength), FUR_OFFSET);
			v.vertex.xyz += direction * _FurLength * FUR_OFFSET * v.color.a;

			o.vertex = UnityObjectToClipPos(v.vertex);

			o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

			o.posWorld = mul(unity_ObjectToWorld, v.vertex);
			o.normalDir = mul(unity_ObjectToWorld, half4(v.normal, 0)).xyz;

			UNITY_TRANSFER_FOG(o,o.vertex);
			return o;
		}

		fixed4 frag_internal(v2f i, half FUR_OFFSET)
		{
			/*half3 normalDirection = normalize(i.normalDir);
			half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);*/

			fixed4 _BaseColor = tex2D(_MainTex, i.texcoord.xy);

			fixed alpha = tex2D(_LayerTex, TRANSFORM_TEX(i.texcoord.xy, _LayerTex)).r;

			alpha = step(lerp(_Cutoff, _CutoffEnd, FUR_OFFSET), alpha);
			

			/*half3 NoiseTex = tex2D(_NoiseTex, TRANSFORM_TEX(i.texcoord.xy, _NoiseTex)).rgb;
			half Noise = NoiseTex.r;*/

			fixed4 color;
			color.rgb = _BaseColor.rgb;
			color.a = 1 - FUR_OFFSET * FUR_OFFSET;
			//color.a += dot(viewDirection, normalDirection) - _EdgeFade;
			//color.a = max(0, color.a);
			color.a *= alpha;

			UNITY_APPLY_FOG(i.fogCoord, color);
			return color;
		}
		

		v2f vert0(appdata_t v)
		{
			return vert_internal(v, 0);
		}

		
		v2f vert1(appdata_t v)
		{
			return vert_internal(v, 0.05);
		}
		
		v2f vert2(appdata_t v)
		{
			return vert_internal(v, 0.1);
		}
		
		v2f vert3(appdata_t v)
		{
			return vert_internal(v, 0.15);
		}
		
		v2f vert4(appdata_t v)
		{
			return vert_internal(v, 0.2);
		}		

		v2f vert5(appdata_t v)
		{
			return vert_internal(v, 0.25);
		}	
		
		v2f vert6(appdata_t v)
		{
			return vert_internal(v, 0.3);
		}		

		v2f vert7(appdata_t v)
		{
			return vert_internal(v, 0.35);
		}	
		
		v2f vert8(appdata_t v)
		{
			return vert_internal(v, 0.4);
		}	
		
		v2f vert9(appdata_t v)
		{
			return vert_internal(v, 0.45);
		}			
		

		fixed4 frag0(v2f i) : SV_Target
		{
			fixed4 color = tex2D(_MainTex, i.texcoord.xy);

			UNITY_APPLY_FOG(i.fogCoord, color);
			return fixed4(color.rgb, 1);
		}

		fixed4 frag1(v2f i) : SV_Target
		{
			return frag_internal(i, 0.05);
		}

		fixed4 frag2(v2f i) : SV_Target
		{
			return frag_internal(i, 0.1);
		}

		fixed4 frag3(v2f i) : SV_Target
		{
			return frag_internal(i, 0.15);
		}

		fixed4 frag4(v2f i) : SV_Target
		{
			return frag_internal(i, 0.2);
		}

		fixed4 frag5(v2f i) : SV_Target
		{
			return frag_internal(i, 0.25);
		}

		fixed4 frag6(v2f i) : SV_Target
		{
			return frag_internal(i, 0.3);
		}
		
		fixed4 frag7(v2f i) : SV_Target
		{
			return frag_internal(i, 0.35);
		}

		fixed4 frag8(v2f i) : SV_Target
		{
			return frag_internal(i, 0.4);
		}

		fixed4 frag9(v2f i) : SV_Target
		{
			return frag_internal(i, 0.45);
		}

		
		ENDCG

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert0
			#pragma fragment frag0
		
			ENDCG
		 
		}

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert1
			#pragma fragment frag1
		
			ENDCG
		 
		}

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert2
			#pragma fragment frag2
		
			ENDCG
		 
		}

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert3
			#pragma fragment frag3
		
			ENDCG
		 
		}
		
		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert4
			#pragma fragment frag4
		
			ENDCG
		 
		}

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert5
			#pragma fragment frag5
		
			ENDCG
		 
		}	

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert6
			#pragma fragment frag6
		
			ENDCG
		 
		}

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert7
			#pragma fragment frag7
		
			ENDCG
		 
		}

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert8
			#pragma fragment frag8
		
			ENDCG
		 
		}

		Pass { 
	
			CGPROGRAM
		
			#pragma vertex vert9
			#pragma fragment frag9
		
			ENDCG
		 
		}

		
	}
}
