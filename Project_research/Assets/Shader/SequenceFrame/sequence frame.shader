Shader "XF/Eff/sequence frame"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		//_TexWidth("Tex Width",float) = 0.0
		//_CellAmount("Cell Amount",float) = 0.0
		//_Speed("Speed",Range(0.01,32)) = 0.0
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

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			//float _TexWidth;
			float _CellAmount, _Speed;
			float _timeValX, _timeValY;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				float2 spriteUV = v.uv;
				//float cellPixelWidth = _TexWidth / _CellAmount;
				//float cellUVPercentage = cellPixelWidth / _TexWidth;
				float cellUVPercentage = 1 / _CellAmount;
				//时间，输出0，1，2，...
				/*float timeVal = fmod(_Time.y* _Speed, _CellAmount);
				timeVal = ceil(timeVal);

				float timeValy = fmod(_Time.y* _Speed / 4, _CellAmount);
				timeValy = ceil(timeValy);*/

				float xValue = spriteUV.x;
				xValue += cellUVPercentage * _timeValX*_CellAmount;
				xValue *= cellUVPercentage;

				float yValue = spriteUV.y;
				yValue -= cellUVPercentage * _timeValY*_CellAmount;
				yValue *= cellUVPercentage;

				spriteUV = float2(xValue, yValue);
				//o.uv = spriteUV;
                o.uv = TRANSFORM_TEX(spriteUV, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
