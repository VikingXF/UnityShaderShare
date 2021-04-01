#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace CombineMeshSpace
{
    [CustomEditor(typeof(CombineMesh))]
    public class CombineMeshInspector : Editor
    {
        public CombineMesh combinemesh;
        [SerializeField]//必须要加  
        public List<GameObject> CombineMeshs = new List<GameObject>();

        //public string CombineName;
        private enum CombineMode
        {
            CombineLightmapMesh,
            CombineBasicMesh,
            CombineMeshTexture,
            CombineBasicSkinnedMesh
        }
        //private bool savebool =false;
        private CombineMode CombineMeshtype ;

        SerializedProperty CombineMeshsProp;

        private void OnEnable()
        {
            CombineMeshsProp = serializedObject.FindProperty("CombineMeshs");
        }
        public override void OnInspectorGUI()
        {
            combinemesh = target as CombineMesh;

            //EditorGUILayout.BeginVertical();
            GUILayout.Label("");

            combinemesh.CombineName = EditorGUILayout.DelayedTextField("合并后模型名：", combinemesh.CombineName);
            serializedObject.Update();
            EditorGUILayout.PropertyField(CombineMeshsProp,true);

            serializedObject.ApplyModifiedProperties();

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
                if (CombineMeshtype == CombineMode.CombineLightmapMesh)
                {
                    combinemesh.CombineLightmapMesh();

                }

                if (CombineMeshtype == CombineMode.CombineBasicMesh)
                {
                    combinemesh.CombineBasicMesh();
                                      
                }
                if (CombineMeshtype == CombineMode.CombineMeshTexture)
                {
                    combinemesh.CombineMeshTexture();
                   
                }
                if (CombineMeshtype == CombineMode.CombineBasicSkinnedMesh)
                {
                    combinemesh.CombineBasicSkinnedMesh();

                }
            }

            


        }
  
    }
}
#endif