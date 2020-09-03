//=============================================
//作者:xf
//描述:特效shader GUI
//创建时间:2020/06/24
//版本:v 1.0
//=============================================
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace UnityEditor
{
    public class BabybusParticlesShaderGUI : ShaderGUI
    {
        
        public enum BlendMode
        {
            None,
            Blend,
            Additive,
            Multiply
        }

        public enum RenderingOrder
        {
            Background,
            Geometry,
            AlphaTest,
            Transparent,
            Overlay
        }
        BlendMode blendmode = BlendMode.None;

        private static class Styles
        {
            public static GUIContent MainText = EditorGUIUtility.TrTextContent("Main Tex", "Main Tex");
        }
        public void FindProperties(MaterialProperty[] props)
        {

        }
        public static void SetupMaterialWithBlendMode(Material material, BlendMode blendMode)
        {
            switch (blendMode)
            {
                case BlendMode.None:
                    break;
                case BlendMode.Additive:
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    break;
                case BlendMode.Blend:                  
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    break;
                case BlendMode.Multiply:
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.DstColor);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    break;
            }
        }
        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
           

            Material targetMat = materialEditor.target as Material;
            // see if redify is set, and show a checkbox
            //bool CS_BOOL = Array.IndexOf(targetMat.shaderKeywords, "CS_BOOL") != -1;

            EditorGUI.BeginChangeCheck();
           // CS_BOOL = EditorGUILayout.Toggle("CS_BOOL", CS_BOOL);
            blendmode = (BlendMode)EditorGUILayout.EnumPopup("BlendMode", blendmode);

            if (EditorGUI.EndChangeCheck())
            {
                // enable or disable the keyword based on checkbox
                //if (CS_BOOL)
                //    targetMat.EnableKeyword("CS_BOOL");
               // else
                //    targetMat.DisableKeyword("CS_BOOL");


            }
            // render the default gui
            base.OnGUI(materialEditor, properties);
        }
    }


}

