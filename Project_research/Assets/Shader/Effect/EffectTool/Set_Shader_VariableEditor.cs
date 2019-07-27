#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(Set_Shader_Variable))]
public class Set_Shader_VariableEditor : Editor
{

    //private bool colorDrop = true;
    public override void OnInspectorGUI()
    {
        
        Set_Shader_Variable set_shader_variable = target as Set_Shader_Variable;

        EditorGUILayout.Space();
        using (new EditorGUILayout.VerticalScope(GUI.skin.box))
        {
            set_shader_variable.IsLoop = EditorGUILayout.Toggle("IsLoop", set_shader_variable.IsLoop);

        }

        using (new EditorGUILayout.VerticalScope(GUI.skin.box))
        {

            set_shader_variable.FloatToggle = EditorGUILayout.BeginToggleGroup("", set_shader_variable.FloatToggle);

            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                set_shader_variable.FloatCurve = (AnimationCurve)EditorGUILayout.CurveField("Curve", set_shader_variable.FloatCurve);
            }
            EditorGUILayout.EndToggleGroup();
        }


        using (new EditorGUILayout.VerticalScope(GUI.skin.box))
        {
            set_shader_variable.ColorToggle = EditorGUILayout.BeginToggleGroup("", set_shader_variable.ColorToggle);
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                set_shader_variable.Color = (Gradient)EditorGUILayout.GradientField("Gradient", set_shader_variable.Color);
            }
            EditorGUILayout.EndToggleGroup();
        }
       

    }

}
#endif