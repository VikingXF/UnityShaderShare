//=============================================
//作者:XF
//描述:特效文件夹根据尺寸进行分类，检查分类尺寸是否不一致，检查特效材质是否使用非Babybus下的shader
//创建时间:2020/08/21 10:35:23
//版本:v 1.0
//=============================================
#if UNITY_EDITOR

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Linq;

namespace OptimizationTools
{
    public class EffectFileInspection : EditorWindow
    {
        int toolbarInt = 0;
        string[] toolbarStrings = new string[] { "特效贴图尺寸分类", "特效检查", "shader检查", "数据保存读取", "相同名字shader切换" };
        public string Effectpath = "Assets/Effect/Texture/";
        private int texSize;

        Vector2 scrollPosition;
        Vector2 scrollPosition1;
        Vector2 scrollPosition2;
        Vector2 scrollPosition3;
        Vector2 scrollPosition4;
        Vector2 scrollPosition5;
        Vector2 scrollPosition6;
        Vector2 scrollPosition7;
        Vector2 scrollPosition8;
        //shader列表
        #region 
        [SerializeField]//必须要加  
        public List<Shader> _EffectshaderAssetLst = new List<Shader>();

        [SerializeField]//必须要加  
        public List<Shader> _ChangeshaderAssetLst = new List<Shader>();

        [SerializeField]//必须要加  
        public List<Shader> _OldshaderAssetLst = new List<Shader>();

        [SerializeField]//必须要加  
        public List<Shader> _ResultshaderAssetLst = new List<Shader>();

        [SerializeField]
        public List<Material> _EffectMaterialAssetLst = new List<Material>();

        //序列化对象  
        protected SerializedObject _serializedShader;
        //序列化属性  
        protected SerializedProperty _ShaderAssetLstProperty;

        //序列化对象  
        protected SerializedObject _serializedChangeShader;
        //序列化属性  
        protected SerializedProperty _ChangeShaderAssetLstProperty;

        //序列化对象  
        protected SerializedObject _serializedOldShader;
        //序列化属性  
        protected SerializedProperty _OldShaderAssetLstProperty;
        
        //序列化对象  
        protected SerializedObject _serializedResultShader;
        //序列化属性  
        protected SerializedProperty _ResultShaderAssetLstProperty;

        //序列化对象  
        protected SerializedObject _serializedMaterial;
        //序列化属性  
        protected SerializedProperty _MaterialAssetLstProperty;

        public string ShaderDataPath = "Assets/Tools/特效整理检查/Data/shader备份.asset";
        #endregion


        //保存高分辨率数据
        #region 

        [SerializeField]
        public List<Texture2D> _EffectTexAssetLst = new List<Texture2D>();

        [SerializeField]
        public List<Texture2D> _TexResultsAssetLst = new List<Texture2D>();

        [SerializeField]
        public List<Texture2D> _TexOldAssetLst = new List<Texture2D>();

        //序列化对象  
        protected SerializedObject _serializedObject;
        //序列化属性  
        protected SerializedProperty _EffectTexAssetLstProperty;

        //序列化对象  
        protected SerializedObject _serializedTex;
        //序列化属性  
        protected SerializedProperty _TexResultsAssetLstProperty;

        //序列化对象  
        protected SerializedObject _serializedOldTex;
        //序列化属性  
        protected SerializedProperty _TexOldAssetLstProperty;

        public string EffectOldpath = "Assets/Effect/Texture/Old/";

        public string EffDataPath = "Assets/Tools/特效整理检查/Data/高分辨率贴图备份.asset";
        #endregion

        [MenuItem("Tools/特效使用文件整理检查")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(EffectFileInspection));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.titleContent.text = "特效使用文件整理检查";
        }

        protected void OnEnable()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
            SceneView.onSceneGUIDelegate += this.OnSceneGUI;
            //使用当前类初始化
            _serializedObject = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _EffectTexAssetLstProperty = _serializedObject.FindProperty("_EffectTexAssetLst");

            //使用当前类初始化
            _serializedTex = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _TexResultsAssetLstProperty = _serializedTex.FindProperty("_TexResultsAssetLst");

            //使用当前类初始化
            _serializedOldTex = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _TexOldAssetLstProperty = _serializedOldTex.FindProperty("_TexOldAssetLst");

            //使用当前类初始化
            _serializedShader = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _ShaderAssetLstProperty = _serializedShader.FindProperty("_EffectshaderAssetLst");

            //使用当前类初始化
            _serializedChangeShader = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _ChangeShaderAssetLstProperty = _serializedChangeShader.FindProperty("_ChangeshaderAssetLst");

            //使用当前类初始化
            _serializedOldShader = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _OldShaderAssetLstProperty = _serializedOldShader.FindProperty("_OldshaderAssetLst");

            //使用当前类初始化
            _serializedResultShader = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _ResultShaderAssetLstProperty = _serializedResultShader.FindProperty("_ResultshaderAssetLst");

            

            //使用当前类初始化
            _serializedMaterial = new SerializedObject(this);
            //获取当前类中可序列话的属性        
            _MaterialAssetLstProperty = _serializedMaterial.FindProperty("_EffectMaterialAssetLst");


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
                    EffectTextureClassificationUI();
                    break;
                case 1:
                    EffectInspectionUI();
                    break;
                case 2:
                    prefabShaderInspectionUI();
                    break;
                case 3:
                    SaveDataUI();
                    break;
                case 4:
                    ChangeshaderUI();
                    break;
            }

        }
        //相同名字shader切换
        #region
        private void ChangeshaderUI()
        {
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("相同名字shader切换");

            if (GUILayout.Button("相同名字shader切换", GUILayout.Height(30)))
            {

                Changeshader();
            }

           // GUILayout.EndVertical();
            //===============================
           // GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("修改后shader列表");
            //更新  
            _serializedChangeShader.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            scrollPosition6 = GUILayout.BeginScrollView(scrollPosition6);
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_ChangeShaderAssetLstProperty, true);
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedChangeShader.ApplyModifiedProperties();
            }

            GUILayout.EndVertical();

            
    
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("需要修改的shader列表");
            //更新  
            _serializedOldShader.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            scrollPosition7 = GUILayout.BeginScrollView(scrollPosition7);
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_OldShaderAssetLstProperty, true);
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedOldShader.ApplyModifiedProperties();
            }
            GUILayout.EndVertical();
            //===================================================
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("shader比较");
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("shader比较", GUILayout.Height(30)))
            {
                CompareShader();
            }
            //if (GUILayout.Button("一键移动到对应文件夹", GUILayout.Height(30)))
            //{

            //}
            GUILayout.EndHorizontal();
            GUILayout.EndVertical();

            //=============
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("比较结果shader列表");
            //更新  
            _serializedResultShader.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            scrollPosition8 = GUILayout.BeginScrollView(scrollPosition8);
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_ResultShaderAssetLstProperty, true);
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedResultShader.ApplyModifiedProperties();
            }
            GUILayout.EndVertical();

            //===============================
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("查找需要修改的shader列表中的材质",  GUILayout.Height(30)))
            {

                shaderFindMaterial();
            }
            if (GUILayout.Button("对下列材质列表进行相同名字shader切换", GUILayout.Height(30)))
            {
                ResultChangeshader();
            }
            GUILayout.EndHorizontal();
            GUILayout.Label("材质列表");
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
        private void CompareShader()
        {
            List<Shader> DifferentShader = new List<Shader>();
            if (_ChangeshaderAssetLst.Count == 0 || _OldshaderAssetLst.Count ==0)
            {
                EditorUtility.DisplayDialog("警告", "列表中shader是空的！", "OK");
                return;
            }
            foreach(Shader shader in _OldshaderAssetLst)
            {
                for (int i = 0; i < _ChangeshaderAssetLst.Count; i++)
                {
                    if (shader != _ChangeshaderAssetLst[i])
                    {
                        DifferentShader.Add(shader);
                    }
                }
            }
            _ResultshaderAssetLst = DifferentShader;
        }
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
                for (int i = 0; i < _OldshaderAssetLst.Count; i++)
                {
                    if (material.shader == _OldshaderAssetLst[i])
                    {
                        ErrShaderMaterial.Add(material);

                    }

                }
            }
            _EffectMaterialAssetLst = ErrShaderMaterial;
        }

        private void Changeshader()
        {
            Object[] Materilas = GetSelectedMaterilas();
            if (Materilas.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含材质球的文件夹或者单独材质球！", "OK");
                return;
            }
            foreach (Material material in Materilas)
            {
               
                for (int i = 0; i < _ChangeshaderAssetLst.Count; i++)
                {
                    if (material.shader.name == _ChangeshaderAssetLst[i].name)
                    {
                        if (material.shader != _ChangeshaderAssetLst[i])
                        {
                            int RenderQueueint = material.renderQueue;
                            material.shader = _ChangeshaderAssetLst[i];
                            material.renderQueue = RenderQueueint;
                        }
                       
                    }
                    
                }                
                
            }
        }
        private void ResultChangeshader()
        {
         
            if (_EffectMaterialAssetLst.Count == 0)
            {
                EditorUtility.DisplayDialog("警告", "材质列表是空的！", "OK");
                return;
            }
            foreach (Material material in _EffectMaterialAssetLst)
            {

                for (int i = 0; i < _ChangeshaderAssetLst.Count; i++)
                {
                    if (material.shader.name == _ChangeshaderAssetLst[i].name)
                    {
                        if (material.shader != _ChangeshaderAssetLst[i])
                        {
                            int RenderQueueint = material.renderQueue;
                            material.shader = _ChangeshaderAssetLst[i];
                            material.renderQueue = RenderQueueint;
                        }

                    }

                }

            }
        }

        #endregion

        //特效贴图整理UI
        #region
        private void EffectTextureClassificationUI()
        {
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("特效贴图处理");
            Effectpath = EditorGUILayout.TextField("特效贴图存放位置", Effectpath);
            //GUILayout.BeginHorizontal();
          
            if (GUILayout.Button("特效贴图根据尺寸进行分类", GUILayout.Width(400), GUILayout.Height(30)))
            {

                EffectTextureClassification();

            }
            GUILayout.EndVertical();
        }
        #endregion

        //特效检查UI
        #region
        private void EffectInspectionUI()
        {
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("特效贴图检查");
            if (GUILayout.Button("贴图检查", GUILayout.Height(30)))
            {
                EffectTextreInspection();
            }

            GUILayout.EndVertical();
            GUILayout.Space(10);
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("预制体贴图检查");
            Effectpath = EditorGUILayout.TextField("特效贴图存放位置", Effectpath);
            if (GUILayout.Button("预制体使用检查", GUILayout.Height(30)))
            {
                prefabShaderInspection();
                prefabTexInspection();
            }
            GUILayout.EndVertical();

            //===============================
            GUILayout.BeginVertical("box", GUILayout.Width(420));

            GUILayout.Label("问题shader材质列表");
            //更新  
            _serializedMaterial.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            scrollPosition1 = GUILayout.BeginScrollView(scrollPosition1);
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

            //===============================
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("问题贴图列表");
            //更新  
            _serializedTex.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            scrollPosition2 = GUILayout.BeginScrollView(scrollPosition2);
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_TexResultsAssetLstProperty, true);
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedTex.ApplyModifiedProperties();
            }

            GUILayout.EndVertical();
            //===================================================

            //===============================
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("使用旧贴图列表");
            EffectOldpath = EditorGUILayout.TextField("特效旧贴图存放位置", EffectOldpath);
            //更新  
            _serializedOldTex.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
 
            scrollPosition3 = GUILayout.BeginScrollView(scrollPosition3);
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_TexOldAssetLstProperty, true);

            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedOldTex.ApplyModifiedProperties();
            }

            GUILayout.EndVertical();
            //===================================================


        }
        #endregion


        //特效材质检查UI
        #region
        private void prefabShaderInspectionUI()
        {
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("材质shander检查");

            if (GUILayout.Button("材质shander检查", GUILayout.Width(400), GUILayout.Height(30)))
            {

                prefabShaderInspection();

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
            GUILayout.Label("高分辨率贴图备份数据");
            //更新  
            _serializedObject.Update();

            //开始检查是否有修改  
            EditorGUI.BeginChangeCheck();
            EffDataPath = EditorGUILayout.TextField("高分辨率贴图备份数据路径", EffDataPath);
            GUILayout.BeginHorizontal();

            if (GUILayout.Button("保存数据", GUILayout.Height(30)))
            {
                var EffectTexSaveData = ScriptableObject.CreateInstance<EffectTexSave>();

                EffectTexSaveData._EffectTexAssetLst = _EffectTexAssetLst;

                AssetDatabase.CreateAsset(EffectTexSaveData, EffDataPath);
                AssetDatabase.SaveAssets();
            }
            if (GUILayout.Button("读取数据", GUILayout.Height(30)))
            {

                var EffectTexSaveData = AssetDatabase.LoadAssetAtPath<EffectTexSave>(EffDataPath);
                _EffectTexAssetLst = EffectTexSaveData._EffectTexAssetLst;

            }

            GUILayout.EndHorizontal();
            scrollPosition4 = GUILayout.BeginScrollView(scrollPosition4);
            //显示属性  
            //第二个参数必须为true，否则无法显示子节点即List内容  
            EditorGUILayout.PropertyField(_EffectTexAssetLstProperty, true);
            GUILayout.EndScrollView();
            //结束检查是否有修改  
            if (EditorGUI.EndChangeCheck())
            {
                _serializedObject.ApplyModifiedProperties();
            }

            GUILayout.EndVertical();
            //===================================================

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
                var ShaderSave = ScriptableObject.CreateInstance<ShaderSave>();

                ShaderSave._EffectshaderAssetLst = _EffectshaderAssetLst;

                AssetDatabase.CreateAsset(ShaderSave, ShaderDataPath);
                AssetDatabase.SaveAssets();
            }
            if (GUILayout.Button("读取数据", GUILayout.Height(30)))
            {

                var ShaderSave = AssetDatabase.LoadAssetAtPath<ShaderSave>(ShaderDataPath);
                _EffectshaderAssetLst = ShaderSave._EffectshaderAssetLst;

            }

            GUILayout.EndHorizontal();
            scrollPosition5 = GUILayout.BeginScrollView(scrollPosition5);
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

        //特效贴图检查
        #region
        private void EffectTextreInspection()
        {
            Object[] textures = GetSelectedTextures();

            if (textures.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含贴图的文件夹或者单独贴图！", "OK");
                return;
            }
            List<Texture2D> ErrTex = new List<Texture2D>();
            
            foreach (Texture2D texture in textures)
            {
                string path = AssetDatabase.GetAssetPath(texture);
                
                //TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                //Debug.Log(path.Substring(path.Length-4));
                if (path.IndexOf("32") != -1)
                {
                    if (getMax(texture.width, texture.height) != 32)
                    {
                        ErrTex.Add(texture);
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("64") != -1)
                {
                    if (getMax(texture.width, texture.height) != 64)
                    {
                        ErrTex.Add(texture);
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("128") != -1)
                {
                    if (getMax(texture.width, texture.height) != 128)
                    {
                        ErrTex.Add(texture);
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("256") != -1)
                {
                    if (getMax(texture.width, texture.height) != 256)
                    {
                        ErrTex.Add(texture);
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("512") != -1)
                {
                    if (getMax(texture.width, texture.height) != 512)
                    {
                        ErrTex.Add(texture);
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("1024") != -1)
                {
                    if (getMax(texture.width, texture.height) != 1024)
                    {
                        ErrTex.Add(texture);
                        moveassetTex(texture, path, Effectpath);
                    }
                }

            }
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            _TexResultsAssetLst = ErrTex;
           
        }


        #endregion

        //特效高分辨率贴图检查
        #region
        private bool checkTex = false;
        private void prefabTexInspection()
        {
            Object[] textures = GetSelectedTextures();

            if (textures.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含贴图的文件夹或者单独贴图！", "OK");
                return;
            }

            var EffectTexSaveData = AssetDatabase.LoadAssetAtPath<EffectTexSave>(EffDataPath);
            _EffectTexAssetLst = EffectTexSaveData._EffectTexAssetLst;
            List<Texture2D> ErrTex = new List<Texture2D>();
            List<Texture2D> OldErrTex = new List<Texture2D>();

            foreach (Texture2D texture in textures)
            {
                string path = AssetDatabase.GetAssetPath(texture);
                if (path.Substring(0, EffectOldpath.Length) == EffectOldpath)
                {
                    OldErrTex.Add(texture);
                }

                if (texture.width >= 512 || texture.height >= 512)
                {
                    ErrTex.Add(texture);
                }
                //string path = AssetDatabase.GetAssetPath(texture);
                foreach (Texture2D EffectTex in _EffectTexAssetLst)
                {
                    //string Effectpath = AssetDatabase.GetAssetPath(EffectTex);
                    if (EffectTex == texture)
                    {
                        checkTex = false;
                        break;               
                    }
                    else
                    {
                        checkTex = true;
                    }
                }
                if (checkTex == true)
                {
                    if (texture.width >= 512 || texture.height >= 512)
                    {
                        //string path = AssetDatabase.GetAssetPath(texture);
                        moveassetTex(texture, path, Effectpath);
                        //Debug.Log("000000");
                    }
                    checkTex = false;
                }

               
            }
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            _TexResultsAssetLst = ErrTex;
            _TexOldAssetLst = OldErrTex;
        }


        #endregion

        //特效材质检查
        #region

        private bool checkShader = false;
       
        private void prefabShaderInspection()
        {
            Object[] Materilas = GetSelectedMaterilas();
            if (Materilas.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含材质球的文件夹或者单独材质球！", "OK");
                return;
            }
            var ShaderSave = AssetDatabase.LoadAssetAtPath<ShaderSave>(ShaderDataPath);
            _EffectshaderAssetLst = ShaderSave._EffectshaderAssetLst;
            List<Material> ErrShaderMaterial = new List<Material>();
            foreach (Material material in Materilas)
            {
                foreach (Shader shader in _EffectshaderAssetLst)
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
                    checkShader = false;
                }
            }
            _EffectMaterialAssetLst = ErrShaderMaterial;

            if (ErrShaderMaterial.Count > 0)
            {
                
                foreach (Material ErrShaderMaterialitem in ErrShaderMaterial)
                {
                    EditorUtility.DisplayDialog("结果：警告", "有不符合的shader！材质球名称："+ ErrShaderMaterialitem.name, "OK");
                }            
            }
            else
            {
                EditorUtility.DisplayDialog("结果：", "所选Shader都符合", "OK");
            }
            
        }
        static Object[] GetSelectedMaterilas()
        {

            return Selection.GetFiltered(typeof(Material), SelectionMode.DeepAssets);
        }

        #endregion

        //特效贴图整理
        #region
        private void EffectTextureClassification()
        {

            Object[] textures = GetSelectedTextures();
            
            if (textures.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含贴图的文件夹或者单独贴图！", "OK");
                return;
            }

            foreach (Texture2D texture in textures)
            {
                string path = AssetDatabase.GetAssetPath(texture);
                
                //TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                //Debug.Log(path.Substring(path.Length-4));
                if (texture.width != texture.height)
                {
                    texSize = getMax(texture.width, texture.height);
                }
                else
                {
                    texSize = texture.width;
                }
                //Debug.Log(texSize);
                if (texSize == 1024 || texSize == 512 || texSize ==256 || texSize == 128 || texSize == 64 || texSize == 32)
                {
                    string movepath = Effectpath + "特效贴图" + texSize + "尺寸/";
                    moveassetTex(texture, path, movepath);
                }
               
            }
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }

        //移动贴图
        private void moveassetTex(Texture2D texture, string path, string movepath)
        {
            
            if (!Directory.Exists(movepath))
            {
                Directory.CreateDirectory(movepath);
                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
                if (path.Substring(path.Length - 4) == ".png")
                {
                    AssetDatabase.MoveAsset(path, movepath + texture.name + ".png");
                    AssetDatabase.MoveAsset(path + ".meta", movepath + texture.name + ".png" + ".meta");
                }
                if (path.Substring(path.Length - 4) == ".tga")
                {
                    AssetDatabase.MoveAsset(path, movepath + texture.name + ".tga");
                    AssetDatabase.MoveAsset(path + ".meta", movepath + texture.name + ".tga" + ".meta");
                }

            }
            else
            {
                if (path.Substring(path.Length - 4) == ".png")
                {
                    AssetDatabase.MoveAsset(path, movepath + texture.name + ".png");
                    AssetDatabase.MoveAsset(path + ".meta", movepath + texture.name + ".png" + ".meta");
                }
                if (path.Substring(path.Length - 4) == ".tga")
                {
                    AssetDatabase.MoveAsset(path, movepath + texture.name + ".tga");
                    AssetDatabase.MoveAsset(path + ".meta", movepath + texture.name + ".tga" + ".meta");
                }
            }
        }


        static Object[] GetSelectedTextures()
        {
            return Selection.GetFiltered(typeof(Texture2D), SelectionMode.DeepAssets);
        }

        //返回2个数最大的数
        private int getMax(int a, int b)
        {
            return a > b ? a : b;
        }

        #endregion

    }
}


#endif