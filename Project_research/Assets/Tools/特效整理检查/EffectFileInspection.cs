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
        string[] toolbarStrings = new string[] { "特效贴图尺寸分类", "特效贴图尺寸检查", "特效shader检查" };
        public string Effectpath = "Assets/Effect/Texture/";
        private int texSize;
        public List<string> HighResolutionPath = new List<string>();


        [MenuItem("Tools/特效使用文件整理")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(EffectFileInspection));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.titleContent.text = "特效使用文件整理";
        }

        protected void OnEnable()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
            SceneView.onSceneGUIDelegate += this.OnSceneGUI;
            //使用当前类初始化
            //_serializedObject = new SerializedObject(this);
            //获取当前类中可序列话的属性
           // IgnorePathProperty = _serializedObject.FindProperty("IgnorePath");
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

                    break;
            }

        }

        //贴图处理UI
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

        //贴图处理UI
        #region
        private void EffectInspectionUI()
        {
            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("特效贴图检查");
            if (GUILayout.Button("贴图检查", GUILayout.Width(400), GUILayout.Height(30)))
            {
                EffectTextreInspection();
            }

            GUILayout.EndVertical();

            GUILayout.BeginVertical("box", GUILayout.Width(420));
            GUILayout.Label("预制体贴图检查");
            if (GUILayout.Button("预制体使用超过512贴图检查", GUILayout.Width(400), GUILayout.Height(30)))
            {
                prefabTexInspection();
            }

            GUILayout.EndVertical();

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

            foreach (Texture2D texture in textures)
            {
                string path = AssetDatabase.GetAssetPath(texture);

                //TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                //Debug.Log(path.Substring(path.Length-4));
                if (path.IndexOf("32") != -1)
                {
                    if (getMax(texture.width, texture.height) != 32)
                    {
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("64") != -1)
                {
                    if (getMax(texture.width, texture.height) != 64)
                    {
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("128") != -1)
                {
                    if (getMax(texture.width, texture.height) != 128)
                    {
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("256") != -1)
                {
                    if (getMax(texture.width, texture.height) != 256)
                    {
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("512") != -1)
                {
                    if (getMax(texture.width, texture.height) != 512)
                    {
                        moveassetTex(texture, path, Effectpath);
                    }
                }
                if (path.IndexOf("1024") != -1)
                {
                    if (getMax(texture.width, texture.height) != 1024)
                    {                      
                        moveassetTex(texture, path, Effectpath);
                    }
                }

            }
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }


        #endregion

        //特效贴图检查
        #region
        private void prefabTexInspection()
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
                if (path != HighResolutionPath[0])
                {
                    if (texture.width >= 512 || texture.width >=512)
                    {
                        Debug.Log("000000");
                    }
                }
            }
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }


        #endregion

        //特效特效检查
        #region
        private void prefabShaderInspection()
        {
            Object[] Materilas = GetSelectedMaterilas();
            if (Materilas.Length == 0)
            {
                EditorUtility.DisplayDialog("警告", "选择一个包含材质球的文件夹或者单独材质球！", "OK");
                return;
            }
            foreach (Material material in Materilas)
            {
                string path = AssetDatabase.GetAssetPath(material.mainTexture);

                //TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                //Debug.Log(path.Substring(path.Length-4));


            }
            //AssetDatabase.SaveAssets();
            //AssetDatabase.Refresh();
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