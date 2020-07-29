#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace RoleMaterialNameSpace
{
    public class MaterialSetting : EditorWindow
    {
        int toolbarInt = 0;
        string[] toolbarStrings = new string[] { "ABC材质配置", "一键复制粘贴材质球" };

        [MenuItem("Tools/材质设置")]
        public static void BuildAssetBundle()
        {
            var win = GetWindow<MaterialSetting>("材质设置");
            win.Show();
        }
        //材质配置
        #region  

        public string DataPath = "Assets/Tools/MaterialSetting/Data/材质配置.asset";
        [SerializeField]//必须要加  
        public List<RoleMaterials> _assetLst = new List<RoleMaterials>();

        //序列化对象  
        protected SerializedObject _serializedObject;

        //序列化属性  
        protected SerializedProperty _assetLstProperty;
        #endregion

        //拷贝材质
        #region 
        public string CopyDataPath = "Assets/Tools/MaterialSetting/Data/拷贝材质配置.asset";
        public string ReadDataPath = "Assets/Tools/MaterialSetting/Data/拷贝材质配置.asset";

        [SerializeField]
        protected List<Material> copymaterials;

        //序列化对象
        protected SerializedObject _serializedcopyMaterial;

        //序列化属性
        protected SerializedProperty _copyMaterialassetLstProperty;
        #endregion

        protected void OnEnable()
        {
            //使用当前类初始化  
            _serializedObject = new SerializedObject(this);
            //获取当前类中可序列话的属性  
            _assetLstProperty = _serializedObject.FindProperty("_assetLst");

            //拷贝材质
            _serializedcopyMaterial = new SerializedObject(this);
            _copyMaterialassetLstProperty = _serializedcopyMaterial.FindProperty("copymaterials");
        }

        protected void OnGUI()
        {

            GUILayout.Space(10f);
            toolbarInt = GUILayout.Toolbar(toolbarInt, toolbarStrings);
            switch (toolbarInt)
            {
                case 0:
                    abc();
                    break;
                case 1:
                    copyUI();
                    break;
      
            }

            
        }

        //材质数据UI
        private void abc()
        {
            //更新  
            _serializedObject.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            DataPath = EditorGUILayout.TextField("数据路径", DataPath);
            GUILayout.BeginHorizontal();
            
            if (GUILayout.Button("保存数据", GUILayout.Height(30)))
            {
                var RoleMaterialSaveData = ScriptableObject.CreateInstance<RoleMaterialSave>();

                RoleMaterialSaveData._assetLst = _assetLst;

                AssetDatabase.CreateAsset(RoleMaterialSaveData, DataPath);
                AssetDatabase.SaveAssets();
            }
            if (GUILayout.Button("读取数据", GUILayout.Height(30)))
            {

                var RoleMaterialSaveData = AssetDatabase.LoadAssetAtPath<RoleMaterialSave>(DataPath);
                _assetLst = RoleMaterialSaveData._assetLst;

            }
            if (GUILayout.Button("修改模型材质", GUILayout.Height(30)))
            {
                Onmaterial();
            }
            GUILayout.EndHorizontal();
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_assetLstProperty, true);

            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {//提交修改  
                _serializedObject.ApplyModifiedProperties();
            }
        }

        //复制材质UI
        private void copyUI()
        {
            //GUILayout.BeginVertical("box", GUILayout.Width(330));
            GUILayout.Label("复制材质");
            //更新
            _serializedcopyMaterial.Update();
            //开始检查是否有修改
            EditorGUI.BeginChangeCheck();

            GUILayout.BeginHorizontal();
            if (GUILayout.Button("一键拷贝材质", GUILayout.Height(30)))
            {
                copymaterial();
            }
            if (GUILayout.Button("一键上材质", GUILayout.Height(30)))
            {
                pastematerial();
            }
            GUILayout.EndHorizontal();
            GUILayout.BeginHorizontal();
            
            if (GUILayout.Button("备份拷贝材质", GUILayout.Height(30), GUILayout.Width(85)))
            {
                var CopyMaterialSaveData = ScriptableObject.CreateInstance<CopyMaterialSave>();

                CopyMaterialSaveData.copymaterials = copymaterials;

                AssetDatabase.CreateAsset(CopyMaterialSaveData, CopyDataPath);
                AssetDatabase.SaveAssets();
            }
            CopyDataPath = EditorGUILayout.TextField("备份材质路径", CopyDataPath);
            GUILayout.EndHorizontal();
            GUILayout.BeginHorizontal();           
            if (GUILayout.Button("读取备份材质", GUILayout.Height(30),GUILayout.Width(85)))
            {
                var CopyMaterialSaveData = AssetDatabase.LoadAssetAtPath<CopyMaterialSave>(ReadDataPath);
                copymaterials = CopyMaterialSaveData.copymaterials;
            }
            ReadDataPath = EditorGUILayout.TextField("读取备份材质路径", ReadDataPath);
            GUILayout.EndHorizontal();

            //显示属性
            //第二个参数必须为true，否则无法显示子节点即List内容
            EditorGUILayout.PropertyField(_copyMaterialassetLstProperty, true);

            //结束检查是否有修改
            if (EditorGUI.EndChangeCheck())
            {
                //提交修改
                _serializedcopyMaterial.ApplyModifiedProperties();

            }
            
           // GUILayout.EndVertical();
        }

        private void Onmaterial()
        {
            if (Selection.activeTransform != null)
            {
                
                Transform[] father = Selection.activeTransform.GetComponentsInChildren<Transform>();
                foreach (var child in father)
                {
                    for (int i = 0; i < _assetLst.Count; i++)
                    {
                        for (int j = 0; j < _assetLst[i].roleParts.Count; j++)
                        {
                            if (child.name == _assetLst[i].roleParts[j].RolePartsName)
                            {
                                for (int k = 0; k < _assetLst[i].roleParts[j].RolePartMaterials.Count; k++)
                                {
                                    if (_assetLst[i].roleParts[j].RolePartMaterials.Count > 1)
                                    {
                                        Material[] materials = new Material[_assetLst[i].roleParts[j].RolePartMaterials.Count];
                                        for (int m = 0; m < materials.Length; m++)
                                        {
                                            materials[m] = _assetLst[i].roleParts[j].RolePartMaterials[m];
                                        }
                                        if (child.GetComponent<MeshRenderer>() != null)
                                        {
                                            child.GetComponent<MeshRenderer>().sharedMaterials = materials;
                                        }
                                        if (child.GetComponent<SkinnedMeshRenderer>() != null)
                                        {
                                            child.GetComponent<SkinnedMeshRenderer>().sharedMaterials = materials;
                                        }

                                    }
                                    else
                                    {
                                        if (child.GetComponent<MeshRenderer>() != null)
                                        {
                                            child.GetComponent<MeshRenderer>().sharedMaterial = _assetLst[i].roleParts[j].RolePartMaterials[0];
                                        }
                                        if (child.GetComponent<SkinnedMeshRenderer>() != null)
                                        {
                                            child.GetComponent<SkinnedMeshRenderer>().sharedMaterial = _assetLst[i].roleParts[j].RolePartMaterials[0];
                                        }
                                    }
                                    


                                }
                               
                            }
                        }
                        
                    }
    
                }

            }
        }

        //拷贝材质
        private void copymaterial()
        {
            if (Selection.activeTransform != null)
            {

                copymaterials = new List<Material>();
                //Debug.Log(Selection.activeTransform.name);
                Transform[] father = Selection.activeTransform.GetComponentsInChildren<Transform>();
                foreach (var child in father)
                {
                    if (child.GetComponent<MeshRenderer>() != null)
                    {

                        int mL = child.GetComponent<MeshRenderer>().sharedMaterials.Length;
                        if (mL > 1)
                        {
                            for (int i = 0; i < mL; i++)
                            {
                                copymaterials.Add(child.GetComponent<MeshRenderer>().sharedMaterials[i]);

                            }
                        }
                        else
                        {
                            copymaterials.Add(child.GetComponent<MeshRenderer>().sharedMaterial);

                        }
                    }
                    if (child.GetComponent<SkinnedMeshRenderer>() != null)
                    {

                        int mL = child.GetComponent<SkinnedMeshRenderer>().sharedMaterials.Length;
                        if (mL > 1)
                        {
                            for (int i = 0; i < mL; i++)
                            {
                                copymaterials.Add(child.GetComponent<SkinnedMeshRenderer>().sharedMaterials[i]);

                            }
                        }
                        else
                        {
                            copymaterials.Add(child.GetComponent<SkinnedMeshRenderer>().sharedMaterial);

                        }
                    }
                }

        
            }
        }

        //粘贴材质
        private void pastematerial()
        {
            if (Selection.activeTransform != null)
            {
                int k = 0;
                Transform[] father = Selection.activeTransform.GetComponentsInChildren<Transform>();
                foreach (var child in father)
                {
                    if (child.GetComponent<MeshRenderer>() != null)
                    {
                        int mL = child.GetComponent<MeshRenderer>().sharedMaterials.Length;
                        if (mL > 1)
                        {

                            Material[] materials = new Material[mL];
                            for (int i = 0; i < mL; i++)
                            {
                                materials[i] = copymaterials[k];
                                k++;
                            }
                            child.GetComponent<MeshRenderer>().sharedMaterials = materials;
                        }
                        else
                        {
                            child.GetComponent<MeshRenderer>().sharedMaterial = copymaterials[k];
                            k++;
                        }
                    }

                    if (child.GetComponent<SkinnedMeshRenderer>() != null)
                    {
                        int mL = child.GetComponent<SkinnedMeshRenderer>().sharedMaterials.Length;
                        if (mL > 1)
                        {

                            Material[] materials = new Material[mL];
                            for (int i = 0; i < mL; i++)
                            {
                                materials[i] = copymaterials[k];
                                k++;
                            }
                            child.GetComponent<SkinnedMeshRenderer>().sharedMaterials = materials;
                        }
                        else
                        {
                            child.GetComponent<SkinnedMeshRenderer>().sharedMaterial = copymaterials[k];
                            k++;
                        }
                    }
                }

            }
        }

    }
}
#endif