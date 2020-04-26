
Shader "Babybus/Cartoon/CartoonVF_Makeup2"
{
    Properties
    {
        _MainTex ("贴图", 2D) = "white" {}

		//TOONY COLORS
		[LightDir]_LightDir("Light Dir" , Vector) = (0,0,-1,0)		
		_Color("Color", Color) = (1.0,1.0,1.0,1.0)
		_HColor("Highlight Color", Color) = (0.6,0.6,0.6,1.0)
		_SColor("Shadow Color", Color) = (0.2,0.2,0.2,1.0)

		//TOONY COLORS RAMP
		_RampThreshold("Ramp Threshold", Range(0,1)) = 0.5
		_RampSmooth("Ramp Smoothing", Range(0.01,1)) = 0.1
		
		//Rim
		_RimColor("RimColor", Color) = (1,1,1,1)  
		_RimPower("RimPower", Range(0, 10)) = 0.1  
		_RimIntensity("RimIntensity", Range(0, 3.0)) = 0.1  
		
		
    }
    SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			// make fog work
			//#pragma multi_compile_fog

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;

				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;		
				float3 worldNormal: TEXCOORD2;
				float3 WorldLightDir: TEXCOORD3;
				//001 Rim在ver中计算===========================
				float fresnel : TEXCOORD4;
				//001===========================
				//float3 WorldViewDir: TEXCOORD4;
			};
			
			//================================================================================================================================
			// 基础卡通光照模型
			//--------------------------------------------------------------------------------------------------------------------------------

			fixed4 _HColor;
			fixed4 _Color;
			fixed4 _SColor;
			float _RampThreshold;
			float _RampSmooth;
			half4 _LightDir;
			inline half4 LightingToonyColors(fixed4 c,fixed3 worldNormal, fixed3 lightDir)
			{
				fixed ndl = max(0, dot(worldNormal, lightDir)*0.5 + 0.5);
				fixed3 ramp = smoothstep(_RampThreshold - _RampSmooth * 0.5, _RampThreshold + _RampSmooth * 0.5, ndl);
				_SColor = lerp(_HColor, _SColor, _SColor.a);	//Shadows intensity through alpha
				ramp = lerp(_SColor.rgb, _HColor.rgb, ramp);
				c.rgb =c.rgb  * ramp*_Color;
				c.a = c.a*_Color.a;
				return c;
			}
			//--------------------------------------------------------------------------------------------------------------------------------
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _SpotsAmount;
			fixed4 _RimColor;  
			float _RimPower,_RimIntensity; 
				
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				//o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);		
				o.worldNormal =	UnityObjectToWorldNormal(v.normal);			
				//o.WorldLightDir = WorldSpaceLightDir(v.vertex);				
				o.WorldLightDir =-_LightDir.xyz;	
				
				//001 Rim在ver中计算===========================
				float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
				float3  viewnormal = normalize(v.normal);
				o.fresnel = _RimColor.rgb*pow((1 -dot(viewDir,viewnormal)),_RimPower) *_RimIntensity* _RimColor.a;  				
				//001===========================
				
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = tex2D(_MainTex, i.uv);
		
				//halfLight
				col = LightingToonyColors(col,i.worldNormal,i.WorldLightDir);
				
				//Rim	
				//001 Rim在ver中计算===========================				
				col.rgb += i.fresnel;									
				//001================================================
				
				
				
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
