Shader "PBR/legoPBR"
{
    Properties
    {
		//Basic
        _BasicColAndRoughnessTex ("Basic color & Roughness Texture", 2D) = "white" {}
		_InteriorColAndSpecularTex ("Interior color & Specular Texture", 2D) = "white" {}
		_Tint ("Tint", Color) = (1,1,1,1)
		
		//Specular		
		_SpecularRate ("Specular Rate", Range(1, 5)) = 1 
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		
		//Directional subsurface Scattering
		_FrontSssDistortion ("Front SSS Distortion", Range(0, 1)) = 0.5
		_BackSssDistortion ("Back SSS Distortion", Range(0, 1)) = 0.5
		_FrontSssIntensity ("Front SSS Intensity", Range(0, 1)) = 0.5
		_BackSssIntensity ("Back SSS Intensity", Range(0, 1)) = 0.5
		_InteriorColorPower ("Interior Color Power", Range(0, 1)) = 0.5
		
		//Light
		_UnlitRate ("Unlit Rate", Range(0, 1)) = 0.5
		_AmbientLight ("Ambient Light", Color) = (0.5,0.5,0.5,1)
		
		//fresnel
		_FresnelPower("Fresnel Power", Range(0, 36)) = 0.1
		_FresnelIntensity("Fresnel Intensity", Range(0, 1)) = 0.2
		
		
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
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _BasicColAndRoughnessTex;
            float4 _BasicColAndRoughnessTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BasicColAndRoughnessTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_BasicColAndRoughnessTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
