Shader "Babybus/Curved/Curved_Surf_Rim"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_QOffset ("Offset", Vector) = (0,0,0,0)
		_Color ("Main Color", Color) = (1,1,1,1)
		_Brightness ("Brightness", Float) = 0.0
		_Dist ("Distance", Float) = 100.0
		_FogColor("FogColor", Color) = (0.87,0.87,0.87,1)
		_FogDensity("FogDensity", Float) = 0.1
		_FogRange("FogRange", Float) = 300
		_Cut("Cut", range(0,1)) = 0

		_RimColor("Rim Color", Color) = (0.26,0.19,0.16,0.0)
		_RimPower("Rim Power", Range(0.5,8.0)) = 3.0
    }
    SubShader {
		Tags { "IgnoreProjector" = "True"
			   "Queue" = "Transparent"
			   "RenderType" = "Transparent" }
		blend srcalpha oneminussrcalpha
		
		Cull off

		zwrite on

		CGPROGRAM
		 
		#pragma surface surf Lambert vertex:vert alphatest:_Cut
		
		struct Input 
		{
			 float2 uv_MainTex;

			 float3 viewDir;
		};
      
		sampler2D _MainTex;
		float4 _QOffset;
		float _Dist;
		float _Insensitive;
		float _Brightness;
		float4 _Color;
		float4 _RimColor;
		float _RimPower;
		
		void vert (inout appdata_full v) 
		{
          
			float4 vPos = mul (UNITY_MATRIX_MV, v.vertex);
					    
			float xsmeh=sin(_WorldSpaceCameraPos.z/120);
	 			    
			float zOff = vPos.z/_Dist;

			vPos += _QOffset*zOff*zOff;
	        
			v.vertex = mul(transpose(UNITY_MATRIX_IT_MV), vPos);
			#if SHADER_API_GLES
	    		v.vertex.xyz*= 1.0;
			#endif
		}
      
		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * _Brightness * _Color;
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
			float alpha = tex2D (_MainTex, IN.uv_MainTex).a;
			o.Alpha = alpha;  
		}

		ENDCG
        
    }
	Fallback "Diffuse"
}
