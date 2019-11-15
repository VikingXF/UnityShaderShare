Shader "Unlit/VSection5"
{
	Properties
	{
		_MainColor1 ("Color1", color) = (1, 1, 1, 1)
		_MainColor2 ("Color2", color) = (1, 1, 1, 1)
		_MainColor3 ("Color3", color) = (1, 1, 1, 1)
		_MainColor4 ("Color4", color) = (1, 1, 1, 1)
		_MainColor5 ("Color5", color) = (1, 1, 1, 1)
		_Cut ("CutHeight", Range(-0.5, 1)) = 0
		_MeshHeight("MeshHeight", float) = 0.2
		_MatCap("Ramp Texture", 2D) = "white" {}
		
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
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal :NORMAL;
				float2 cap    : TEXCOORD1;
			};

			struct v2f
			{			
				float3 normal :NORMAL;
				float4 vertex : SV_POSITION;
				float4 color : TEXCOORD0;
				float2 cap    : TEXCOORD1;
			};

			float4 _MainColor1;
			float4 _MainColor2;
			float4 _MainColor3,_MainColor4,_MainColor5;
			sampler2D _MatCap;
			float _Cut;
			fixed _MeshHeight;
			v2f vert (appdata v)
			{
			v2f o;	
			
			if(v.vertex.y>0 && v.vertex.y<_MeshHeight/5)
			o.color = _MainColor1;
			if(v.vertex.y>_MeshHeight/5 && v.vertex.y<_MeshHeight*2/5)
			o.color = _MainColor2;
			if(v.vertex.y>_MeshHeight*2/5 && v.vertex.y<_MeshHeight*3/5)
			o.color = _MainColor3;
			if(v.vertex.y>_MeshHeight*3/5 && v.vertex.y<_MeshHeight*4/5)
			o.color = _MainColor4;
			if(v.vertex.y>_MeshHeight*4/5 && v.vertex.y<_MeshHeight)
			o.color = _MainColor5;	
			
			if(v.vertex.y > _Cut )
			{
				v.vertex.y = _Cut;								
			}			
					
			o.vertex = UnityObjectToClipPos(v.vertex);
			//float4 worldCut = mul(unity_ObjectToWorld, float4(0, _Cut, 0, 0.5));														
			half2 capCoord;
            capCoord.x = dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal);
            capCoord.y = dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal);
            o.cap = capCoord * 0.5 + 0.5;
			return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{		
				fixed4 mc = tex2D(_MatCap, i.cap);			
				return (i.color+(mc*1.2)-1.0);
			}
			ENDCG
		}
	}
}
