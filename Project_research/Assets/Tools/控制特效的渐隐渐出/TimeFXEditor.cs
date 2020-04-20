//=============================================
//作者:
//描述:
//创建时间:2020/04/15 08:36:55
//版本:v 1.0
//=============================================
using UnityEngine;
using System.Collections;
using UnityEditor;
using UnityEditorInternal;
[ExecuteInEditMode]
[CustomEditor(typeof(Time_Fx))]
public class TimeFXEditor : Editor
{
    ReorderableList reorderableList;

    void OnEnable()
    {
        SerializedProperty prop = serializedObject.FindProperty("TimeGameObj");

        reorderableList = new ReorderableList(serializedObject, prop, true, true, true, true);

        //设置单个元素的高度
        reorderableList.elementHeight = 80;

        //绘制单个元素
        reorderableList.drawElementCallback =
            (rect, index, isActive, isFocused) => {
                var element = prop.GetArrayElementAtIndex(index);
                rect.height -= 4;
                rect.y += 2;
                EditorGUI.PropertyField(rect, element);
            };

        //背景色
        reorderableList.drawElementBackgroundCallback = (rect, index, isActive, isFocused) => {
            GUI.backgroundColor = new Color(0.7f, 0.7f, 0.7f);
        };

        //头部
        reorderableList.drawHeaderCallback = (rect) =>
            EditorGUI.LabelField(rect, prop.displayName);

    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        reorderableList.DoLayoutList();
        serializedObject.ApplyModifiedProperties();
    }
}