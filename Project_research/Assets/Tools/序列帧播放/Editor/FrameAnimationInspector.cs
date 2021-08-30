using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(FrameAnimation))]
public class FrameAnimationInspector : Editor
{
    private SerializedObject frameAnimation;//序列化
    //private SerializedProperty _Mode,_Sprites, _Tiles,_TimeMode,_Fps,_StartFarme,_EndFarme;
    private SerializedProperty _ReplayMode,_Mode,_Sprites, _Tiles,_TimeMode,_Fps,_StartFarme;
    void OnEnable()
    {
        frameAnimation = new SerializedObject(target);
        _ReplayMode = frameAnimation.FindProperty("ReplayMode");
        _Mode = frameAnimation.FindProperty("Mode");
        _Sprites = frameAnimation.FindProperty("Sprites");
        _Tiles = frameAnimation.FindProperty("Tiles");
        _TimeMode = frameAnimation.FindProperty("TimeMode");
        _Fps = frameAnimation.FindProperty("Fps");
        _StartFarme = frameAnimation.FindProperty("StartFarme");
       // _EndFarme = frameAnimation.FindProperty("EndFarme");
    }
    public override void OnInspectorGUI()
    {
        if (Cheak())
        {
            
            frameAnimation.Update();
            EditorGUILayout.BeginVertical();
            EditorGUILayout.PropertyField(_ReplayMode);
            EditorGUILayout.PropertyField(_TimeMode);
            EditorGUILayout.PropertyField(_Mode);
            if (_Mode.enumValueIndex == 0) {
                EditorGUILayout.PropertyField(_Sprites);
            }
            else if (_Mode.enumValueIndex == 1) {
                EditorGUILayout.PropertyField(_Tiles);
            }
            EditorGUILayout.PropertyField(_Fps);
            EditorGUILayout.PropertyField(_StartFarme);
            //EditorGUILayout.PropertyField(_EndFarme);
            EditorGUILayout.EndVertical();
            frameAnimation.ApplyModifiedProperties();
        }
       
    }
    
    //检查是否有材质球
    bool Cheak()
    {
        bool Cheak = false;
        Transform Select = Selection.activeTransform;

        if(Select.gameObject.GetComponent<MeshRenderer>().sharedMaterial !=null)
        {
            Cheak = true;
        }
        else 
        {
            EditorGUILayout.HelpBox("当前模型没材质球！请更换！", MessageType.Error);
            
        }
        return Cheak;
    }

}
