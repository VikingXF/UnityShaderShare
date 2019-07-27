#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(Set_Shader_Variable))]
public class Set_Shader_VariableEditor : Editor
{


    public override void OnInspectorGUI()
    {
        Set_Shader_Variable set_shader_variable = target as Set_Shader_Variable;

        EditorGUILayout.Space();
        set_shader_variable.IsLoop = EditorGUILayout.Toggle("IsLoop", set_shader_variable.IsLoop);
        set_shader_variable.FloatCurve = (AnimationCurve)EditorGUILayout.CurveField("Curve", set_shader_variable.FloatCurve);

        set_shader_variable.FloatToggle = EditorGUILayout.BeginToggleGroup("FloatToggle", set_shader_variable.FloatToggle);
      
        //if (set_shader_variable.FloatToggle)
        //{
            set_shader_variable.Color = (Gradient)EditorGUILayout.GradientField("Gradient", set_shader_variable.Color);
        //}
       
        EditorGUILayout.EndToggleGroup();


    }

}
#endif