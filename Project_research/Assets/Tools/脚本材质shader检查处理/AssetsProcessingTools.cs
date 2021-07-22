#if UNITY_EDITOR
using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Linq;
using UnityEditor.SceneManagement;
using UnityEngine.SceneManagement;

using Object = UnityEngine.Object;

namespace BabybusOptimizationTools
{
    public class AssetsProcessingTools : EditorWindow
    {
        int toolbarInt = 0;
        string[] toolbarStrings = new string[] {"shader检查修改", "数据保存读取", "shader差异查找" , "脚本引用查找" };
        Vector2 scrollPosition;
        Vector2 scrollPosition2;
        Vector2 scrollPosition3;
        Vector2 scrollPosition4;
        
        [System.Serializable]
        public class PrefabsRef
        {
            public GameObject PrefabsRefGO;
            public List<string> PrefabsRefName;
        }
        
        [System.Serializable]
        public class ScenesRef
        {
            public SceneAsset _Scenes;
            public List<string> _ScenesRefName;
        }
        
        
        [SerializeField]
        public List<Material> _ErrorMaterialAssetLst = new List<Material>();
        //序列化对象  
        protected SerializedObject _serializedMaterial;
        //序列化属性  
        protected SerializedProperty _MaterialAssetLstProperty;
        
        
        [SerializeField]//必须要加  
        public List<Shader> _FrameworkshaderAssetLst = new List<Shader>();
        //序列化对象  
        protected SerializedObject _serializedShader;
        //序列化属性  
        protected SerializedProperty _ShaderAssetLstProperty;
        
        [SerializeField]//必须要加  
        public List<Shader> _ResultshaderAssetLst = new List<Shader>();
        //序列化对象  
        protected SerializedObject _serializedResultShader;
        //序列化属性  
        protected SerializedProperty _ResultShaderAssetLstProperty;
        
        [SerializeField]//必须要加  
        public List<PrefabsRef> _PrefabsAssetList = new List<PrefabsRef>();
        //序列化对象  
        protected SerializedObject _serializedPrefabs;
        //序列化属性  
        protected SerializedProperty _PrefabsAssetLstProperty;
        
        [SerializeField]//必须要加  
        public List<ScenesRef> _ScenesList = new List<ScenesRef>();
        //序列化对象  
        protected SerializedObject _serializedScenes;
        //序列化属性  
        protected SerializedProperty _PrefabsScenesLstProperty;
        
        
        [SerializeField]//必须要加  
        public List<MonoScript> _ScriptList = new List<MonoScript>();
        //序列化对象  
        protected SerializedObject _serializedScript;
        //序列化属性  
        protected SerializedProperty _ScriptLstProperty;
        
        
        
        
        
        public string ShaderDataPath = "Assets/Tools/脚本材质shader检查处理/Data/shader备份.asset";
        public string ShaderSavePath = "Assets/_Shader/Old/";
        
        [MenuItem("Tools/资源优化检查处理工具")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(AssetsProcessingTools));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.titleContent.text = "资源优化检查处理工具";
        }

        protected void OnEnable()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
            SceneView.onSceneGUIDelegate += this.OnSceneGUI;
            //使用当前类初始化
            _serializedMaterial = new SerializedObject(this);
            //获取当前类中可序列话的属性        
            _MaterialAssetLstProperty = _serializedMaterial.FindProperty("_ErrorMaterialAssetLst");
            
            //使用当前类初始化
            _serializedShader = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _ShaderAssetLstProperty = _serializedShader.FindProperty("_FrameworkshaderAssetLst");
            
            //使用当前类初始化
            _serializedResultShader = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _ResultShaderAssetLstProperty = _serializedResultShader.FindProperty("_ResultshaderAssetLst");
            
            //使用当前类初始化
            _serializedPrefabs = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _PrefabsAssetLstProperty = _serializedPrefabs.FindProperty("_PrefabsAssetList");
            
            //使用当前类初始化
            _serializedScenes = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _PrefabsScenesLstProperty = _serializedPrefabs.FindProperty("_ScenesList");
            
            //使用当前类初始化
            _serializedScript = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _ScriptLstProperty = _serializedPrefabs.FindProperty("_ScriptList");
            

            
            
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
            toolbarInt = GUILayout.Toolbar(toolbarInt, toolbarStrings, GUILayout.Height(50));
            switch (toolbarInt)
            {
                case 0:
                    ShaderCheckUI();
                    break;
                case 1:
                    SaveDataUI();
                    break;
                case 2:
                    ChangeshaderUI();
                    break;
                case 3:
                    FindScriptRefUI();
                    break;
            }

        }
        
        //材质检查处理UI
        #region
        private void ShaderCheckUI()
        {
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("材质shader检查");
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("材质shader检查", GUILayout.Width(200), GUILayout.Height(30)))
            {

                MaterilasShadercheck();

            }
            if (GUILayout.Button("搜索Standard & Particles standard", GUILayout.Width(200), GUILayout.Height(30)))
            {

                FindStandardshader();

            }
            GUILayout.EndHorizontal();
            GUILayout.EndVertical();
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("材质shader切换");
            if (GUILayout.Button("对下列材质列表进行特殊差异shader切换", GUILayout.Width(400),GUILayout.Height(30)))
            {
                ResultChangespecialshader();
            }

            if (GUILayout.Button("对下列材质列表相同名字shader切换", GUILayout.Width(400),GUILayout.Height(30)))
            {
                //SameShaderChange();
            }
            GUILayout.EndVertical();

            //===============================
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("问题shader材质列表");
            //更新  
            _serializedMaterial.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            scrollPosition = GUILayout.BeginScrollView(scrollPosition);
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_MaterialAssetLstProperty, true);
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedMaterial.ApplyModifiedProperties();
            }

            GUILayout.EndVertical();
            //===================================================


        }
        #endregion
        
        //数据保存读取UI
        #region
        private void SaveDataUI()
        {
            //===============================
            //GUILayout.BeginVertical();
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("shader备份数据");
            //更新  
            _serializedShader.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            ShaderDataPath = EditorGUILayout.TextField("shader备份数据路径", ShaderDataPath);
            GUILayout.BeginHorizontal();

            if (GUILayout.Button("保存数据", GUILayout.Height(30)))
            {
                var ShaderSave = ScriptableObject.CreateInstance<ShaderListSave>();

                ShaderSave._FrameworkshaderAssetLst = _FrameworkshaderAssetLst;

                AssetDatabase.CreateAsset(ShaderSave, ShaderDataPath);
                AssetDatabase.SaveAssets();
            }
            if (GUILayout.Button("读取数据", GUILayout.Height(30)))
            {

                var ShaderSave = AssetDatabase.LoadAssetAtPath<ShaderListSave>(ShaderDataPath);
                _FrameworkshaderAssetLst = ShaderSave._FrameworkshaderAssetLst;

            }

            GUILayout.EndHorizontal();
            scrollPosition2 = GUILayout.BeginScrollView(scrollPosition2);
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_ShaderAssetLstProperty, true);
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedShader.ApplyModifiedProperties();
            }
            GUILayout.EndVertical();
            //===================================================
        }
        #endregion
        
        //shader差异查找UI
        #region
        private void ChangeshaderUI()
        {
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("shader检查");
            
           
            //更新  
            _serializedResultShader.Update();
            ShaderSavePath = EditorGUILayout.TextField("shader移动地址", ShaderSavePath);
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("对应文件夹shader查找", GUILayout.Height(30)))
            {
                FindShader();
            }
            if (GUILayout.Button("将下列shader移动到上面地址", GUILayout.Height(30)))
            {
                MoveShader();
            }
            GUILayout.EndHorizontal();
            if (GUILayout.Button("下列shader被哪些材质引用，查找结果在shader检查中的材质列表中", GUILayout.Height(30)))
            {
                shaderFindMaterial();
            }
           
            
            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            scrollPosition3 = GUILayout.BeginScrollView(scrollPosition3);
            EditorGUILayout.PropertyField(_ResultShaderAssetLstProperty, true);
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedResultShader.ApplyModifiedProperties();
            }
            GUILayout.EndVertical();
            
           
            //===================================================
        }
        #endregion
        
        //脚本引用查找UI
        #region
        MonoScript scriptObj = null;
        private void FindScriptRefUI()
        {
            //===============================
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("脚本引用");
            //更新  
            _serializedPrefabs.Update();
            _serializedScenes.Update();
            _serializedScript.Update();
            
            scriptObj = (MonoScript)EditorGUILayout.ObjectField(scriptObj, typeof(MonoScript), true);
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("脚本Assets下引用查找", GUILayout.Height(30)))
            {
                FindScript(scriptObj);
            }
            if (GUILayout.Button("脚本Scenes引用查找", GUILayout.Height(30)))
            {
                FindScriptinscenes();
            }
            if (GUILayout.Button("文件夹下所有脚本", GUILayout.Height(30)))
            {
                FindScriptinFile();
            }
            GUILayout.EndHorizontal();
            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            scrollPosition4 = GUILayout.BeginScrollView(scrollPosition4);
            EditorGUILayout.PropertyField(_PrefabsAssetLstProperty, true);
            EditorGUILayout.PropertyField(_PrefabsScenesLstProperty, true);
            EditorGUILayout.PropertyField(_ScriptLstProperty, true);
            
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedPrefabs.ApplyModifiedProperties();
                _serializedScenes.ApplyModifiedProperties();
                _serializedScript.ApplyModifiedProperties();
            }
            GUILayout.EndVertical();
            
            //===================================================
        }
        #endregion
        
        
        //材质检查处理
        #region

        private bool checkShader = false;
       
        private void MaterilasShadercheck()
        {
            Object[] Materilas = GetSelectedMaterilas();
            if (Materilas.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含材质球的文件夹或者单独材质球！", "OK");
                return;
            }
            var ShaderSave = AssetDatabase.LoadAssetAtPath<ShaderListSave>(ShaderDataPath);
            _FrameworkshaderAssetLst = ShaderSave._FrameworkshaderAssetLst;
            List<Material> ErrShaderMaterial = new List<Material>();
            List<Shader> ErrShader = new List<Shader>();
            
            foreach (Material material in Materilas)
            {
                foreach (Shader shader in _FrameworkshaderAssetLst)
                {
                    if (material.shader == shader)
                    {
                        checkShader = false;
                        break;
                    }
                    else
                    {
                        checkShader = true;
                    }
                }
                if(checkShader == true)
                {
                    ErrShaderMaterial.Add(material);
                    ErrShader.Add(material.shader);
                    checkShader = false;
                }
            }
            _ErrorMaterialAssetLst = ErrShaderMaterial;
            //去掉重复引用shader
            for (int i = 0; i < ErrShader.Count; i++)  //外循环是循环的次数
            {
                for (int j = ErrShader.Count - 1 ; j > i; j--)  //内循环是 外循环一次比较的次数
                {

                    if (ErrShader[i] == ErrShader[j])
                    {
                        ErrShader.RemoveAt(j);
                    }

                }
            }
            _ResultshaderAssetLst = ErrShader;
            
            if (ErrShaderMaterial.Count > 0)
            {
  
                EditorUtility.DisplayDialog("结果：警告", "有不符合的shader！", "OK");  
            }
            else
            {
                EditorUtility.DisplayDialog("结果：", "所选Shader都符合", "OK");
            }
            
        }


        private void FindStandardshader()
        {
            Object[] Materilas = GetSelectedMaterilas();
            if (Materilas.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含材质球的文件夹或者单独材质球！", "OK");
                return;
            }

            List<Material> ErrShaderMaterial = new List<Material>();

            foreach (Material material in Materilas)
            {

                if(material.shader.name == "Standard" || material.shader.name == "Standard (Specular setup)" || material.shader.name == "Particles/Standard Unlit" || material.shader.name == "Particles/Standard Surface")
                {
                  
                    ErrShaderMaterial.Add(material);       
                }          
                
            }
            _ErrorMaterialAssetLst = ErrShaderMaterial;

            if (ErrShaderMaterial.Count > 0)
            {              
               
                EditorUtility.DisplayDialog("结果：警告", "有不符合的shader！", "OK");  
            }
            else
            {
                EditorUtility.DisplayDialog("结果：", "所选Shader都符合", "OK");
            }
            
        }

        //材质特殊对应shader修改
        private void ResultChangespecialshader()
        {
         
            if (_ErrorMaterialAssetLst.Count == 0)
            {
                EditorUtility.DisplayDialog("警告", "材质列表是空的！", "OK");
                return;
            }
            foreach (Material material in _ErrorMaterialAssetLst)
            {
                int MatRenderQueueint = material.renderQueue;
                if(material.shader.name == "Babybus/Particles/Additive Color")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",1f);                   
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }

                if(material.shader.name == "Babybus/Particles/Old/Additive Color")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",1f);                   
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }

                if(material.shader.name == "Babybus/Particles/Additive Color1")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",1f);                   
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }
                if(material.shader.name == "Babybus/Particles/Additive")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",1f); 
                    material.SetColor("_TintColor",Color.white);        
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }

                if(material.shader.name == "Babybus/Particles/Alpha Blended Color")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",10f);                   
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }

                if(material.shader.name == "Babybus/Particles/Alpha Blended Color1")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",10f);                   
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }
                
                if(material.shader.name == "Babybus/Particles/Old/Alpha Blended Color")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",10f);                   
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }

                if(material.shader.name == "Legacy Shaders/Particles/Alpha Blended")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",10f);                   
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }

                if (material.shader.name == "Legacy Shaders/Particles/Alpha Blended Premultiply")
                {
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if (item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    }
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend", 10f);
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest", ZTest);
                }

                if (material.shader.name == "Legacy Shaders/Particles/Additive")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",1f);        
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);         
                }

                if (material.shader.name == "Legacy Shaders/Particles/Additive (Soft)")
                {
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if (item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    }
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend", 1f);
                    material.SetColor("_TintColor", new Color(0.4f,0.4f,0.4f,0.4f));
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest", ZTest);
                }

                if (material.shader.name == "Babybus/Particles/Alpha Blended")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    } 

                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",10f);
                    material.SetColor("_TintColor",Color.white);                                      
                    material.renderQueue = MatRenderQueueint;
                     material.SetFloat("_ZTest",ZTest);       
                }

                if (material.shader.name == "Mobile/Particles/Alpha Blended")
                {
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if (item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    }

                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend", 10f);
                    //material.SetColor("_TintColor", Color.white);
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest", ZTest);
                }

                if (material.shader.name == "Mobile/Particles/Additive")
                {
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if (item.name == "Babybus/Particles/Color Texture")
                        {
                            material.shader = item;
                        }
                    }

                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend", 1f);
                    //material.SetColor("_TintColor", Color.white);
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest", ZTest);
                }

                if (material.shader.name == "Babybus/Particles/MaskTexture Dissolve Blend(customDataUV)")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/MaskTexture Dissolve(customDataUV)")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",10f);                                     
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest",ZTest);       
                }

                if (material.shader.name == "Babybus/Particles/Alpha Blended 2Mask(customDataUV)")
                {
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if (item.name == "Babybus/Particles/2Mask(customDataUV)")
                        {
                            material.shader = item;
                        }
                    }
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend", 10f);
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest", ZTest);
                }

                if (material.shader.name == "Babybus/Particles/Additive Mask")
                {     
                    Texture mtTex = material.GetTexture("_Mask");
                    Vector2 Offset = material.GetTextureOffset("_Mask");
                    Vector2 Tilling = material.GetTextureScale("_Mask");
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Particle Alpha distorted Mask")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",1f);                   
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest",ZTest);
                    material.SetFloat("_IntensityX",0f); 
                    material.SetFloat("_IntensityY",0f); 
                    material.SetTexture("_MaskTex",mtTex);
                    material.SetTextureOffset("_MaskTex",Offset);
                    material.SetTextureScale("_MaskTex",Tilling);
                    
                }
                
                if(material.shader.name == "Babybus/Particles/Alpha Blended Mask")
                {     
                    Texture mtTex = material.GetTexture("_Mask");
                    Vector2 Offset = material.GetTextureOffset("_Mask");
                    Vector2 Tilling = material.GetTextureScale("_Mask");
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Particle Alpha distorted Mask")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",10f);                   
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest",ZTest);
                    material.SetFloat("_IntensityX",0f); 
                    material.SetFloat("_IntensityY",0f); 
                    material.SetTexture("_MaskTex",mtTex);
                    material.SetTextureOffset("_MaskTex",Offset);
                    material.SetTextureScale("_MaskTex",Tilling);
                }

                if(material.shader.name == "Babybus/Particles/Alpha Blended Mask(customDataUV)")
                {     
                    Texture mtTex = material.GetTexture("_Mask");
                    Vector2 Offset = material.GetTextureOffset("_Mask");
                    Vector2 Tilling = material.GetTextureScale("_Mask");
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Particle Alpha distorted Mask(customDataUV)")
                        {
                            material.shader = item;
                        }
                    } 
                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",10f);                   
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest",ZTest);
                    material.SetFloat("_IntensityX",0f); 
                    material.SetFloat("_IntensityY",0f); 
                    material.SetTexture("_MaskTex",mtTex);
                    material.SetTextureOffset("_MaskTex",Offset);
                    material.SetTextureScale("_MaskTex",Tilling);
                }

                if(material.shader.name == "Babybus/Particles/Additive Mask(customDataUV)")
                {     
                    Texture mtTex = material.GetTexture("_Mask");
                    Vector2 Offset = material.GetTextureOffset("_Mask");
                    Vector2 Tilling = material.GetTextureScale("_Mask");

                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Particles/Particle Alpha distorted Mask(customDataUV)")
                        {
                            material.shader = item;
                        }
                    } 

                    float ZTest = material.GetFloat("_ZTest");
                    material.SetFloat("_DstBlend",1f);                   
                    material.renderQueue = MatRenderQueueint;
                    material.SetFloat("_ZTest",ZTest);
                    material.SetFloat("_IntensityX",0f); 
                    material.SetFloat("_IntensityY",0f); 
                    material.SetTexture("_MaskTex",mtTex);
                    material.SetTextureOffset("_MaskTex",Offset);
                    material.SetTextureScale("_MaskTex",Tilling);
                }


                if(material.shader.name == "Unlit/Texture")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Unlit/Texture")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }

                if(material.shader.name == "Babybus/Texture")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Unlit/Texture")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }

                if(material.shader.name == "Babybus/Soft Edge Unlit")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Cutout/Soft Edge Unlit")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }

                if(material.shader.name == "Babybus/Color Soft Edge Unlit")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Cutout/Color Soft Edge Unlit")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }

                if(material.shader.name == "Unlit/Soft Edge Unlit")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Cutout/Color Soft Edge Unlit")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }

                if(material.shader.name == "Babybus/Transparent")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Unlit/Transparent")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }

                if(material.shader.name == "Unlit/Transparent")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Unlit/Transparent")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }

                if(material.shader.name == "Babybus/Color Transparentt")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Unlit/Color Transparentt")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }
                
                if(material.shader.name == "Mobile/Diffuse")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Mobile/Diffuse")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
     
                }
                if(material.shader.name == "Legacy Shaders/Diffuse")
                {     
                    foreach (var item in _FrameworkshaderAssetLst)
                    {
                        if(item.name == "Babybus/Mobile/Color Diffuse")
                        {
                            material.shader = item;
                        }
                    }                 
                    material.renderQueue = MatRenderQueueint;
                }

            }
        }
        
        //相同名字shader切换
        private void SameShaderChange()
        {
         
            if (_ErrorMaterialAssetLst.Count == 0)
            {
                EditorUtility.DisplayDialog("警告", "材质列表是空的！", "OK");
                return;
            }
            foreach (Material material in _ErrorMaterialAssetLst)
            {

                for (int i = 0; i < _FrameworkshaderAssetLst.Count; i++)
                {
                    if (material.shader.name == _FrameworkshaderAssetLst[i].name)
                    {
                        if (material.shader != _FrameworkshaderAssetLst[i])
                        {
                            int RenderQueueint = material.renderQueue;
                            material.shader = _FrameworkshaderAssetLst[i];
                            material.renderQueue = RenderQueueint;
                        }

                    }

                }

            }
        }
        
        static Object[] GetSelectedShaders()
        {

            return Selection.GetFiltered(typeof(Shader), SelectionMode.DeepAssets);
        }


        static Object[] GetSelectedMaterilas()
        {

            return Selection.GetFiltered(typeof(Material), SelectionMode.DeepAssets);
        }

        #endregion
        
        
        //查找文件夹内shader
        #region
        private void FindShader()
        {
            Object[] Shaders = GetSelectedShaders();
            if (Shaders.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含Shder的文件夹！", "OK");
                return;
            }
            List<Shader> ErrShader = new List<Shader>();
            foreach (Shader shader in Shaders)
            {
                ErrShader.Add(shader);
            }
            _ResultshaderAssetLst = ErrShader;
            if (ErrShader.Count == 0)
            {
                EditorUtility.DisplayDialog("警告", "没有找到引用shader！", "OK");
            }
        }
        #endregion
        
        //将列表中shader移动到对应文件夹内
        #region
        public int num = 0;
        private void MoveShader()
        {
            if (_ResultshaderAssetLst !=null)
            {
                num = 0;
                foreach (Shader shader in _ResultshaderAssetLst)
                {
                    string path = AssetDatabase.GetAssetPath(shader);
                    string newpath =ShaderSavePath + path.Substring(path.LastIndexOf("/", StringComparison.Ordinal)+1);
                    moveassetShader(shader, path, newpath);
                }
                AssetDatabase.Refresh();
            }
            if (num != 0)
            {
                EditorUtility.DisplayDialog("警告", "引用shader有"+num+"个名字重复没移动", "OK");
            }
        }

        //移动shader
        private void moveassetShader(Shader shader, string path, string newpath)
        {
            
            if (path.StartsWith("Assets"))
            {
                
                if (!Directory.Exists(ShaderSavePath))
                {
                    Directory.CreateDirectory(ShaderSavePath);
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                    if (!File.Exists(newpath))
                    {
                        AssetDatabase.MoveAsset(path, newpath);
                        AssetDatabase.MoveAsset(path, newpath+ ".meta");
                    }
                    else
                    {
                        num += 1;
                    }
                   
                }
                else
                {
                    if (!File.Exists(newpath))
                    {
                        AssetDatabase.MoveAsset(path, newpath);
                        AssetDatabase.MoveAsset(path, newpath+ ".meta");
                    }
                    else
                    {
                        num += 1;
                    }
                }
            }
            
        }
        //通过shader查找使用shader的材质
        private void shaderFindMaterial()
        {
            Object[] Materilas = GetSelectedMaterilas();
            if (Materilas.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含材质球的文件夹或者单独材质球！", "OK");
                return;
            }
            List<Material> ErrShaderMaterial = new List<Material>();
            foreach (Material material in Materilas)
            {
                for (int i = 0; i < _ResultshaderAssetLst.Count; i++)
                {

                    if (material.shader == _ResultshaderAssetLst[i])
                    {
                        ErrShaderMaterial.Add(material);

                    }


                }
            }           
            _ErrorMaterialAssetLst = ErrShaderMaterial;
            if(ErrShaderMaterial.Count == 0)
            {
                EditorUtility.DisplayDialog("警告", "没有找到引用shader的材质！", "OK");
            }
        }
        #endregion
        
        
        //查找脚本引用
        #region
        void FindScript(MonoScript scriptObj)
        {
            var guids = AssetDatabase.FindAssets("t:GameObject");
            List<PrefabsRef> newPref = new List<PrefabsRef>();
            int j =  -1;
            bool boolAddPre = true;
            if (scriptObj != null)
            {
                for (int i = 0; i < guids.Length; i++)
                {
                    var path = AssetDatabase.GUIDToAssetPath(guids[i]);
                    if (path.EndsWith(".prefab"))
                    {
                        GameObject go = AssetDatabase.LoadAssetAtPath(path, typeof(System.Object)) as GameObject;
                        if (go != null)
                        {

                            Transform[] grandFa =  go.GetComponentsInChildren<Transform>();
                            
                            for (int k = 0; k < grandFa.Length; k++)
                            {
                               
                                if (grandFa[k].GetComponent(scriptObj.GetClass())  != null)
                                {
                                   // Debug.Log(path);
                                    if (boolAddPre)
                                    {
                                      
                                        newPref.Add(new PrefabsRef());
                                        j++;
                                        newPref[j].PrefabsRefName = new List<string>();
                                        boolAddPre = false;
                                       
                                    }
                                    newPref[j].PrefabsRefGO = go;
                                    newPref[j].PrefabsRefName.Add(grandFa[k].name);
                                }
                            }
                            boolAddPre = true;
                        }
                    }
                }
            }
            _PrefabsAssetList = newPref;

        }

        #endregion
       
        //查找脚本场景中引用
        #region
        
        void FindScriptinscenes()
        {
            
            string curScene = EditorApplication.currentScene;
            EditorApplication.SaveScene();
            List<ScenesRef> newSceref = new List<ScenesRef>();
            string[] scenes = AssetDatabase.FindAssets("t:Scene", new string[] { "Assets" });
            int j =  -1;
            foreach (var scene in scenes)
            {
                bool boolAddScenesRef = true;
                string resscene = AssetDatabase.GUIDToAssetPath(scene);
                //string fileName = Path.GetFileNameWithoutExtension(resscene);
                EditorApplication.OpenScene(resscene);
         
                foreach (GameObject obj in FindObjectsOfType<GameObject>())
                {
                    var cmp = obj.GetComponent(scriptObj.GetClass());
                    
                    if (cmp != null)
                    {
                        var sce = AssetDatabase.LoadAssetAtPath<SceneAsset>(resscene);
                        if (boolAddScenesRef)
                        {
                            newSceref.Add(new ScenesRef());
                            j++;
                            newSceref[j]._Scenes = sce;
                            newSceref[j]._ScenesRefName = new List<string>();
                            boolAddScenesRef = false;
                        }
                        newSceref[j]._ScenesRefName.Add(cmp.name);
                    }
                }
            }

            _ScenesList = newSceref;
            EditorApplication.OpenScene(curScene);
            Debug.Log ("finish");

        }

        #endregion
        
        //查找文件夹所有脚本
        #region
        void FindScriptinFile()
        {
            Object[] ScriptsLis = GetSelectedScriptin();
            if (ScriptsLis.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含脚本的文件夹！", "OK");
                _ScriptList = null;
                return;
            }
            List<MonoScript> newScript = new List<MonoScript>();
            foreach (MonoScript Script in ScriptsLis)
            {
                newScript.Add(Script);
            }
            _ScriptList = newScript;
            
        }
        static Object[] GetSelectedScriptin()
        {

            return Selection.GetFiltered(typeof(MonoScript), SelectionMode.DeepAssets);
        }
        
        #endregion
        
    }
}

#endif