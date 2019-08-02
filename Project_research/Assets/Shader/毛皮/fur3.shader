Shader "Unlit/fur3"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SubTex ("SubTex", 2D) = "white" {}		
		FUR_OFFSET("FUR_OFFSET",float) = 0.1
		_UVoffset("UV偏移：XY=UV偏移;ZW=UV扰动", Vector) = (0, 0, 0.2, 0.2)
		_SubTexUV("SubTex的UV", Vector) = (0, 0, 0.2, 0.2)
		_Color("Color",COLOR) = (0, 0, 0, 0)
		_BaseColor("BaseColor",COLOR) = (0, 0, 0, 00)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		ZTest Off
		//Cull Off
		//ZWrite Off		
		
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0);

				float3 n = aNormal * 0 * (0 * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * 0;

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,0) ;

				color.a = saturate(Noise-0) ;

				return color;
			}
			ENDCG
		}
		
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.05*FUR_OFFSET);

				float3 n = aNormal * (0.05*FUR_OFFSET) * ((0.05*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * 0.05;

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.05*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.05*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.1*FUR_OFFSET);

				float3 n = aNormal * (0.1*FUR_OFFSET) * ((0.1*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.1*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.1*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.1*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.15*FUR_OFFSET);

				float3 n = aNormal * (0.15*FUR_OFFSET) * ((0.15*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.15*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.15*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.15*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.2*FUR_OFFSET);

				float3 n = aNormal * (0.2*FUR_OFFSET) * ((0.2*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.2*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.2*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.2*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.25*FUR_OFFSET);

				float3 n = aNormal * (0.25*FUR_OFFSET) * ((0.25*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.25*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.25*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.25*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.3*FUR_OFFSET);

				float3 n = aNormal * (0.3*FUR_OFFSET) * ((0.3*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.3*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.3*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.3*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.35*FUR_OFFSET);

				float3 n = aNormal * (0.35*FUR_OFFSET) * ((0.35*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.35*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.35*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.35*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.4*FUR_OFFSET);

				float3 n = aNormal * (0.4*FUR_OFFSET) * ((0.4*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.4*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.4*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.4*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.45*FUR_OFFSET);

				float3 n = aNormal * (0.45*FUR_OFFSET) * ((0.45*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.45*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.45*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.45*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.5*FUR_OFFSET);

				float3 n = aNormal * (0.5*FUR_OFFSET) * ((0.5*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.5*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.5*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.5*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.55*FUR_OFFSET);

				float3 n = aNormal * (0.55*FUR_OFFSET) * ((0.55*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.55*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.55*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.55*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.65*FUR_OFFSET);

				float3 n = aNormal * (0.65*FUR_OFFSET) * ((0.65*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.65*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.65*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.65*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.7*FUR_OFFSET);

				float3 n = aNormal * (0.7*FUR_OFFSET) * ((0.7*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.7*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.7*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.7*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.75*FUR_OFFSET);

				float3 n = aNormal * (0.75*FUR_OFFSET) * ((0.75*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.75*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.75*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.75*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.8*FUR_OFFSET);

				float3 n = aNormal * (0.8*FUR_OFFSET) * ((0.8*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.8*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.8*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.8*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.85*FUR_OFFSET);

				float3 n = aNormal * (0.85*FUR_OFFSET) * ((0.85*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.85*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.85*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.85*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.9*FUR_OFFSET);

				float3 n = aNormal * (0.9*FUR_OFFSET) * ((0.9*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.9*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.9*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.9*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (0.95*FUR_OFFSET);

				float3 n = aNormal * (0.95*FUR_OFFSET) * ((0.95*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (0.95*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(0.95*FUR_OFFSET)) ;

				color.a = saturate(Noise-(0.95*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex,_SubTex;
			float4 _MainTex_ST;
			float FUR_OFFSET;
			float4 _UVoffset;
			float4 _SubTexUV;
			float4 _Color,_BaseColor;
			v2f vert (appdata v)
			{
				v2f o;
				float3 aNormal = (v.normal.xyz);

				aNormal.xyz += (1*FUR_OFFSET);

				float3 n = aNormal * (1*FUR_OFFSET) * ((1*FUR_OFFSET) * saturate(v.color.a));
				v.vertex.xyz += n;

				float2 uvoffset= _UVoffset.xy  * (1*FUR_OFFSET);

				uvoffset *=  0.1 ; //尺寸太大不好调整 缩小精度。

				float2 uv1= TRANSFORM_TEX(v.uv.xy, _MainTex ) + uvoffset * (float2(1,1)/_SubTexUV.xy);

				float2 uv2= TRANSFORM_TEX(v.uv.xy, _MainTex )*_SubTexUV.xy   + uvoffset;

				o.uv = float4(uv1,uv2);

				o.vertex = UnityObjectToClipPos(v.vertex);

				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half3 NoiseTex = tex2D(_SubTex, i.uv.zw).rgb;

				half Noise = NoiseTex.r;
				fixed4 color =_Color;
				color.rgb = lerp(_Color.rgb,_BaseColor.rgb,(1*FUR_OFFSET)) ;

				color.a = saturate(Noise-(1*FUR_OFFSET)) ;

				return color;
			}
			ENDCG
		}
	}
}
