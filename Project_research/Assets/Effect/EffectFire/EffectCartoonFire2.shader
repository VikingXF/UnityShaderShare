Shader "Unlit/EffectCartoonFire2"
{
    Properties
    {	
	    _FireUSpeed ("Fire Y Speed", Range(-5, 5)) = 0
		_FireVSpeed ("Fire X Speed", Range(-5, 5)) = 0			
        _MaskTex ("Texture", 2D) = "white" {}
		_NoiseTex ("NoiseTex", 2D) = "white" {}
		_Noisemultiplier ("Noise multiplier", Range(0, 20)) = 20
		
		[HDR]_OuterColourBase ("Outer Colour Base", Color) = (1,0.7655172,0,1)
        [HDR]_InnerColourBase ("Inner Colour Base", Color) = (1,0.7655172,0,1)
		
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4  //声明外部控制开关
    }
    SubShader
    {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 200

        Pass
        {
			ZWrite On
            Cull Off
            ZTest [_ZTest] //获取值应用
			
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
                float4 vertex : SV_POSITION;
				
            };

            sampler2D _MaskTex,_NoiseTex;
            float4 _MaskTex_ST,_NoiseTex_ST;
			float _FireUSpeed,_FireVSpeed;
			float4 _OuterColourBase;
            float4 _InnerColourBase;
			float _Noisemultiplier;
			
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _NoiseTex)+fixed2(_Time.x*_FireUSpeed, _Time.x*_FireVSpeed);
				o.uv.zw = TRANSFORM_TEX(v.uv, _MaskTex);
				
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               
                fixed4 Noisecol = tex2D(_NoiseTex, i.uv.xy);				
				
				float Mask = Noisecol.r*_Noisemultiplier*(i.uv.w) +i.uv.w;
				
				float4 Maskcol = tex2D(_MaskTex, fixed2(i.uv.z,Mask));
				clip(Maskcol.r - 0.9);
				float4 col  = _OuterColourBase*Maskcol.r+Maskcol.g*_InnerColourBase;
				//float4 col= float4(1,Mask,1,1);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
