
Shader "Babybus/Particles/Particle Rim Add" {
Properties {	
	_Color ("Main Color", Color) = (0,0,0,1)
	_RimColor("RimColor", Color) = (1,1,1,1)  
    _RimPower("RimPower", Range(0, 10.0)) = 1.56  
	_RimIntensity("RimIntensity", Range(0, 10.0)) = 0.85  
}

SubShader {
	Tags { "IgnoreProjector" = "True" "Queue" = "Transparent" "RenderType" = "Transparent" "PreviewType" = "Plane"}
	LOD 100
	
	Pass {  
		Blend SrcAlpha One
	//Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;			
				float4 vertexColor : COLOR;
				float3 normal:NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;			
				float NdotV:TEXCOORD0;               
				float4 vertexColor : TEXCOORD1;
			};

			fixed4 _Color;
			fixed4 _RimColor;  
            float _RimPower,_RimIntensity; 
			
			v2f vert (appdata_t v)
			{
				v2f o;
				float3 normalDirection = normalize(WorldSpaceViewDir(v.vertex));
				float3 normalDir =  normalize( mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.NdotV = saturate(dot(normalDir,normalDirection));				
				o.vertex = UnityObjectToClipPos(v.vertex);			
				o.vertexColor = v.vertexColor;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = _Color;
				float Rim = pow((1-i.NdotV) ,_RimPower)*_RimIntensity*_RimColor.a;
				col.rgb +=Rim* _RimColor.rgb ;
				col.a *= Rim*i.vertexColor.a;
				
				return saturate(col);
				
			}
		ENDCG
	}
}

}