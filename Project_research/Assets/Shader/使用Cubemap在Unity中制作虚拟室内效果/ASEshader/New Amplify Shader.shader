// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Templates/Unlit"
{
	Properties
	{
		_Texture0("Texture 0", CUBE) = "white" {}
		_Center("Center", Vector) = (0,-10,0,0)
		_Center_Center("Center_Center", Vector) = (0,-5,0,0)
		_Front("Front", Vector) = (0,0,-5,0)
		_Front_Center("Front_Center", Vector) = (0,-5,0,0)
		_Back("Back", Vector) = (0,0,5,0)
		_Back_Center("Back_Center", Vector) = (0,-5,0,0)
		_Left("Left", Vector) = (-5,0,0,0)
		_Left_Center("Left_Center", Vector) = (0,-5,0,0)
		_Right("Right", Vector) = (5,0,0,0)
		_Right_Center("Right_Center", Vector) = (0,-5,0,0)
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			uniform samplerCUBE _Texture0;
			uniform float3 _Left;
			uniform float3 _Left_Center;
			uniform float3 _Right;
			uniform float3 _Right_Center;
			uniform float3 _Center;
			uniform float3 _Center_Center;
			uniform float3 _Back;
			uniform float3 _Back_Center;
			uniform float3 _Front;
			uniform float3 _Front_Center;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float4 transform86 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
				float4 WorldPos92 = transform86;
				float3 temp_output_3_0_g24 = WorldPos92.xyz;
				float3 temp_output_4_0_g24 = float3(1,0,0);
				float dotResult7_g24 = dot( ( _Left - temp_output_3_0_g24 ) , temp_output_4_0_g24 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float4 transform88 = mul(unity_WorldToObject,float4( ase_worldViewDir , 0.0 ));
				float4 ViewDir93 = transform88;
				float3 temp_output_5_0_g24 = ViewDir93.xyz;
				float dotResult8_g24 = dot( temp_output_5_0_g24 , temp_output_4_0_g24 );
				float3 normalizeResult10_g24 = normalize( temp_output_5_0_g24 );
				float3 temp_output_6_0 = ( ( temp_output_3_0_g24 + ( ( dotResult7_g24 / dotResult8_g24 ) * normalizeResult10_g24 ) ) - _Left_Center );
				float3 break15 = floor( abs( ( temp_output_6_0 / 5.0 ) ) );
				float4 transform100 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
				float4 myVarName104 = transform100;
				float3 temp_output_3_0_g21 = myVarName104.xyz;
				float3 temp_output_4_0_g21 = float3(1,0,0);
				float dotResult7_g21 = dot( ( _Right - temp_output_3_0_g21 ) , temp_output_4_0_g21 );
				float4 transform99 = mul(unity_WorldToObject,float4( ase_worldViewDir , 0.0 ));
				float4 myVarName102 = transform99;
				float3 temp_output_5_0_g21 = myVarName102.xyz;
				float dotResult8_g21 = dot( temp_output_5_0_g21 , temp_output_4_0_g21 );
				float3 normalizeResult10_g21 = normalize( temp_output_5_0_g21 );
				float3 temp_output_107_0 = ( ( temp_output_3_0_g21 + ( ( dotResult7_g21 / dotResult8_g21 ) * normalizeResult10_g21 ) ) - _Right_Center );
				float3 break112 = floor( abs( ( temp_output_107_0 / 5.0 ) ) );
				float4 transform129 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
				float4 myVarName132 = transform129;
				float3 temp_output_3_0_g23 = myVarName132.xyz;
				float3 temp_output_4_0_g23 = float3(0,1,0);
				float dotResult7_g23 = dot( ( _Center - temp_output_3_0_g23 ) , temp_output_4_0_g23 );
				float4 transform130 = mul(unity_WorldToObject,float4( ase_worldViewDir , 0.0 ));
				float4 myVarName128 = transform130;
				float3 temp_output_5_0_g23 = myVarName128.xyz;
				float dotResult8_g23 = dot( temp_output_5_0_g23 , temp_output_4_0_g23 );
				float3 normalizeResult10_g23 = normalize( temp_output_5_0_g23 );
				float3 temp_output_125_0 = ( ( temp_output_3_0_g23 + ( ( dotResult7_g23 / dotResult8_g23 ) * normalizeResult10_g23 ) ) - _Center_Center );
				float3 break120 = floor( abs( ( temp_output_125_0 / 5.0 ) ) );
				float4 transform149 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
				float4 myVarName152 = transform149;
				float3 temp_output_3_0_g20 = myVarName152.xyz;
				float3 temp_output_4_0_g20 = float3(0,0,1);
				float dotResult7_g20 = dot( ( _Back - temp_output_3_0_g20 ) , temp_output_4_0_g20 );
				float4 transform150 = mul(unity_WorldToObject,float4( ase_worldViewDir , 0.0 ));
				float4 myVarName148 = transform150;
				float3 temp_output_5_0_g20 = myVarName148.xyz;
				float dotResult8_g20 = dot( temp_output_5_0_g20 , temp_output_4_0_g20 );
				float3 normalizeResult10_g20 = normalize( temp_output_5_0_g20 );
				float3 temp_output_145_0 = ( ( temp_output_3_0_g20 + ( ( dotResult7_g20 / dotResult8_g20 ) * normalizeResult10_g20 ) ) - _Back_Center );
				float3 break140 = floor( abs( ( temp_output_145_0 / 5.0 ) ) );
				float4 transform169 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
				float4 myVarName172 = transform169;
				float3 temp_output_3_0_g22 = myVarName172.xyz;
				float3 temp_output_4_0_g22 = float3(0,0,1);
				float dotResult7_g22 = dot( ( _Front - temp_output_3_0_g22 ) , temp_output_4_0_g22 );
				float4 transform170 = mul(unity_WorldToObject,float4( ase_worldViewDir , 0.0 ));
				float4 myVarName168 = transform170;
				float3 temp_output_5_0_g22 = myVarName168.xyz;
				float dotResult8_g22 = dot( temp_output_5_0_g22 , temp_output_4_0_g22 );
				float3 normalizeResult10_g22 = normalize( temp_output_5_0_g22 );
				float3 temp_output_165_0 = ( ( temp_output_3_0_g22 + ( ( dotResult7_g22 / dotResult8_g22 ) * normalizeResult10_g22 ) ) - _Front_Center );
				float3 break160 = floor( abs( ( temp_output_165_0 / 5.0 ) ) );
				
				
				finalColor = texCUBE( _Texture0, ( ( temp_output_6_0 * ( 1.0 - saturate( max( break15.y , break15.z ) ) ) ) + ( temp_output_107_0 * ( 1.0 - saturate( max( break112.y , break112.z ) ) ) ) + ( temp_output_125_0 * ( 1.0 - saturate( max( break120.x , break120.z ) ) ) ) + ( temp_output_145_0 * ( 1.0 - saturate( max( break140.x , break140.y ) ) ) ) + ( temp_output_165_0 * ( 1.0 - saturate( max( break160.x , break160.y ) ) ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	

	
}
/*ASEBEGIN
Version=16200
1927;1;1906;1010;4220.715;2364.708;1.247089;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-3783.228,-1930.422;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;171;-3745.152,1168.104;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;154;-3751.536,586.4308;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;97;-3776.708,-989.8893;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;134;-3761.952,-191.3132;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;98;-3782.236,-1143.89;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;151;-3757.064,432.4303;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;3;-3774.228,-1776.421;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;131;-3767.48,-345.3137;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;174;-3739.624,1322.104;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectTransfNode;170;-3446.694,1240.263;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;150;-3458.606,504.5892;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;86;-3459.532,-2231.229;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;99;-3483.778,-1071.731;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;100;-3484.878,-1231.932;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;129;-3470.122,-433.3557;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;169;-3447.794,1080.062;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;130;-3469.022,-273.1548;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;88;-3446.138,-2016.803;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;149;-3459.706,344.3883;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;103;-3772.18,-662.8893;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;156;-3747.008,913.431;Float;False;Constant;_Vector8;Vector 8;0;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;168;-3191.893,1235.562;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;-3203.805,499.8883;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;135;-3760.424,-32.31317;Float;False;Property;_Center;Center;1;0;Create;True;0;0;False;0;0,-10,0;0,-10,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;-3193.993,1076.162;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-3228.977,-1076.432;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;176;-3735.096,1649.105;Float;False;Constant;_Vector11;Vector 11;0;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;101;-3774.18,-831.8893;Float;False;Property;_Right;Right;9;0;Create;True;0;0;False;0;5,0,0;5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-3231.077,-1235.832;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-3214.221,-277.8557;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-3216.321,-437.2559;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;136;-3757.424,135.6869;Float;False;Constant;_Vector5;Vector 5;0;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;175;-3737.096,1480.104;Float;False;Property;_Front;Front;3;0;Create;True;0;0;False;0;0,0,-5;0,0,-5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-3233.504,-2003.046;Float;False;ViewDir;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;-3205.905,340.4882;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;155;-3749.008,744.4308;Float;False;Property;_Back;Back;5;0;Create;True;0;0;False;0;0,0,5;0,0,5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-3212.509,-2149.882;Float;False;WorldPos;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;4;-3775.172,-1621.893;Float;False;Property;_Left;Left;7;0;Create;True;0;0;False;0;-5,0,0;-5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;5;-3773.172,-1449.421;Float;False;Constant;_N;N;0;0;Create;True;0;0;False;0;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;178;-2888.016,-1025.304;Float;False;Line_face_intersection;-1;;21;ff94a0fec9691d340a7dff1a617393db;0;4;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;179;-2889.009,-1811.836;Float;False;Line_face_intersection;-1;;24;ff94a0fec9691d340a7dff1a617393db;0;4;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;7;-2808.207,-1647.754;Float;False;Property;_Left_Center;Left_Center;8;0;Create;True;0;0;False;0;0,-5,0;0,-5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;166;-2770.131,1450.771;Float;False;Property;_Front_Center;Front_Center;4;0;Create;True;0;0;False;0;0,-5,0;0,-5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;126;-2792.459,-62.64618;Float;False;Property;_Center_Center;Center_Center;2;0;Create;True;0;0;False;0;0,-5,0;0,-5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;180;-2850.932,1286.69;Float;False;Line_face_intersection;-1;;22;ff94a0fec9691d340a7dff1a617393db;0;4;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;181;-2862.844,551.0162;Float;False;Line_face_intersection;-1;;20;ff94a0fec9691d340a7dff1a617393db;0;4;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;146;-2782.043,715.0978;Float;False;Property;_Back_Center;Back_Center;6;0;Create;True;0;0;False;0;0,-5,0;0,-5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;177;-2873.26,-226.7278;Float;False;Line_face_intersection;-1;;23;ff94a0fec9691d340a7dff1a617393db;0;4;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;106;-2807.215,-861.2223;Float;False;Property;_Right_Center;Right_Center;10;0;Create;True;0;0;False;0;0,-5,0;0,-5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;164;-2557.135,1477.445;Half;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2594.219,-834.5494;Half;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;-2594.109,-980.1173;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;165;-2557.025,1331.877;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;125;-2579.353,-181.5412;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-2569.047,741.7708;Half;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2595.211,-1621.081;Half;False;Constant;_Half;Half;1;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-2595.101,-1766.649;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-2579.463,-35.97321;Half;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;145;-2568.937,596.2028;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;109;-2403.631,-851.3922;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;123;-2388.875,-52.81609;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;163;-2366.547,1460.602;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-2404.624,-1637.924;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;143;-2378.459,724.9279;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;13;-2268.965,-1623.56;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;110;-2267.972,-837.0284;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;142;-2242.8,739.2918;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;122;-2253.216,-38.45221;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;162;-2230.888,1474.966;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FloorOpNode;14;-2137.347,-1624.94;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FloorOpNode;141;-2111.182,737.9118;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FloorOpNode;121;-2121.598,-39.83221;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FloorOpNode;161;-2099.27,1473.586;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FloorOpNode;111;-2136.354,-838.4083;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;15;-1996.34,-1655.41;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;160;-1958.265,1443.115;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;120;-1980.591,-70.30219;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;112;-1995.347,-868.8783;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;140;-1970.175,707.4418;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;16;-1714.239,-1632.233;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;139;-1688.074,730.6188;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;113;-1713.246,-845.7013;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;159;-1676.163,1466.292;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;119;-1698.49,-47.12518;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;118;-1550.988,-51.92425;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;114;-1565.744,-850.5004;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;138;-1540.572,725.8198;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;-1566.737,-1637.032;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;158;-1528.661,1461.494;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;137;-1373.182,736.9138;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;115;-1398.354,-850.4064;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;117;-1383.598,-40.83026;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-1399.347,-1625.938;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;157;-1361.271,1472.588;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-1203.788,-975.0692;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-1178.616,601.2509;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1204.781,-1761.601;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1189.032,-176.4931;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-1166.705,1336.925;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-853.2147,-1004.104;Float;False;5;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-860.1685,-2162.559;Float;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;False;0;be8af77ae7f17794dbe52e09ce45e0ab;be8af77ae7f17794dbe52e09ce45e0ab;False;white;LockedToCube;Cube;0;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.SamplerNode;8;-523.4911,-1768.425;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-143.1276,-1763.311;Float;False;True;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/Unlit;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;0;;2;=;=;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;170;0;174;0
WireConnection;150;0;154;0
WireConnection;86;0;2;0
WireConnection;99;0;97;0
WireConnection;100;0;98;0
WireConnection;129;0;131;0
WireConnection;169;0;171;0
WireConnection;130;0;134;0
WireConnection;88;0;3;0
WireConnection;149;0;151;0
WireConnection;168;0;170;0
WireConnection;148;0;150;0
WireConnection;172;0;169;0
WireConnection;102;0;99;0
WireConnection;104;0;100;0
WireConnection;128;0;130;0
WireConnection;132;0;129;0
WireConnection;93;0;88;0
WireConnection;152;0;149;0
WireConnection;92;0;86;0
WireConnection;178;2;101;0
WireConnection;178;3;104;0
WireConnection;178;4;103;0
WireConnection;178;5;102;0
WireConnection;179;2;4;0
WireConnection;179;3;92;0
WireConnection;179;4;5;0
WireConnection;179;5;93;0
WireConnection;180;2;175;0
WireConnection;180;3;172;0
WireConnection;180;4;176;0
WireConnection;180;5;168;0
WireConnection;181;2;155;0
WireConnection;181;3;152;0
WireConnection;181;4;156;0
WireConnection;181;5;148;0
WireConnection;177;2;135;0
WireConnection;177;3;132;0
WireConnection;177;4;136;0
WireConnection;177;5;128;0
WireConnection;107;0;178;0
WireConnection;107;1;106;0
WireConnection;165;0;180;0
WireConnection;165;1;166;0
WireConnection;125;0;177;0
WireConnection;125;1;126;0
WireConnection;6;0;179;0
WireConnection;6;1;7;0
WireConnection;145;0;181;0
WireConnection;145;1;146;0
WireConnection;109;0;107;0
WireConnection;109;1;108;0
WireConnection;123;0;125;0
WireConnection;123;1;124;0
WireConnection;163;0;165;0
WireConnection;163;1;164;0
WireConnection;12;0;6;0
WireConnection;12;1;11;0
WireConnection;143;0;145;0
WireConnection;143;1;144;0
WireConnection;13;0;12;0
WireConnection;110;0;109;0
WireConnection;142;0;143;0
WireConnection;122;0;123;0
WireConnection;162;0;163;0
WireConnection;14;0;13;0
WireConnection;141;0;142;0
WireConnection;121;0;122;0
WireConnection;161;0;162;0
WireConnection;111;0;110;0
WireConnection;15;0;14;0
WireConnection;160;0;161;0
WireConnection;120;0;121;0
WireConnection;112;0;111;0
WireConnection;140;0;141;0
WireConnection;16;0;15;1
WireConnection;16;1;15;2
WireConnection;139;0;140;0
WireConnection;139;1;140;1
WireConnection;113;0;112;1
WireConnection;113;1;112;2
WireConnection;159;0;160;0
WireConnection;159;1;160;1
WireConnection;119;0;120;0
WireConnection;119;1;120;2
WireConnection;118;0;119;0
WireConnection;114;0;113;0
WireConnection;138;0;139;0
WireConnection;17;0;16;0
WireConnection;158;0;159;0
WireConnection;137;0;138;0
WireConnection;115;0;114;0
WireConnection;117;0;118;0
WireConnection;18;0;17;0
WireConnection;157;0;158;0
WireConnection;116;0;107;0
WireConnection;116;1;115;0
WireConnection;153;0;145;0
WireConnection;153;1;137;0
WireConnection;19;0;6;0
WireConnection;19;1;18;0
WireConnection;133;0;125;0
WireConnection;133;1;117;0
WireConnection;173;0;165;0
WireConnection;173;1;157;0
WireConnection;84;0;19;0
WireConnection;84;1;116;0
WireConnection;84;2;133;0
WireConnection;84;3;153;0
WireConnection;84;4;173;0
WireConnection;8;0;9;0
WireConnection;8;1;84;0
WireConnection;0;0;8;0
ASEEND*/
//CHKSM=D5906F6ED4766DED96CADE6AC3950DCE8D993450