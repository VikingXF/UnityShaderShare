

Shader "Babybus/Unlit/holographic" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_AlphamaskTex ("Alpha Mask", 2D) = "white" {}
	_st("st", float) = 3
	_SpeedX("Speed X", Range(-5, 5)) = 0 
	_SpeedY("Speed Y", Range(-5, 5)) = 0 
	_Alpha ("Base Alpha", Range (0,1)) = 1
	_RimColor("Rim Color", Color) = (0.5,0.5,0.5,1)  
    _RimPower("Rim Power", Range(0.0, 5)) = 0.1 
	_RimIntensity("Rim Intensity", Range(0.0, 10)) = 3  	
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	//ZWrite On
	Blend SrcAlpha OneMinusSrcAlpha 
	Pass {
			ZWrite On
			ColorMask 0
		}
	
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
			
			struct v2f
            {
                float4 vertex:POSITION;
                float2 uv:TEXCOORD0;
                float4 NdotV:COLOR;				
				float4 screenPos : TEXCOORD1;
            };
 
            sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _AlphamaskTex;
			float4 _AlphamaskTex_ST;
            float4 _RimColor;
            float _RimPower,_RimIntensity;
			float _Alpha;
			float _SpeedX,_SpeedY,_st;;
            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);				
				o.screenPos = ComputeScreenPos(o.vertex);
                float3 normalDirection = normalize(WorldSpaceViewDir(v.vertex));
				float3 normalDir =  normalize( mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.NdotV.x = saturate(dot(normalDir,normalDirection));
                return o;
            }
 
            half4 frag(v2f IN):COLOR
            {
                half4 c = tex2D(_MainTex,IN.uv);
				half4 Alphamaskc = tex2D(_AlphamaskTex,(IN.screenPos.xy/IN.screenPos.z)*_st+float2(_SpeedX*_Time.y,_SpeedY*_Time.y));
				
                c.rgb += pow((1-IN.NdotV.x) ,_RimPower)* _RimColor.rgb *_RimIntensity*_RimColor.a;
				c.a *= _Alpha*Alphamaskc.r;
                return c;
            }
			
		ENDCG
	}
}

}
