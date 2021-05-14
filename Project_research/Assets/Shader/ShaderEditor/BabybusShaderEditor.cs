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
    // private ShadingMode GetMaterialShadingMode(Material Mat)
    // {
    //     ShadingMode Ret = ShadingMode.Simple;
        
    //     if(Array.IndexOf(Mat.shaderKeywords,"_SHADEMODE_SIMPLE")!= -1)
    //     {
    //         Ret = ShadingMode.Simple;
            
    //     }
    // }

}
