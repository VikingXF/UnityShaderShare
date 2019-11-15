
Shader "Babybus/Unlit/Transparent Grey" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Intensity ("Intensity", Range(0,2)) = 1
	
	_RimColor("RimColor",Color) = (0,0,0,1)
	_RimPower("RimPower",Range(0,5)) = 0.5
	_Degree("degree",float)=-1
	_Pow("pow",float)=30		
	_Brightness("brightness",float) =1
	
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				float rim : TEXCOORD1;
				float3 model : TEXCOORD2;

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Intensity;
			
			float3 _RimColor;
			fixed  _RimPower;
			float _Degree;
			float _Pow;
			float _Brightness;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				
				o.model = v.vertex;
				//菲利尔
				float3 Normal = UnityObjectToWorldNormal(v.normal);
				float3 viewDir = WorldSpaceViewDir(v.vertex);
				o.rim = 1.0 - saturate(dot(normalize(viewDir), normalize(Normal)));	
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				float gray = dot(col.rgb, float3(0.299, 0.587, 0.114));
				fixed4 Firstcol =col;
				Firstcol.rgb = float3(gray, gray, gray)*_Intensity;
				
				fixed4 Secondcol =col;
				Secondcol.rgb = col.rgb +_RimColor * pow (i.rim, _RimPower); 
				
				if(i.model.y < (1-_Degree))				
					return col = Firstcol+pow(saturate(i.model.y+_Degree),_Pow); 
				else
					return col =Secondcol;	
				

				return col;
			}
		ENDCG
	}
}

}
