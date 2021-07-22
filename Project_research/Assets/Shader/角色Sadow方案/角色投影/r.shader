Shader "Unlit/r"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ShadowCol("Shadow Color" , Color) = (0,0,0,0)//阴影颜色
        _RimColor("RimColor", Color) = (1,1,1,1)  
		_RimPower("RimPower", Range(0, 10.0)) = 0.1  
		_RimIntensity("RimIntensity", Range(0, 3.0)) = 0.1 
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	    LOD 100
	
	    ZWrite Off
	    Blend SrcAlpha OneMinusSrcAlpha 
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 color : COLOR;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _RimColor;  
		    fixed _RimPower,_RimIntensity;
            fixed4 _ShadowCol;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
				//float3 viewDir = float3(v.vertex.y,v.vertex.y,v.vertex.y);
				float3  viewnormal = normalize(v.normal);
				float Rim=1 -dot(viewDir,viewnormal);				
				Rim = saturate(1-pow(Rim,_RimPower) *_RimIntensity);  

                o.color = _ShadowCol; 
				o.color.a = Rim;
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = i.color.a;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
