
Shader "Unlit/Caustic_projector"
{
    Properties
    {
        _Mafloatex("cautics texture", 2D) = "caustic" {}
		_Causticfloatensity("caustics strength", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags {"RenderType"="Opaque"  "LightMode"="ForwardBase"}
        LOD 100

        Pass
        {
			Blend DstColor one
			//Blend one OneMinusSrcAlpha
			//Blend one one
			offset -1, -1
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float2 texcoord:TEXCOORD0;
				float4 normal : NORMAL;
            };

            struct v2f
            {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			half  floatensity : TEXCOORD2;
            UNITY_FOG_COORDS(1)

            };

            sampler2D _Mafloatex;
			float4 _Mafloatex_ST;
			float _Causticfloatensity;
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;

            v2f vert (appdata v)
            {
                v2f o;
				//calculate uv
				o.pos = mul(unity_Projector, v.vertex);
				o.uv = float2(o.pos.x/o.pos.w, o.pos.y/o.pos.w);//ignore z
				o.uv = TRANSFORM_TEX(o.uv, _Mafloatex);
				
				//
				float3 lightDir = ObjSpaceLightDir(v.vertex);
				o.floatensity = dot(normalize(v.normal), normalize(lightDir));
				o.floatensity *= (1-mul(unity_ProjectorClip, v.vertex).x)*5;
				
				//
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
            }
			
			float imod(float x, float f)
			{
				return x-x/f*f;
			}
			
            fixed4 frag (v2f i) : SV_Target
            {
                half4 result = float4(1.0, 1.0, 1.0, 1.0);
				float frameCount = imod((float)(_Time.w*10), 48);
				float mask = frameCount / 16;
				float row =  imod(frameCount, 16) / 4 ;
				float col =  imod(imod(frameCount, 16), 4);				
				float2 aniUV = float2(0.25*(col), 0.25*(row));
				aniUV = frac(i.uv)*float2(0.25, 0.25)+aniUV;
				float4 causticCol = tex2D(_Mafloatex, aniUV);
				float causticfloatensity = 1.0;
				if(mask == 0)
				{
					causticfloatensity = causticCol.b;
				}
				else if(mask == 1)
				{
					causticfloatensity = causticCol.g;
				}
				else if(mask == 2)
				{
					causticfloatensity = causticCol.b;
				}
				causticfloatensity=i.floatensity*causticfloatensity*_Causticfloatensity;
				return saturate(result*causticfloatensity);

				

				/*float2 aniUV = float2(0, 0);
				aniUV = frac(i.uv)*float2(0.25, 0.25) ;
				float4 causticCol = tex2D(_Mafloatex, aniUV);				
				float causticfloatensity = causticCol.b;

				causticfloatensity = causticfloatensity*_Causticfloatensity;
				return saturate(causticfloatensity);*/

            }
            ENDCG
        }
    }
}
