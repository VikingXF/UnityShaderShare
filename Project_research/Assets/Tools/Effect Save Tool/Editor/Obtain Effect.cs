using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System.IO;
using System.Collections.Generic;

namespace Babybus.Engineer.Obtain
{
    /// <summary>
    /// 位置信息编辑器扩展
    /// </summary>
    [CustomEditor(typeof(Obtain))]
    public class ObtainEffect : Editor
    {

        #region Main Parameter

        public Obtain _gameObjectPosition;
        private int _deletePositionIndex = -1;
        private TransformInformation _information;
        private TransformInformation _currentInformation;
        public static Obtainposition PSO;
        //string path = "Assets/_Effect/Effectasset";     
        //public bool cp = true;

        #endregion


        /// <summary>
        /// 创建asset资源存放目录
        /// </summary>
        //private void GenerateFolder()
        //{
         
        //    if (!Directory.Exists(path))
        //    {
        //        Directory.CreateDirectory(path);
        //        cp = false;
        //    }          
        //}

        public override void OnInspectorGUI()
        {

            _gameObjectPosition = target as Obtain;
            _deletePositionIndex = -1;
          
            for (int j = 0; j < _gameObjectPosition._list.Count; j++)
            {
                _information = _gameObjectPosition._list[j];
                EditorGUILayout.BeginHorizontal();

                if (GUILayout.Button("移动位置"))
                {
                    LoadPosition();

                }
                _information._desc = EditorGUILayout.TextField(_information._desc);

                if (GUILayout.Button("读取信息坐标"))
                {
                    
                    Transform transform = _gameObjectPosition.transform;
                    transform.localPosition = _information._localPosition;
                    transform.localRotation = _information._localRotation;
                    transform.localScale = _information._scale;
                    
                }

                
                if (GUILayout.Button("保存位置"))
                {


                    if (EditorUtility.DisplayDialog("保存确定","保存成功","确定"))
                    { 
                        SavePosition(_information, _gameObjectPosition.transform);
                        _currentInformation = _information;
                        EditorApplication.delayCall += CreateScriptableObject;
                        Debug.Log("保存成功");
                    }
                }
                

                if (GUILayout.Button("删除"))
                {

                    if (EditorUtility.DisplayDialog("警告", "你确定要删除当前保存的位置信息吗？", "确定", "取消"))
                    {
                        _deletePositionIndex = j;
                    }
                }

                
                EditorGUILayout.EndHorizontal();
                GUILayout.Space(10);
            }

            if (_deletePositionIndex != -1) _gameObjectPosition._list.RemoveAt(_deletePositionIndex);

            if (GUILayout.Button("添加特效信息"))
            {
                //if (cp == true)
                //{
                //    GenerateFolder();
                //}
                _gameObjectPosition._list.Add(new TransformInformation());
                SavePosition(_gameObjectPosition._list[_gameObjectPosition._list.Count - 1], _gameObjectPosition.gameObject.GetComponent<Transform>());
            }

            if (GUILayout.Button("查看相同名称父物体数量"))
            {
                LoadparentCount();
            }

            serializedObject.ApplyModifiedProperties();
            EditorUtility.SetDirty(_gameObjectPosition);
            if (GUI.changed && EditorApplication.isPlaying == false) EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }

        /// <summary>
        /// 保存位置
        /// </summary>
        /// <param name="information"></param>
        /// <param name="transform"></param>
        private void SavePosition(TransformInformation information, Transform transform)
        {

            information._localPosition = transform.localPosition;
            information._localRotation = transform.localRotation;
            information._scale = transform.localScale;
            information._EffectObject = transform.gameObject;
            information._parentObject = transform.parent.gameObject;
            information._parentName = transform.parent.gameObject.name;
        }

        /// <summary>
        /// 查找相同名称父物体数量
        /// </summary>
        private void LoadparentCount()
        {
            List<GameObject> parentobjs = new List<GameObject>();
            foreach (GameObject go in GameObject.FindObjectsOfType(typeof(GameObject)))
            {
                if (go.name == _information._parentName)
                {
                    parentobjs.Add(go);
                }
            }
            if (parentobjs.Count >= 2)
            {
                EditorUtility.DisplayDialog("警告", "相同父物体数目有：" + parentobjs.Count.ToString() + "个；请检查！！！", "确定");
            }
            else
            {
                EditorUtility.DisplayDialog("警告", " 相同名称父物体只有一个，请放心使用！！！", "确定");
            }
        }


        /// <summary>
        /// 读取移动到指定父物体下
        /// </summary>
        private void LoadPosition()
        {
            GameObject container = GameObject.Find(_information._parentName);
            Debug.Log(container.name);
           
            _gameObjectPosition.transform.parent = container.transform;
            Transform transform = _gameObjectPosition.transform;
            transform.localPosition = _information._localPosition;
            transform.localRotation = _information._localRotation;
            transform.localScale = _information._scale;

        }
       

        /// <summary>
        /// 创建序列化脚本对象
        /// </summary>
        private void CreateScriptableObject()
        {
            string path = AssetDatabase.GetAssetPath(PrefabUtility.GetPrefabParent(Selection.activeGameObject));
            path = path.Substring(0, path.LastIndexOf('/'));         
            string _psoPath = path + "/"+ _currentInformation._EffectObject.name+".asset";
            PSO = AssetDatabase.LoadAssetAtPath<Obtainposition>(_psoPath);
            if (PSO == null)
            {                             
                if (PSO == null)
                {
                    PSO = ScriptableObject.CreateInstance<Obtainposition>();
                    AssetDatabase.CreateAsset(PSO, _psoPath);
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                }
            }
            TransformInformation t = PSO._positionList.Find(n => n._EffectObject == _currentInformation._EffectObject && n._desc == _currentInformation._desc);
            if (t != null) PSO._positionList.Remove(t);
            PSO._positionList.Add(_currentInformation);
        }
    }
}

