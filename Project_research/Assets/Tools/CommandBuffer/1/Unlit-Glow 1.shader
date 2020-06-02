Shader "MK/Glow/Selective/Legacy/Unlit/Unlit-Glow 1"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MKGlowColor ("Glow Color", Color) = (1,1,1,1)
		_MKGlowPower ("Glow Power", Range(0.0,2.5)) = 1.0
		
		_MKGlowTex ("Glow Texture", 2D) = "white" {}
		//_MKGlowTexColor ("Glow Texture Color", Color) = (1,1,1,1)
		_MKGlowTexStrength ("Glow Texture Strength ", Range(0.0,10.0)) = 1.0
    }
    SubShader
    {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="MKGlowLegacy"}
  	    LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
               // float2 uv : TEXCOORD1;
				float2 uv_MKGlowTex : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            //sampler2D _MainTex;
            //float4 _MainTex_ST;
			fixed4 _Color;

			sampler2D _MKGlowTex;
			float4 _MKGlowTex_ST;
			//fixed4 _MKGlowTexColor;
			half _MKGlowTexStrength;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv_MKGlowTex = TRANSFORM_TEX(v.uv, _MKGlowTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                //fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col = _Color;
				fixed4 MKGlowcol = tex2D(_MKGlowTex, i.uv_MKGlowTex);
				col.rgb *= (MKGlowcol.rgb * _MKGlowTexStrength);
				col.a = MKGlowcol.r;
                return col;
            }
            ENDCG
        }
		
		
    }
}
