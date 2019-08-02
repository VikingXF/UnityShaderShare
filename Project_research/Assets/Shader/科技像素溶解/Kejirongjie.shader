// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:35015,y:32844,varname:node_4795,prsc:2|emission-2418-OUT,alpha-639-OUT;n:type:ShaderForge.SFN_TexCoord,id:2758,x:32072,y:32886,varname:node_2758,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Tex2d,id:5512,x:32971,y:32968,ptovrint:False,ptlb:Main_Tex,ptin:_Main_Tex,varname:node_5512,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bce2aaa6ff685cd4f84fbb3e80a487a3,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Step,id:5804,x:32974,y:33325,varname:node_5804,prsc:2|A-8575-R,B-9013-OUT;n:type:ShaderForge.SFN_Step,id:4012,x:32974,y:33521,varname:node_4012,prsc:2|A-8575-R,B-2154-OUT;n:type:ShaderForge.SFN_Subtract,id:5860,x:33228,y:33500,varname:node_5860,prsc:2|A-5804-OUT,B-4012-OUT;n:type:ShaderForge.SFN_Color,id:4798,x:33228,y:33675,ptovrint:False,ptlb:Edge_Color,ptin:_Edge_Color,varname:node_4798,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0.7931032,c3:1,c4:1;n:type:ShaderForge.SFN_Color,id:7586,x:32971,y:32801,ptovrint:False,ptlb:Main_Color,ptin:_Main_Color,varname:node_7586,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:5145,x:31915,y:33070,ptovrint:False,ptlb:Chongfu,ptin:_Chongfu,varname:node_5145,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:13,max:100;n:type:ShaderForge.SFN_Tex2d,id:8575,x:32560,y:32934,varname:node_8575,prsc:2,tex:a1457ee9d37cef14daa37894ae6d3b25,ntxv:0,isnm:False|UVIN-8778-OUT,TEX-9264-TEX;n:type:ShaderForge.SFN_Tex2d,id:2977,x:32558,y:32770,ptovrint:False,ptlb:Wenli,ptin:_Wenli,varname:node_2977,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bde579ecd6b9ac14bad3787ef55a90c1,ntxv:0,isnm:False|UVIN-1522-OUT;n:type:ShaderForge.SFN_Multiply,id:1522,x:32334,y:32770,varname:node_1522,prsc:2|A-2758-UVOUT,B-5145-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:9264,x:32334,y:33154,ptovrint:False,ptlb:Dissolution_Tex,ptin:_Dissolution_Tex,varname:node_9264,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a1457ee9d37cef14daa37894ae6d3b25,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:3322,x:32560,y:33115,varname:node_3322,prsc:2,tex:a1457ee9d37cef14daa37894ae6d3b25,ntxv:0,isnm:False|TEX-9264-TEX;n:type:ShaderForge.SFN_Clamp01,id:639,x:34818,y:33106,varname:node_639,prsc:2|IN-5561-OUT;n:type:ShaderForge.SFN_Add,id:9668,x:32974,y:33136,varname:node_9668,prsc:2|A-3322-R,B-7197-OUT;n:type:ShaderForge.SFN_Subtract,id:7393,x:33594,y:33117,varname:node_7393,prsc:2|A-7245-OUT,B-634-OUT;n:type:ShaderForge.SFN_Abs,id:634,x:33362,y:33136,varname:node_634,prsc:2|IN-9668-OUT;n:type:ShaderForge.SFN_Posterize,id:8778,x:32334,y:32934,varname:node_8778,prsc:2|IN-2758-UVOUT,STPS-5145-OUT;n:type:ShaderForge.SFN_RemapRange,id:7197,x:32560,y:33244,varname:node_7197,prsc:2,frmn:-1,frmx:1.5,tomn:2,tomx:-2|IN-9013-OUT;n:type:ShaderForge.SFN_Vector1,id:8698,x:32334,y:33553,varname:node_8698,prsc:2,v1:-0.1;n:type:ShaderForge.SFN_Add,id:2154,x:32557,y:33534,varname:node_2154,prsc:2|A-9013-OUT,B-8698-OUT;n:type:ShaderForge.SFN_Multiply,id:2612,x:33726,y:33481,varname:node_2612,prsc:2|A-8414-OUT,B-4798-RGB;n:type:ShaderForge.SFN_Add,id:2181,x:34280,y:33406,varname:node_2181,prsc:2|A-4658-OUT,B-5804-OUT;n:type:ShaderForge.SFN_Add,id:2418,x:33979,y:32922,varname:node_2418,prsc:2|A-7879-OUT,B-2612-OUT;n:type:ShaderForge.SFN_Add,id:8414,x:33497,y:33481,varname:node_8414,prsc:2|A-4658-OUT,B-5860-OUT;n:type:ShaderForge.SFN_Lerp,id:7879,x:33579,y:32921,varname:node_7879,prsc:2|A-3858-OUT,B-1821-OUT,T-5804-OUT;n:type:ShaderForge.SFN_Multiply,id:1821,x:33220,y:32949,varname:node_1821,prsc:2|A-7586-RGB,B-5512-RGB;n:type:ShaderForge.SFN_Multiply,id:6659,x:33484,y:33675,varname:node_6659,prsc:2|A-4798-RGB,B-9260-OUT;n:type:ShaderForge.SFN_Vector1,id:9260,x:33221,y:33885,varname:node_9260,prsc:2,v1:3;n:type:ShaderForge.SFN_Set,id:6735,x:32728,y:32847,varname:Wenli,prsc:2|IN-2977-A;n:type:ShaderForge.SFN_Get,id:7245,x:33341,y:33086,varname:node_7245,prsc:2|IN-6735-OUT;n:type:ShaderForge.SFN_Set,id:5718,x:33705,y:33675,varname:Edge_Color,prsc:2|IN-6659-OUT;n:type:ShaderForge.SFN_Get,id:3858,x:33199,y:32887,varname:node_3858,prsc:2|IN-5718-OUT;n:type:ShaderForge.SFN_Clamp01,id:4658,x:33979,y:33118,varname:node_4658,prsc:2|IN-7393-OUT;n:type:ShaderForge.SFN_Multiply,id:5561,x:34571,y:33404,varname:node_5561,prsc:2|A-2181-OUT,B-4367-OUT;n:type:ShaderForge.SFN_Slider,id:3963,x:31866,y:33345,ptovrint:False,ptlb:Dissolution,ptin:_Dissolution,varname:_Qiehuan_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:9013,x:32201,y:33345,varname:node_9013,prsc:2,frmn:1,frmx:0,tomn:-0.5,tomx:1.5|IN-3963-OUT;n:type:ShaderForge.SFN_Set,id:4147,x:33199,y:33074,varname:Main_Tex_A,prsc:2|IN-5512-A;n:type:ShaderForge.SFN_Get,id:4367,x:34259,y:33532,varname:node_4367,prsc:2|IN-4147-OUT;proporder:7586-4798-5512-9264-2977-5145-3963;pass:END;sub:END;*/

Shader "AX_Test/Keji_Rongjie" {
    Properties {
        [HDR]_Main_Color ("Main_Color", Color) = (1,1,1,1)
        [HDR]_Edge_Color ("Edge_Color", Color) = (0,0.7931032,1,1)
        _Main_Tex ("Main_Tex", 2D) = "white" {}
        _Dissolution_Tex ("Dissolution_Tex", 2D) = "white" {}
        _Wenli ("Wenli", 2D) = "white" {}
        _Chongfu ("Chongfu", Range(1, 100)) = 13
        _Dissolution ("Dissolution", Range(0, 1)) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _Main_Tex; uniform float4 _Main_Tex_ST;
            uniform float4 _Edge_Color;
            uniform float4 _Main_Color;
            uniform float _Chongfu;
            uniform sampler2D _Wenli; uniform float4 _Wenli_ST;
            uniform sampler2D _Dissolution_Tex; uniform float4 _Dissolution_Tex_ST;
            uniform float _Dissolution;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float3 Edge_Color = (_Edge_Color.rgb*3.0);
                float4 _Main_Tex_var = tex2D(_Main_Tex,TRANSFORM_TEX(i.uv0, _Main_Tex));
                float2 node_8778 = floor(i.uv0 * _Chongfu) / (_Chongfu - 1);
                float4 node_8575 = tex2D(_Dissolution_Tex,TRANSFORM_TEX(node_8778, _Dissolution_Tex));
                float node_9013 = (_Dissolution*-2.0+1.5);
                float node_5804 = step(node_8575.r,node_9013);
                float2 node_1522 = (i.uv0*_Chongfu);
                float4 _Wenli_var = tex2D(_Wenli,TRANSFORM_TEX(node_1522, _Wenli));
                float Wenli = _Wenli_var.a;
                float4 node_3322 = tex2D(_Dissolution_Tex,TRANSFORM_TEX(i.uv0, _Dissolution_Tex));
                float node_4658 = saturate((Wenli-abs((node_3322.r+(node_9013*-1.6+0.4)))));
                float3 emissive = (lerp(Edge_Color,(_Main_Color.rgb*_Main_Tex_var.rgb),node_5804)+((node_4658+(node_5804-step(node_8575.r,(node_9013+(-0.1)))))*_Edge_Color.rgb));
                float3 finalColor = emissive;
                float Main_Tex_A = _Main_Tex_var.a;
                return fixed4(finalColor,saturate(((node_4658+node_5804)*Main_Tex_A)));
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
