#if UNITY_EDITOR
using UnityEngine;
using System.Collections;
using UnityEditor;
using System.IO;

namespace ChineseCharacters
{
    public class UiPackag : EditorWindow
    {
        public string UIScenesname = "";
        private string UIpath = "Assets/_ui2/";
        private string targetDirectory = "";
        private int i = 0;
        private int j = 0;
        [MenuItem("Tools/UI整理")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(UiPackag));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.titleContent.text = "UI整理";
        }

        void OnEnable()
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
            UIScenesname = EditorGUILayout.TextField("场景UI名称", UIScenesname);
            if (GUILayout.Button("资源移动", GUILayout.Width(240), GUILayout.Height(30)))
            {

                moveUI();

            }
            if (GUILayout.Button("测试路径", GUILayout.Width(240), GUILayout.Height(30)))
            {
                pathUI();
            }
        }
        private void pathUI()
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
                TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                if (textureImporter.textureType == TextureImporterType.Sprite)
                {
                    Debug.Log(path.Substring(0, 15));

                }
            }

        }

        private void moveUI()
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
                TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                if (textureImporter.textureType == TextureImporterType.Sprite)
                {
                    Debug.Log(path);
                    Debug.Log(path + ".meta");

                    targetDirectory = UIpath + UIScenesname;
                    if (path.Substring(0, 12) == UIpath)
                    {
                        if (path.Substring(0, 15) != UIpath + "通用/")
                        {
                            if (path == UIpath + "通用/" + texture.name + ".png")
                            {
                                if (!Directory.Exists(UIpath + "通用/名称重复" + i))
                                {
                                    Directory.CreateDirectory(UIpath + "通用/名称重复" + i + "/");
                                    AssetDatabase.SaveAssets();
                                    AssetDatabase.Refresh();
                                    AssetDatabase.MoveAsset(path, UIpath + "通用/名称重复" + i + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIpath + "通用/名称重复" + i + "/" + texture.name + ".png" + ".meta");
                                    i++;
                                }

                            }
                            else
                            {
                                AssetDatabase.MoveAsset(path, UIpath + "通用/" + texture.name + ".png");
                                AssetDatabase.MoveAsset(path + ".meta", UIpath + "通用/" + texture.name + ".png" + ".meta");
                            }

                        }                     

                    }
                    else
                    {
                        if (!Directory.Exists(targetDirectory))
                        {
                            Directory.CreateDirectory(targetDirectory + "/");
                            AssetDatabase.SaveAssets();
                            AssetDatabase.Refresh();                           
                            AssetDatabase.MoveAsset(path, targetDirectory + "/" + texture.name + ".png");
                            AssetDatabase.MoveAsset(path + ".meta", targetDirectory + "/" + texture.name + ".png" + ".meta");
                        }
                        else
                        {
                            if (!Directory.Exists(targetDirectory + "/" + texture.name + ".png"))
                            {
                                AssetDatabase.MoveAsset(path, targetDirectory + "/" + texture.name + ".png");
                                AssetDatabase.MoveAsset(path + ".meta", targetDirectory + "/" + texture.name + ".png" + ".meta");
                            }
                            else
                            {
                                Directory.CreateDirectory(targetDirectory + "/重复资源"+j + "/");
                                AssetDatabase.SaveAssets();
                                AssetDatabase.Refresh();
                                AssetDatabase.MoveAsset(path, targetDirectory + "/重复资源" + j + "/" + texture.name + ".png");
                                AssetDatabase.MoveAsset(path + ".meta", targetDirectory + "/重复资源" + j + "/" + texture.name + ".png" + ".meta");
                                j++;
                            }
                            
                        }
                    }
                    
                }
                  
            }
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            j = 0;
        }

        static Object[] GetSelectedTextures()
        {
            return Selection.GetFiltered(typeof(Texture2D), SelectionMode.DeepAssets);
        }

    }
}
#endif