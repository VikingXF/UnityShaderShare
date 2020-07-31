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
        [MenuItem("Tools/UI����")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(UiPackag));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.titleContent.text = "UI����";
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
            UIScenesname = EditorGUILayout.TextField("����UI����", UIScenesname);
            if (GUILayout.Button("��Դ�ƶ�", GUILayout.Width(240), GUILayout.Height(30)))
            {

                moveUI();

            }
            if (GUILayout.Button("����·��", GUILayout.Width(240), GUILayout.Height(30)))
            {
                pathUI();
            }
        }
        private void pathUI()
        {
            Object[] textures = GetSelectedTextures();
            if (textures.Length == 0)
            {
                EditorUtility.DisplayDialog("����", "ѡ��һ��������ͼ���ļ��л��ߵ�����ͼ��", "OK");
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
                EditorUtility.DisplayDialog("����", "ѡ��һ��������ͼ���ļ��л��ߵ�����ͼ��", "OK");
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
                        if (path.Substring(0, 15) != UIpath + "ͨ��/")
                        {
                            if (path == UIpath + "ͨ��/" + texture.name + ".png")
                            {
                                if (!Directory.Exists(UIpath + "ͨ��/�����ظ�" + i))
                                {
                                    Directory.CreateDirectory(UIpath + "ͨ��/�����ظ�" + i + "/");
                                    AssetDatabase.SaveAssets();
                                    AssetDatabase.Refresh();
                                    AssetDatabase.MoveAsset(path, UIpath + "ͨ��/�����ظ�" + i + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIpath + "ͨ��/�����ظ�" + i + "/" + texture.name + ".png" + ".meta");
                                    i++;
                                }

                            }
                            else
                            {
                                AssetDatabase.MoveAsset(path, UIpath + "ͨ��/" + texture.name + ".png");
                                AssetDatabase.MoveAsset(path + ".meta", UIpath + "ͨ��/" + texture.name + ".png" + ".meta");
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
                                Directory.CreateDirectory(targetDirectory + "/�ظ���Դ"+j + "/");
                                AssetDatabase.SaveAssets();
                                AssetDatabase.Refresh();
                                AssetDatabase.MoveAsset(path, targetDirectory + "/�ظ���Դ" + j + "/" + texture.name + ".png");
                                AssetDatabase.MoveAsset(path + ".meta", targetDirectory + "/�ظ���Դ" + j + "/" + texture.name + ".png" + ".meta");
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