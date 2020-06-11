using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
namespace Babybus.UtilityTools
{
    [CustomEditor(typeof(CustomEditorBase), true)]
    public class CustomEditorBaseEditor : Editor
    {
        private CustomEditorBase _customEditorBase;
        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            serializedObject.Update();
            _customEditorBase = target as CustomEditorBase;
            _customEditorBase.Draw();
            serializedObject.ApplyModifiedProperties();
            EditorUtility.SetDirty(_customEditorBase);
            //这个函数告诉引擎，相关对象所属于的Prefab已经发生了更改。方便，当我们更改了自定义对象的属性的时候，自动更新到所属的Prefab中
            if (GUI.changed && EditorApplication.isPlaying == false) EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }
    }
}
