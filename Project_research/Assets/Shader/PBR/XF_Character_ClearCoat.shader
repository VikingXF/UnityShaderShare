Shader "XF/TT_Character/ClearCoat"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "PerformanceChecks" = "False"}
        LOD 100
		CGINCLUDE

		ENDCG
        Pass
        {
			
            
        }
    }
	FallBack "VertexLit"
}
