//=============================================
//作者:
//描述:
//创建时间:2021/02/08 17:35:51
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

#if UNITY_EDITOR
public class HiddenMeshRender : EditorWindow
{
    [MenuItem("Tools/隐藏meshrender")]
    public static void ShowWindow()
    {

        EditorWindow editorWindow = EditorWindow.GetWindow(typeof(HiddenMeshRender));
        editorWindow.autoRepaintOnSceneChange = true;
        editorWindow.Show();
        editorWindow.titleContent.text = "隐藏meshrender";
    }
    protected void OnEnable()
    {
        SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
        SceneView.onSceneGUIDelegate += this.OnSceneGUI;
      
    }
    void OnDestroy()
    {
        SceneView.onSceneGUIDelegate -= this.OnSceneGUI;

    }

    void OnSceneGUI(SceneView sceneView)
    {

    }
    private void OnGUI()
    {

        GUILayout.Space(10f);
        if (GUILayout.Button("隐藏meshrender", GUILayout.Width(240), GUILayout.Height(30)))
        {
            hiddrender();
        }

    }

    private void hiddrender()
    {
        if (Selection.activeTransform != null)
        {
            Transform[] father = Selection.activeTransform.GetComponentsInChildren<Transform>();
            foreach (var child in father)
            {
                if (child.GetComponent<MeshRenderer>() != null)
                {
                    child.GetComponent<MeshRenderer>().enabled = false;
                }
                
            }
        }
    }

}
#endif