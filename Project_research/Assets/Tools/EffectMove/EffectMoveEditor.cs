//=======================================================
// 作者：薛飞  2021/4/2 14:03:02
// 描述：
//=======================================================

using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace EffectTools
{
    [CustomEditor(typeof(EffectMove))]
    public class EffectMoveEditor : Editor
    {
        private EffectMove _EffectMove;
        private effectmov _effectmov;
        private effectmov _effecInformation;
        private Transform effecTra;
        private int _deleteIndex = -1;
        private string _EffectpsoPath = "Assets/_Effect/精灵洗澡保存位置.asset";
        public static EffectMoveScriptableobject PSO;
        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            _EffectMove = target as EffectMove;
            GUILayout.Space(10);

            _EffectpsoPath = EditorGUILayout.TextField(_EffectpsoPath);
            
             _EffectMove.PlaceGo = (GameObject)EditorGUILayout.ObjectField("放置点",_EffectMove.PlaceGo, typeof(GameObject), true);
            if (GUILayout.Button("读取"))
            {
                PSO = AssetDatabase.LoadAssetAtPath<EffectMoveScriptableobject>(_EffectpsoPath);
                _EffectMove.effectlist = PSO._positionList;
                buttonUI();
            }
            _deleteIndex = -1;
            buttonUI();
            if (_deleteIndex != -1) _EffectMove.effectlist.RemoveAt(_deleteIndex);
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("添加特效"))
            {
                _EffectMove.effectlist.Add(new effectmov());
               
            }
            EditorGUILayout.EndHorizontal();
            GUILayout.Space(50);
            serializedObject.ApplyModifiedProperties();
            EditorUtility.SetDirty(_EffectMove);
            if (GUI.changed && EditorApplication.isPlaying == false) EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }

        public void buttonUI()
        {
            for (int j = 0; j < _EffectMove.effectlist.Count; j++)
            {
                _effectmov = _EffectMove.effectlist[j];
                EditorGUILayout.BeginHorizontal();
                GUILayout.Box("精灵名", GUILayout.Width(50));
                _effectmov.ElfName = EditorGUILayout.TextField(_effectmov.ElfName);
                GUILayout.Box("特效", GUILayout.Width(50));
                _effectmov.EffectGo = (GameObject)EditorGUILayout.ObjectField(_effectmov.EffectGo, typeof(GameObject), true);
                GUILayout.Box("节点名", GUILayout.Width(50));
                _effectmov.NodeName = EditorGUILayout.TextField(_effectmov.NodeName);
                if (GUILayout.Button("查找节点"))
                {

                    GameObject go = GameObject.Find(_effectmov.NodeName);
                    Selection.activeGameObject = go;
                }
                if (GUILayout.Button("移动"))
                {
                    moveEffect(_EffectMove.PlaceGo, _effectmov.EffectGo, _effectmov.NodeName);
                }

                if (GUILayout.Button("保存"))
                {
                    effecTra = moveEffect(_EffectMove.PlaceGo, _effectmov.EffectGo, _effectmov.NodeName);
                    _effectmov._localPosition = effecTra.localPosition;
                    _effectmov._position = effecTra.position;
                    _effectmov._rotation = effecTra.rotation;
                    _effectmov._localRotation = effecTra.localRotation;
                    _effectmov._localScale = effecTra.localScale;

                    SaveEffectmov(_effectmov);
                    //if (EditorApplication.isPlaying)
                    //{
                    _effecInformation = _effectmov;
                    EditorApplication.delayCall += CreateScriptableObject;
                    //}
                    Debug.Log("保存成功");
                }
                //_effectmov.EffectGo = EditorGUILayout.ObjectField(_effectmov.EffectGo);
                if (GUILayout.Button("删除"))
                {
                    if (EditorUtility.DisplayDialog("警告", "你确定要删除当前保存的位置信息吗？", "确定", "取消"))
                    {
                        _deleteIndex = j;
                    }
                }

                EditorGUILayout.EndHorizontal();
                GUILayout.Space(10);
            }
        }
        public Transform moveEffect(GameObject plago,GameObject eff,string name)
        {
            GameObject par = GameObject.Find(name);
            GameObject a = Instantiate(eff);//实例化物体
            a.transform.parent = plago.transform;
            a.transform.localPosition = eff.transform.localPosition;
            a.transform.localRotation = eff.transform.localRotation;
            a.transform.localScale = eff.transform.localScale;
            a.transform.parent = par.transform;
            return a.transform;
        }




        /// <summary>
        /// 保存位置
        /// </summary>
        /// <param name="information"></param>
        private void SaveEffectmov(effectmov information)
        {
            _effecInformation = _effectmov;
            AssetDatabase.SaveAssets();
        }
        
        /// <summary>
        /// 创建序列化脚本对象
        /// </summary>
        private void CreateScriptableObject()
        {
            if (PSO == null)
            {
                PSO = AssetDatabase.LoadAssetAtPath<EffectMoveScriptableobject>(_EffectpsoPath);
                if (PSO == null)
                {
                    PSO = ScriptableObject.CreateInstance<EffectMoveScriptableobject>();
                    AssetDatabase.CreateAsset(PSO, _EffectpsoPath);
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                }
                //PSO._positionList.Clear();
            }
            effectmov t = PSO._positionList.Find(n => n.ElfName == _effecInformation.ElfName);
            if (t != null) PSO._positionList.Remove(t);
            PSO._positionList.Add(_effecInformation);
            AssetDatabase.SaveAssets();
        }

    }
}
