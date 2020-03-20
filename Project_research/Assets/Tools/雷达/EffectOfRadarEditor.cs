#if UNITY_EDITOR

using UnityEngine;
using UnityEditor;
using System.Collections;
using UnityEditorInternal;

[CustomEditor(typeof(EffectOfRadar))]
[CanEditMultipleObjects]
public class EffectOfRadarEditor : Editor
{

    ReorderableList m_ReorderableList;
    public EffectOfRadar Radar;

    void OnEnable()
    {
        SerializedProperty property = serializedObject.FindProperty("m_Weights");

        if (m_ReorderableList == null)
        {
            m_ReorderableList = new ReorderableList(serializedObject, property, true, true, true, true);
            m_ReorderableList.drawElementCallback = DrawEdgeWeight;
            m_ReorderableList.drawHeaderCallback = DrawHeader;
        }

    }
    private void DrawEdgeWeight(Rect rect, int index, bool isActive, bool isFocused)
    {
        SerializedProperty itemData = m_ReorderableList.serializedProperty.GetArrayElementAtIndex(index);
        EditorGUI.Slider(rect, itemData, 0, 1);
    }

    private void DrawHeader(Rect rect)
    {
        EditorGUI.LabelField(rect, "能力权重");
    }

    public override void OnInspectorGUI()
    {
        Radar = target as EffectOfRadar;

        EditorGUI.BeginChangeCheck();
        Radar.Maincolor = EditorGUILayout.ColorField("内圈颜色",Radar.Maincolor);
        Radar.Outlincolor = EditorGUILayout.ColorField("描边颜色", Radar.Outlincolor);

        Radar.outline = EditorGUILayout.FloatField("描边大小",Radar.outline);
        serializedObject.Update();
       
        m_ReorderableList.DoLayoutList();     
        serializedObject.ApplyModifiedProperties();

        if (EditorGUI.EndChangeCheck())
        {
        
            Radar.CreateMesh();
            Radar.Setcolor();
        }
    }


    
}
#endif