Shader "Unlit/ReceiverShadow"
{
    Properties
    {
		_Color ("Main Color", Color) = (1,0,1,0.5)   	
		_ShadowTex ("Cookie", 2D) = "gray" {}
		_ClipScale ("Near Clip Scale", Float) = 100
		_Alpha ("Shadow Darkness", Range (0, 1)) = 1.0
		_Offset("Offset", Range(-1, -10)) = -1.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent-1" }
        LOD 100
		ZWrite Off
		//ColorMask RGB
		Blend SrcAlpha OneMinusSrcAlpha
		Offset -1,[_Offset]
		
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
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 pos : SV_POSITION;
				float alpha : TEXCOORD2;
            };

            sampler2D _ShadowTex;
            float4 _ShadowTex_ST;
			float _ClipScale, _Alpha;
			float4 _Color;

			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;

			float4 ProjectVertex(float4 v)
			{
				float4 p = mul(unity_Projector, v);
				p.z = mul(unity_ProjectorClip, v).x;
				return p;
			}

            v2f vert (appdata v)
            {
                v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = ProjectVertex(v.vertex);
				o.alpha = _ClipScale * o.uv.z;
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
			
            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col = tex2Dproj(_ShadowTex, UNITY_PROJ_COORD(i.uv));
				col = lerp(_Color, fixed4(0, 0, 0, 1), saturate(i.alpha)*_Alpha*(1.0f - col));				
				UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
