Shader "Unlit/Ouline"
{
    Properties
    {

        _MainTex ("MainTex", 2D) = "white" {}
        _IlmTex ("IlmTex", 2D) = "white" {}

        [Space(10)]
        _MainColor("Main Color", Color) = (1,1,1)
	    _ShadowColor ("Shadow Color", Color) = (0.7, 0.7, 0.8)
	    _ShadowRange ("Shadow Range", Range(0, 1)) = 0.5
        _ShadowSmooth("Shadow Smooth", Range(0, 1)) = 0.2 

        [Space(20)]
		_SpecularColor("Specular Color", Color) = (1,1,1)
		_SpecularRange ("Specular Range",  Range(0, 1)) = 0.9
        _SpecularMulti ("Specular Multi", Range(0, 1)) = 0.4
		_SpecularGloss("Sprecular Gloss", Range(0.001, 80)) = 4

        [Space(10)]
        _RimColor("Rim Color", Color) = (1,1,1)
        _RimMin ("Rim Min",  Range(0, 1)) = 0.9
        _RimMax ("Rim Max",  Range(0, 1)) = 0.9
        _RimSmooth("Rim Smooth",  Range(0, 1)) = 0.9

        [Space(10)]
	    _OutlineWidth ("Outline Width", Range(0.01, 1)) = 0.24
        _OutLineColor ("OutLine Color", Color) = (0.5,0.5,0.5,1)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        pass
        {
           Tags {"LightMode"="ForwardBase"}
			 
            Cull Back
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"            
	        #include "Lighting.cginc"
            #include "AutoLight.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _IlmTex; 
			float4 _IlmTex_ST;

        
            half4 _MainColor;
            half4 _ShadowColor;
            half _ShadowRange;
            half _ShadowSmooth;

            half4 _SpecularColor;
			half _SpecularRange;
        	half _SpecularMulti;
			half _SpecularGloss;

            half4  _RimColor;
            half _RimMin;
            half _RimMax;
            half _RimSmooth;

            struct a2v 
	        {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
	        {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 WorldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            v2f vert(a2v v)
	        {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                o.WorldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag(v2f i) : SV_TARGET 
	        {
                half4 MainColor = tex2D(_MainTex,i.uv);
                half4 ilmColor = tex2D (_IlmTex, i.uv);

                
                half3 WorldNormal = normalize(i.WorldNormal);
                half3 WorldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                half3 halfLambert = dot(WorldNormal,WorldLightDir)*0.5f +0.5f;
                 half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                half ramp = smoothstep(0, _ShadowSmooth, halfLambert - _ShadowRange);
                //half ramp =  tex2D(_rampTex, float2(saturate(halfLambert - _ShadowRange), 0.5)).r; //使用Ramp贴图作为过渡，可以定义多个色阶

                half3 Diffuse = lerp(_ShadowColor, _MainColor, ramp);

                half Fresnel =  1.0 - saturate(dot(viewDir, WorldNormal));
                half rim = smoothstep(_RimMin, _RimMax, Fresnel);
                rim = smoothstep(0, _RimSmooth, rim);
                half3 rimColor = rim * _RimColor.rgb *  _RimColor.a;

                half4 col = MainColor;
                
                half3 specular = 0;
               
				half3 halfDir = normalize(WorldLightDir + viewDir);
				half NdotH = max(0, dot(WorldNormal, halfDir));
				half SpecularSize = pow(NdotH, _SpecularGloss);
				half specularMask = ilmColor.b;
				if (SpecularSize >= 1 - specularMask * _SpecularRange)
				{
					specular = _SpecularMulti * (ilmColor.r) * _SpecularColor;
				}
                
                specular = SpecularSize*_SpecularMulti* _SpecularColor;

                col.rgb = ((col.rgb * Diffuse)+specular) *_LightColor0 +rimColor;

                return col;
            }

            ENDHLSL
        }

        Pass
	{
	    Tags {"LightMode"="ForwardBase"}
			 
            Cull Front
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            half _OutlineWidth;
            half4 _OutLineColor;

            struct a2v 
	        {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 vertColor : COLOR;
                float4 tangent : TANGENT;
            };

            struct v2f
	        {
                float4 pos : SV_POSITION;
                float3 vertColor : TEXCOORD0;
            };


            v2f vert (a2v v) 
	        {
                v2f o;
		        UNITY_INITIALIZE_OUTPUT(v2f, o);
                //o.pos = UnityObjectToClipPos(float4(v.vertex.xyz + v.normal * _OutlineWidth * 0.1 ,1));//顶点沿着法线方向外扩
                float4 pos = UnityObjectToClipPos(v.vertex);
                //float3 viewNormal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal.xyz);
                float3 viewNormal = mul((float3x3)UNITY_MATRIX_IT_MV, v.tangent.xyz);
                float3 ndcNormal = normalize(TransformViewToProjection(viewNormal.xyz)) * pos.w;//将法线变换到NDC空间

                float4 nearUpperRight = mul(unity_CameraInvProjection, float4(1, 1, UNITY_NEAR_CLIP_VALUE, _ProjectionParams.y));//将近裁剪面右上角位置的顶点变换到观察空间
                float aspect = abs(nearUpperRight.y / nearUpperRight.x);//求得屏幕宽高比
                ndcNormal.x *= aspect;

                pos.xy += 0.1 * _OutlineWidth * ndcNormal.xy;
                o.pos =pos;
                o.vertColor = v.vertColor.rgb;
                return o;

            }

            half4 frag(v2f i) : SV_TARGET 
	        {
                float4 Color = _OutLineColor;
                Color.rgb *= i.vertColor;
                return Color;
            }
            ENDHLSL
        }
    }
}