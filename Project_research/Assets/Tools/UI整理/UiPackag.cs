#if UNITY_EDITOR
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;

namespace ChineseCharacters
{
    public class UiPackag : EditorWindow
    {
        int toolbarInt = 0;
        string[] toolbarStrings = new string[] { "ResourcesUI整理", "测试路径" };
        
        private int i = 0;
        private int j = 0;



        //忽略目录
        private int a = 0;
        [SerializeField]
        public string[] IgnorePath = new string[] { "Assets/Resources/", "Assets/_ui2/全局UI/" };

        //序列化对象
        protected SerializedObject _serializedObject;

        //序列化属性
        protected SerializedProperty IgnorePathProperty;

        [MenuItem("Tools/UI整理")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(UiPackag));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.titleContent.text = "UI整理";
        }

        protected void OnEnable()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
            SceneView.onSceneGUIDelegate += this.OnSceneGUI;
            //使用当前类初始化
            _serializedObject = new SerializedObject(this);
            //获取当前类中可序列话的属性
            IgnorePathProperty = _serializedObject.FindProperty("IgnorePath");
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
            toolbarInt = GUILayout.Toolbar(toolbarInt, toolbarStrings);
            switch (toolbarInt)
            {
                case 0:
                    ResourcesSortingUI();
                    break;
                case 1:                
                    ScreenSortingUI();
                    break;
            }
           
        }

        //public string UIScenesname = "";
        //public string UIpath = "Assets/_ui2/";
        //private string targetDirectory = "";

        private void ScreenSortingUI()
        {
            ////更新
            //_serializedObject.Update();
            ////开始检查是否有修改
            //EditorGUI.BeginChangeCheck();
            ////显示属性
            ////第二个参数必须为true，否则无法显示子节点即List内容
            //EditorGUILayout.PropertyField(IgnorePathProperty, true);

            ////结束检查是否有修改
            //if (EditorGUI.EndChangeCheck())
            //{//提交修改
            //    _serializedObject.ApplyModifiedProperties();
            //}

            //UIpath = EditorGUILayout.TextField("移动后UI目录", UIpath);
            //UIScenesname = EditorGUILayout.TextField("场景UI名称", UIScenesname);
            //if (GUILayout.Button("资源移动", GUILayout.Width(240), GUILayout.Height(30)))
            //{

            //    ScreenUImove();

            //}
            if (GUILayout.Button("测试路径", GUILayout.Width(240), GUILayout.Height(30)))
            {
                TestingPathLog();
            }
        }


        //预制体整理UI
        public string UIPrefabsname = "";
        public string UIPrefabspath = "Assets/PrefabsUI/";
        private void ResourcesSortingUI()
        {
            //更新
            _serializedObject.Update();
            //开始检查是否有修改
            EditorGUI.BeginChangeCheck();
            //显示属性
            //第二个参数必须为true，否则无法显示子节点即List内容
            EditorGUILayout.PropertyField(IgnorePathProperty, true);

            //结束检查是否有修改
            if (EditorGUI.EndChangeCheck())
            {//提交修改
                _serializedObject.ApplyModifiedProperties();
            }
            UIPrefabspath = EditorGUILayout.TextField("移动后UI目录", UIPrefabspath);
            UIPrefabsname = EditorGUILayout.TextField("预制体功能名称", UIPrefabsname);
            if (GUILayout.Button("资源移动", GUILayout.Width(240), GUILayout.Height(30)))
            {

                PrefabsUImove();

            }
        }
        private void PrefabsUImove()
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
                    a = 0;
                    if (path.Substring(0, UIPrefabspath.Length) == UIPrefabspath)
                    {
                        if (path.Substring(0, UIPrefabspath.Length+3) != UIPrefabspath + "通用/")
                        {
                            if (!Directory.Exists(UIPrefabspath + "通用/" + UIPrefabsname))
                            {
                                Directory.CreateDirectory(UIPrefabspath + "通用/" + UIPrefabsname + "/");
                                AssetDatabase.SaveAssets();
                                AssetDatabase.Refresh();
                                AssetDatabase.MoveAsset(path, UIPrefabspath + "通用/" + UIPrefabsname + "/" + texture.name + ".png");
                                AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + "通用/" + UIPrefabsname + "/" + texture.name + ".png" + ".meta");
                            }

                            else
                            {
                                if (File.Exists(UIPrefabspath + "通用/" + UIPrefabsname + "/" + texture.name + ".png"))
                                {
                                    Directory.CreateDirectory(UIPrefabspath + "通用/" + UIPrefabsname + "/名称重复" + i + "/");
                                    AssetDatabase.SaveAssets();
                                    AssetDatabase.Refresh();
                                    AssetDatabase.MoveAsset(path, UIPrefabspath + "通用/" + UIPrefabsname + "/名称重复" + i + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + "通用/" + UIPrefabsname + "/名称重复" + i + "/" + texture.name + ".png" + ".meta");
                                    i++;
                                }
                                else
                                {
                                    AssetDatabase.MoveAsset(path, UIPrefabspath + "通用/" + UIPrefabsname + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + "通用/" + UIPrefabsname + "/" + texture.name + ".png" + ".meta");
                                }
                            }

                        }

                    }
                    else
                    {
                                             
                        for (int b = 0; b < IgnorePath.Length; b++)
                        {
                            if (path.Substring(0, IgnorePath[b].Length) != IgnorePath[b])
                            {
                                a++;
                            }
                            Debug.Log("1111111a=" + a);
                        }
                        Debug.Log("22222a=" + a);
                        //判断排除特定文件夹不移动 
                        if (a == IgnorePath.Length)
                        {
                            if (!Directory.Exists(UIPrefabspath + UIPrefabsname + "/"))
                            {
                                Directory.CreateDirectory(UIPrefabspath + UIPrefabsname + "/");
                                AssetDatabase.SaveAssets();
                                AssetDatabase.Refresh();
                                AssetDatabase.MoveAsset(path, UIPrefabspath + UIPrefabsname + "/" + texture.name + ".png");
                                AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + UIPrefabsname + "/" + texture.name + ".png" + ".meta");
                              

                            }
                            else
                            {
                                if (File.Exists(UIPrefabspath + UIPrefabsname + "/" + texture.name + ".png"))
                                {
                                    Directory.CreateDirectory(UIPrefabspath + UIPrefabsname + "/名称重复" + j + "/");
                                    AssetDatabase.SaveAssets();
                                    AssetDatabase.Refresh();
                                    AssetDatabase.MoveAsset(path, UIPrefabspath + UIPrefabsname + "/名称重复" + j + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + UIPrefabsname + "/名称重复" + j + "/" + texture.name + ".png" + ".meta");
                                    j++;
                                   
                                }
                                else
                                {
                                    AssetDatabase.MoveAsset(path, UIPrefabspath + UIPrefabsname + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + UIPrefabsname + "/" + texture.name + ".png" + ".meta");
                                  
                                }


                            }
                        }
                    }

                }

            }
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            i = 0;
            j = 0;
           

        }

        //测试资源路径
        private void TestingPathLog()
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
                //if (File.Exists(UIpath+"通用/" +texture.name +".png"))
                //{
                //    Debug.Log("11111111111");
                //}
                TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                if (textureImporter.textureType == TextureImporterType.Sprite)
                {
                    Debug.Log(a);
                    Debug.Log(path.Substring(0, 12));

                }
            }

        }

        //根据场景排序UI
        //private void ScreenUImove()
        //{
        //    Object[] textures = GetSelectedTextures();
        //    if (textures.Length == 0)
        //    {
        //        EditorUtility.DisplayDialog("警告", "选择一个包含贴图的文件夹或者单独贴图！", "OK");
        //        return;
        //    }

        //    foreach (Texture2D texture in textures)
        //    {
        //        string path = AssetDatabase.GetAssetPath(texture);
        //        TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
        //        if (textureImporter.textureType == TextureImporterType.Sprite)
        //        {
        //            Debug.Log(path);
        //            Debug.Log(path + ".meta");
        //            a = 0;
        //            targetDirectory = UIpath + UIScenesname;
        //            if (path.Substring(0, UIpath.Length) == UIpath)
        //            {
        //                if (path.Substring(0, UIpath.Length+3) != UIpath + "通用/")
        //                {
        //                    if (!Directory.Exists(UIpath + "通用/" + UIScenesname))
        //                    {
        //                        Directory.CreateDirectory(UIpath + "通用/" + UIScenesname + "/");
        //                        AssetDatabase.SaveAssets();
        //                        AssetDatabase.Refresh();
        //                        AssetDatabase.MoveAsset(path, UIpath + "通用/" + UIScenesname + "/" + texture.name + ".png");
        //                        AssetDatabase.MoveAsset(path + ".meta", UIpath + "通用/" + UIScenesname + "/" + texture.name + ".png" + ".meta");
        //                    }

        //                    else
        //                    {
        //                        if (File.Exists(UIpath + "通用/" + UIScenesname + "/" + texture.name + ".png"))
        //                        {
        //                            Directory.CreateDirectory(UIpath + "通用/" + UIScenesname +  "/名称重复" + i + "/");
        //                            AssetDatabase.SaveAssets();
        //                            AssetDatabase.Refresh();
        //                            AssetDatabase.MoveAsset(path, UIpath + "通用/" + UIScenesname +"/名称重复" + i + "/" + texture.name + ".png");
        //                            AssetDatabase.MoveAsset(path + ".meta", UIpath + "通用/" + UIScenesname +"/名称重复" + i + "/" + texture.name + ".png" + ".meta");
        //                            i++;
        //                        }
        //                        else
        //                        {
        //                            AssetDatabase.MoveAsset(path, UIpath + "通用/" + UIScenesname + "/" + texture.name + ".png");
        //                            AssetDatabase.MoveAsset(path + ".meta", UIpath + "通用/" + UIScenesname + "/" + texture.name + ".png" + ".meta");
        //                        }
        //                    }                         

        //                }                     

        //            }
        //            else
        //            {
                       
        //                for (int b = 0; b < IgnorePath.Length; b++)
        //                {
        //                    if (path.Substring(0, IgnorePath[b].Length) != IgnorePath[b])
        //                    {
        //                        a++;
        //                    }

        //                }

        //                //判断排除特定文件夹不移动
        //                if (a == IgnorePath.Length)
        //                {
        //                    if (!Directory.Exists(targetDirectory))
        //                    {
        //                        Directory.CreateDirectory(targetDirectory + "/");
        //                        AssetDatabase.SaveAssets();
        //                        AssetDatabase.Refresh();
        //                        AssetDatabase.MoveAsset(path, targetDirectory + "/" + texture.name + ".png");
        //                        AssetDatabase.MoveAsset(path + ".meta", targetDirectory + "/" + texture.name + ".png" + ".meta");
                                
                                
        //                    }
        //                    else
        //                    {
        //                        if (File.Exists(targetDirectory + "/" + texture.name + ".png"))
        //                        {
        //                            Directory.CreateDirectory(targetDirectory + "/重复资源" + j + "/");
        //                            AssetDatabase.SaveAssets();
        //                            AssetDatabase.Refresh();
        //                            AssetDatabase.MoveAsset(path, targetDirectory + "/重复资源" + j + "/" + texture.name + ".png");
        //                            AssetDatabase.MoveAsset(path + ".meta", targetDirectory + "/重复资源" + j + "/" + texture.name + ".png" + ".meta");
        //                            j++;
                                  
                                    
        //                        }
        //                        else
        //                        {
        //                            AssetDatabase.MoveAsset(path, targetDirectory + "/" + texture.name + ".png");
        //                            AssetDatabase.MoveAsset(path + ".meta", targetDirectory + "/" + texture.name + ".png" + ".meta");
                                   
                                    
        //                        }

        //                    }
        //                }
                        
        //            }
                    
        //        }
                  
        //    }
        //    AssetDatabase.SaveAssets();
        //    AssetDatabase.Refresh();
        //    j = 0;
        //    i = 0;
            
        //}

        static Object[] GetSelectedTextures()
        {
            return Selection.GetFiltered(typeof(Texture2D), SelectionMode.DeepAssets);
        }

    }
}
#endif