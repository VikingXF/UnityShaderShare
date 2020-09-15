Shader "Babybus/Special/change clothing"
{
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_DecorativeTex1 ("花纹1", 2D) = "white" {}
	_DecorativeTex2 ("花纹2", 2D) = "white" {}
	
	_Transitions("Transitions", Range(0, 1)) = 0
	[KeywordEnum(X,Y)]_TransFormPoint("Fill Origin" , Float) = 0
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite On
	Blend SrcAlpha OneMinusSrcAlpha 
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#pragma shader_feature _TRANSFORMPOINT_X _TRANSFORMPOINT_Y
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half4 texcoord : TEXCOORD0;
				half4 texcoord2: TEXCOORD1;
				UNITY_FOG_COORDS(2)
			};

			sampler2D _MainTex,_DecorativeTex1,_DecorativeTex2;
			float4 _MainTex_ST,_DecorativeTex1_ST,_DecorativeTex2_ST;
			fixed _Transitions,_length;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord.zw =v.texcoord2;
				o.texcoord2.xy = TRANSFORM_TEX(v.texcoord2, _DecorativeTex1);
				o.texcoord2.zw = TRANSFORM_TEX(v.texcoord2, _DecorativeTex2);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord.xy);
				fixed4 Decorativecol1 = tex2D(_DecorativeTex1, i.texcoord2.xy);
				fixed4 Decorativecol2 = tex2D(_DecorativeTex2, i.texcoord2.zw);
				
				#if _TRANSFORMPOINT_X
				float _BlendRange = saturate(1-(i.texcoord.z -_Transitions)*100);
		
				#elif _TRANSFORMPOINT_Y 
				float _BlendRange = saturate(1-(i.texcoord.w -_Transitions)*100);
				
				#endif
				col.a *= (1-_BlendRange);
				
				col = lerp(lerp(col,Decorativecol1,Decorativecol1.a),Decorativecol2,Decorativecol2.a);
				
				
				
				UNITY_APPLY_FOG(i.fogCoord, col);
				//UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
		ENDCG
	}
}

}
