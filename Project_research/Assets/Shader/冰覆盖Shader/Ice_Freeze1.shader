// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'


/*
@xf
2019-7-5 
结冰shader，
1.根据噪音图以及Blend值控制结冰的区域，
2.在结冰位置的边缘以及菲涅尔反射的地方会更亮
3.结冰的地方顶点会凸起
4.使用自定义灯光方向

ps.如果使用顶点挤出请让美术建模的时候要注意统一法线方向，同一顶点的法线尽量统一，否则会破面
*/

Shader "Babybus/Ice/Ice_Freeze1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_FrozenNorm("FrozenNorm", 2D) = "white" {}
		_FrozenNorPow("Frozen Normal Power" , Range(0,2)) = 1//冰法线纹理强度
		
		_FrozenSqueeze("Frozen Squeeze" , Range(0,1)) = 0.15
		
		_LightColor("Light Color", Color) = (1,1,1,1)//灯光颜色
		_LightDir("Light Dir(xyz灯光方向w强度)" , vector) = (-1,1,1,1)//灯光方向&强度（W值控制灯光的强度）
		
		_FrozenGloss ("Frozen Gloss", Range(0, 1)) = 0.6//冰金属度
		_FrozenColor("Frozen Color(RGBA)", Color) = (0,0.5,1,0.2)//冰颜色
		_Fresnel("Fresnel", Range(0.2, 10)) = 3//菲涅尔
		
		_NoiseTex ("Noise Texture(R)", 2D) = "white" {}//噪音纹理
		_Blend("Blend" , Range(0,1)) = 1//冰冻效果混合度（1为完全冰冻）
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

			//顶点里进行纹理采样需要使用glsl，如果不需要顶点按照贴图强度膨胀，可以去掉以下两行
			#pragma glsl
			#pragma target 3.0
			
            #include "UnityCG.cginc"

            struct appdata
            {
                half4 vertex : POSITION;
                half2 uv : TEXCOORD0;
				half3 normal :NORMAL;
				half4 tangent : TANGENT; 
            };

            struct v2f
            {
                half4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                half4 vertex : SV_POSITION;
				half4 worldPos : TEXCOORD1;  
                half3 worldnormal : TEXCOORD2;  
                half3 worldtangent : TEXCOORD3; 
				half3 worldbitangent: TEXCOORD4; 
				
            };

            sampler2D _MainTex,_FrozenNorm,_NoiseTex;

            float4 _MainTex_ST,_FrozenNorm_ST;
			half _FrozenNorPow;
			fixed4  _LightColor,_FrozenColor;
			half4 _LightDir;
			half _FrozenGloss; 
			half _Fresnel;
			half _Blend;
			half _FrozenSqueeze;
            v2f vert (appdata v)
            {
                v2f o;

                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX (v.uv, _FrozenNorm); 
				
				//让顶点沿着法线方向挤压，噪音图影响挤压的力度;如不需要可以去掉以下两行
				fixed noise = tex2Dlod (_NoiseTex , float4(o.uv.zw ,0,0)).r;
				v.vertex.xyz += v.normal * saturate(noise-(1-_Blend)) * _FrozenSqueeze ;
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				
				o.worldnormal = normalize(UnityObjectToWorldNormal(v.normal));
				o.worldtangent = normalize(mul(unity_ObjectToWorld , float4(v.tangent.xyz, 0)).xyz);
                o.worldbitangent = normalize(cross(o.worldnormal, o.worldtangent) * v.tangent.w);
				
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
			
				float3x3 tangentTransform = float3x3( i.worldtangent, i.worldbitangent, i.worldnormal);//转换矩阵
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));//视线方向
				half3 worldLightDir = normalize(_LightDir.xyz); //灯光方向（面板上指定）
				half3 halfDir =normalize(worldLightDir + worldViewDir); //半角方向
				
                fixed4 col = tex2D(_MainTex, i.uv.xy);
				half noise = tex2D(_NoiseTex , i.uv.zw);//噪音图采样
				
				half3 norm = normalize(UnpackNormal(tex2D(_FrozenNorm, i.uv.zw)) * float3(_FrozenNorPow,_FrozenNorPow,1)); //法线采样
				half3 worldNormal = normalize(mul( norm, tangentTransform ));//把法线转换到世界空间
				
				//把_Blend的值从0~1映射到1.1~0
				half blend = (1 - _Blend)*1.1 ;

				//计算冰冻的范围
				half frozenSize = step(0, noise -blend);
				
				//把_FrozenGloss的值从0~1映射到2 ~ 2048
				half gloss = exp2(_FrozenGloss * 10 + 1);
				
				//计算高光
				half3 spec = _LightColor*pow(saturate(dot(worldNormal,halfDir)),gloss)*_LightDir.w;				
				fixed3 fresnel  = _FrozenColor * pow(1-saturate(dot(worldViewDir , worldNormal)) , _Fresnel) ;
				fixed3 blendEdge = _FrozenColor * pow(1-(noise -blend) , _Fresnel);
				
				fixed3 frozenCol = fresnel + spec +blendEdge;
				col.rgb +=frozenCol*frozenCol*2 *frozenSize;

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
	
}
