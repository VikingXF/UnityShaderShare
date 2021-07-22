//=============================================
//作者:
//描述:
//创建时间:2021/05/14 10:51:52
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.Linq;

public class BabybusShaderEditor : ShaderGUI
{
    public enum ShadingMode
    {
        Simple,
        Reflective
    }
    ShadingMode ShadingModeVal = ShadingMode.Simple;
    bool CheckBoxValue = false;

    private void SetKeyword(Material material, string keyword,bool state)
    {
        if(state)
            material.EnableKeyword(keyword);
            else
            material.DisableKeyword(keyword);      
    }
    private ShadingMode GetMaterialShadingMode(Material Mat)
    {
        ShadingMode Ret = ShadingMode.Simple;
        
        if(Array.IndexOf(Mat.shaderKeywords,"_SHADEMODE_SIMPLE")!= -1)
        {
            Ret = ShadingMode.Simple;      
            return Ret;     
        }
        else if(Array.IndexOf(Mat.shaderKeywords,"_SHADEMODE_REFLECTIVE")!= -1)
        {
            Ret = ShadingMode.Reflective;
            return Ret;
        }
        return Ret;
    }
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
         materialEditor.SetDefaultGUIWidths();
            Material targetMat = materialEditor.target as Material;
            string[] keyWords = targetMat.shaderKeywords;

            //Draw shading mode
            EditorGUI.BeginChangeCheck();
            ShadingModeVal = GetMaterialShadingMode(targetMat);
            ShadingModeVal = (ShadingMode)EditorGUILayout.EnumPopup(ShadingModeVal);
            if (EditorGUI.EndChangeCheck())
            {
                SetKeyword(targetMat, "_SHADEMODE_SIMPLE", ShadingModeVal == ShadingMode.Simple);
                SetKeyword(targetMat, "_SHADEMODE_REFLECTIVE", ShadingModeVal == ShadingMode.Reflective);
            }

            //Draw label
            GUILayout.Label("Textures", EditorStyles.boldLabel);
            
            //Draw texture slot
            MaterialProperty baseTex = FindProperty("_BaseTex", props);
            GUIContent basexTexture = new GUIContent("BaseTexture", "Base Tex");
            materialEditor.ShaderProperty(baseTex, basexTexture);

            //Draw slider
            EditorGUI.indentLevel += 2;
            GUIContent MetallicSlider = new GUIContent("StrenthSlider", "Strenth Slider");
            MaterialProperty Strenth = FindProperty("_Strenth", props);
            materialEditor.ShaderProperty(Strenth, MetallicSlider);

            EditorGUI.indentLevel -= 2;
            CheckBoxValue = Array.IndexOf(targetMat.shaderKeywords, "_TEST_BLENDMODE") != -1;
            EditorGUI.BeginChangeCheck();
            CheckBoxValue = EditorGUILayout.Toggle("CheckBox", CheckBoxValue);
            if(EditorGUI.EndChangeCheck())
            {
                SetKeyword(targetMat, "_TEST_BLENDMODE", CheckBoxValue);
            }
    }

    


}
