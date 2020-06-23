Shader "Babybus/Special/GoRound"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(-1,1)) = 0.5
    }
    SubShader
    {
        Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 100
		ZWrite Off
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				 float2 ddc : TEXCOORD1;
            };
						
            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed _Cutoff;
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.ddc = v.vertex.xy;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				
				float2 uv_center = i.uv*2.0-1;	
				float2 uv_dir = distance(uv_center,fixed2(0,0)); 

				//col.rgb = fixed3(uv_dir.x,uv_dir.x,uv_dir.x);
				
				clip((col.a-uv_dir-_Cutoff));
				
                return col;
            }
            ENDCG
        }
    }
}
