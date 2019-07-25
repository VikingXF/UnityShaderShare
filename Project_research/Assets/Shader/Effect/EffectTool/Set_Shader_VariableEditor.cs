#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(Set_Shader_Variable))]
public class Set_Shader_VariableEditor : Editor
{
    private Set_Shader_Variable set_shader_variable;
    private AnimationCurve FloatCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
    private Gradient Color = new Gradient();
    private bool FloatToggle = true;

    public override void OnInspectorGUI()
    {
        set_shader_variable = target as Set_Shader_Variable;

        EditorGUILayout.Space();
        FloatCurve = (AnimationCurve)EditorGUILayout.CurveField("Curve", FloatCurve);
       
        FloatToggle = EditorGUILayout.BeginToggleGroup("FloatToggle", FloatToggle);
        Color = (Gradient)EditorGUILayout.GradientField("Gradient", Color);
        EditorGUILayout.EndToggleGroup();


    }

}
#endif