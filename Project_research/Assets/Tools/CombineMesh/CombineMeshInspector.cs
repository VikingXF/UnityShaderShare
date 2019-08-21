#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

namespace CombineMeshSpace
{
    [CustomEditor(typeof(CombineMesh))]
    public class CombineMeshInspector : Editor
    {
        public CombineMesh combinemesh;
        //public string CombineName;
        private enum CombineMode
        {
            CombineBasicMesh,
            CombineMeshTexture

        }
        //private bool savebool =false;
        private CombineMode CombineMeshtype ;
        public override void OnInspectorGUI()
        {
            combinemesh = target as CombineMesh;

            //EditorGUILayout.BeginVertical();
            GUILayout.Label("");

            combinemesh.CombineName = EditorGUILayout.DelayedTextField("合并后模型名：", combinemesh.CombineName);
            CombineMeshtype = (CombineMode)EditorGUILayout.EnumPopup("合并类型", CombineMeshtype);
            if (GUILayout.Button(combinemesh.folder))
            {
                combinemesh.folder = EditorUtility.SaveFolderPanel("Path to Save", combinemesh.folder, Application.dataPath);
                if (combinemesh.folder != null)
                {
                    int startIndex = combinemesh.folder.IndexOf("Assets/");
                    string relativePath = "Assets/";
                    if (startIndex > 0)
                    {
                        relativePath = combinemesh.folder.Substring(startIndex) + "/";
                    }
                    else
                    {
                        Debug.LogError("请选择Assets/下的目录");
                    }
                    combinemesh.folder = relativePath;
                }
            }

            EditorGUILayout.Space();
            if (GUILayout.Button("CombineMesh",GUILayout.Height(30)))
            {
                //savebool = true;
                if (CombineMeshtype == CombineMode.CombineBasicMesh)
                {
                    combinemesh.CombineBasicMesh();
                                      
                }
                if (CombineMeshtype == CombineMode.CombineMeshTexture)
                {
                    combinemesh.CombineMeshTexture();
                   
                }
            }

            


        }
  
    }
}
#endif