Shader "Babybus/Particles/EffectCartoonFireGrow"
{
    Properties
    {
		_FireSpeed ("Fire Y Speed", Range(0, 5)) = 0		
        _MaskTex ("MaskTex", 2D) = "white" {}
		_NoiseTex ("NoiseTex", 2D) = "white" {}
		_Noisemultiplier ("Noise multiplier", Range(0, 20)) = 20
		
		_BlueSize ("Main B Size", Range(0, 4)) = 1
		_InnerStep ("Inner Step", Range(0, 3)) = 0
		_InnerVerticalFalloff ("Inner Vertical Falloff", Range(1, 5)) = 1
		 
		[HDR]_OuterColourBase ("Outer Colour Base", Color) = (1,0.7655172,0,1)
        [HDR]_InnerColourBase ("Inner Colour Base", Color) = (1,0.7655172,0,1)
		

		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4  //声明外部控制开关
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}   
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
				float4 vertexColor : COLOR;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 vertexColor : TEXCOORD2;
				float2 uv0 : TEXCOORD3;
				
            };

            sampler2D _MaskTex,_NoiseTex;
            float4 _MaskTex_ST,_NoiseTex_ST;
			
			float _FireSpeed,_BlueSize,_InnerVerticalFalloff,_InnerStep;
			float4 _OuterColourBase;
            float4 _InnerColourBase;
			float _Noisemultiplier;
			
            v2f vert (appdata v)
            {
                v2f o;
				o.vertexColor = v.vertexColor;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _NoiseTex)-fixed2(0, _Time.x*_FireSpeed);
				o.uv.zw = TRANSFORM_TEX(v.uv, _NoiseTex)-fixed2(0, _Time.x*_FireSpeed*0.5);
				o.uv0 = TRANSFORM_TEX(v.uv, _MaskTex)

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
				
				fixed Noise1 = tex2D(_NoiseTex, i.uv.xy).r;
				fixed Noise2 = tex2D(_NoiseTex, i.uv.xy).r;
				fixed Noisecol = (Noise1+Noise2);
				
                fixed4 Maskcol = tex2D(_MaskTex, i.uv0);
				float uvY=1-i.uv0.y;
                float Mask = (Maskcol.r *Noisecol*_Noisemultiplier*i.vertexColor.a)*Maskcol.g*uvY*uvY+(_BlueSize*Maskcol.b);
				clip(saturate(step(saturate((0.5+i.uv0.y)),Mask)) - 0.5);
				
				Mask *=pow((Maskcol.g*uvY),_InnerVerticalFalloff);
				
                Mask = step(_InnerStep,Mask);

				fixed3 col = lerp(_OuterColourBase,_InnerColourBase,Mask);
				
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(col,1);
            }
            ENDCG
        }
		
		Pass {
			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
				Blend SrcAlpha One
				Cull Off Lighting Off ZWrite Off
				ZTest [_ZTest] //获取值应用
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

           

            struct appdata_t {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;  
				UNITY_VERTEX_INPUT_INSTANCE_ID				
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
				UNITY_VERTEX_OUTPUT_STEREO
            };
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
            fixed4 _TintColor;
           

            v2f vert (appdata_t v)
            {
                v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);				
                o.color = v.color;
                o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
         


            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = 2.0f * i.color * _TintColor * tex2D(_MainTex, i.texcoord);
                col.a = saturate(col.a); 

                UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0)); // fog towards black due to our blend mode
                return col;
            }
            ENDCG
        }
    }
}
