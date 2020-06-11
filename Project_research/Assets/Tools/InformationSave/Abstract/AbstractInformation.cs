using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Babybus.UtilityTools
{
    public abstract class AbstractInformation<T> : CustomEditorBase where T : InformationBase, new()
    {
        [HideInInspector] public List<T> _list = new List<T>();

        public virtual void Add()
        {
            _list.Add(new T());
            Save(_list.Count - 1);
        }

        public abstract void Save(int index);
        public abstract void Switch(int index);

        public virtual void Delete(int index)
        {
            _list.RemoveAt(index);
        }

        public virtual void Set(string desc)
        {
            int index = _list.FindIndex(n => n.desc == desc);
            if (index != -1) Switch(index);
        }

        #region Editor

#if UNITY_EDITOR
        private string _path;
        private string _directoryPath;
        private readonly IDataDispose _dataDispose = new XMLDataDispose();

        private void SetPath()
        {
            _directoryPath = Application.persistentDataPath + "/Ignore";
            _path = _directoryPath + "/" + gameObject.GetInstanceID().ToString() + ToString() + ".xml";
        }

        //更新
        public void UpdateInformation()
        {
            SetPath();
            if (File.Exists(_path) == false)
            {
                Debug.LogError("不存在更新文件:" + _path);
                return;
            }

            List<T> tempList = _dataDispose.Read<List<T>>(_path);
            if (tempList != null && tempList.Count > 0)
            {
                _list.Clear();
                _list.AddRange(tempList);
                Debug.Log("更新成功!");
            }
        }

        //动态保存
        public bool PlayingSave()
        {
            if (UnityEditor.EditorApplication.isPlaying)
            {
                SetPath();
                if (Directory.Exists(_directoryPath) == false) Directory.CreateDirectory(_directoryPath);
                _dataDispose.Write(_path, _list);
                Debug.Log("动态保存成功!");
                return true;
            }

            return false;
        }

        //绘制
        public override void Draw()
        {
            int length = _list.Count;
            int deleteIndex = -1;
            for (int i = 0; i < length; i++)
            {
                GUILayout.BeginHorizontal();
                _list[i].desc = UnityEditor.EditorGUILayout.TextField(_list[i].desc);
                if (GUILayout.Button("切换")) Switch(i);
                if (GUILayout.Button("保存"))
                {
                    Save(i);
                    if (PlayingSave() == false) Debug.Log("保存成功!");
                }

                if (GUILayout.Button("上移") && i > 0)
                {
                    T temp = _list[i - 1];
                    _list[i - 1] = _list[i];
                    _list[i] = temp;
                }

                if (GUILayout.Button("下移") && i < _list.Count - 1)
                {
                    T temp = _list[i + 1];
                    _list[i + 1] = _list[i];
                    _list[i] = temp;
                }

                if (GUILayout.Button("删除") && UnityEditor.EditorUtility.DisplayDialog("警告", "你确定要删除吗？", "确定", "取消"))
                    deleteIndex = i;
                GUILayout.EndHorizontal();
                if (i != length - 1) GUILayout.Space(20);
            }

            if (deleteIndex != -1) Delete(deleteIndex);
            GUILayout.Space(30);
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("添加"))
            {
                Add();
            }

            if (GUILayout.Button("更新") && UnityEditor.EditorUtility.DisplayDialog("提示", "你确定要更新吗？", "确定", "取消"))
            {
                UpdateInformation();
            }

            GUILayout.EndHorizontal();
        }
#else
    public override void Draw(){}
#endif
    }

    #endregion

    [System.Serializable]
    public class InformationBase
    {
        public string desc = "初始";
    }
}
