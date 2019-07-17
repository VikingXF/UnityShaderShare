#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;


[CustomEditor(typeof(Text3DMesh))]
public class Text3DMeshInspector : Editor
{
      
    public Text3DMesh CreatTextMesh;

    public override void OnInspectorGUI()
    {
        CreatTextMesh = target as Text3DMesh;
        EditorGUI.BeginChangeCheck();

        EditorGUILayout.BeginVertical();
        GUILayout.Label("Text");
        CreatTextMesh.Text = EditorGUILayout.TextArea(CreatTextMesh.Text, GUILayout.Height(30));

        EditorGUILayout.EndVertical();

        CreatTextMesh.Interval = EditorGUILayout.FloatField("数字间间隔", CreatTextMesh.Interval);

        CreatTextMesh.FontSize = EditorGUILayout.FloatField("字体大小", CreatTextMesh.FontSize);

        CreatTextMesh.font = EditorGUILayout.ObjectField(new GUIContent("字体"), CreatTextMesh.font, typeof(Font), true) as Font;
      

        if (EditorGUI.EndChangeCheck())
        {

            CreatTextMesh.CreateTextMesh();

        }

    }


}
#endif