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
        string[] toolbarStrings = new string[] { "ResourcesUI����", "����·��" };
        
        private int i = 0;
        private int j = 0;



        //����Ŀ¼
        private int a = 0;
        [SerializeField]
        public string[] IgnorePath = new string[] { "Assets/Resources/", "Assets/_ui2/ȫ��UI/" };

        //���л�����
        protected SerializedObject _serializedObject;

        //���л�����
        protected SerializedProperty IgnorePathProperty;

        [MenuItem("Tools/UI����")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(UiPackag));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.titleContent.text = "UI����";
        }

        protected void OnEnable()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
            SceneView.onSceneGUIDelegate += this.OnSceneGUI;
            //ʹ�õ�ǰ���ʼ��
            _serializedObject = new SerializedObject(this);
            //��ȡ��ǰ���п����л�������
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
            ////����
            //_serializedObject.Update();
            ////��ʼ����Ƿ����޸�
            //EditorGUI.BeginChangeCheck();
            ////��ʾ����
            ////�ڶ�����������Ϊtrue�������޷���ʾ�ӽڵ㼴List����
            //EditorGUILayout.PropertyField(IgnorePathProperty, true);

            ////��������Ƿ����޸�
            //if (EditorGUI.EndChangeCheck())
            //{//�ύ�޸�
            //    _serializedObject.ApplyModifiedProperties();
            //}

            //UIpath = EditorGUILayout.TextField("�ƶ���UIĿ¼", UIpath);
            //UIScenesname = EditorGUILayout.TextField("����UI����", UIScenesname);
            //if (GUILayout.Button("��Դ�ƶ�", GUILayout.Width(240), GUILayout.Height(30)))
            //{

            //    ScreenUImove();

            //}
            if (GUILayout.Button("����·��", GUILayout.Width(240), GUILayout.Height(30)))
            {
                TestingPathLog();
            }
        }


        //Ԥ��������UI
        public string UIPrefabsname = "";
        public string UIPrefabspath = "Assets/PrefabsUI/";
        private void ResourcesSortingUI()
        {
            //����
            _serializedObject.Update();
            //��ʼ����Ƿ����޸�
            EditorGUI.BeginChangeCheck();
            //��ʾ����
            //�ڶ�����������Ϊtrue�������޷���ʾ�ӽڵ㼴List����
            EditorGUILayout.PropertyField(IgnorePathProperty, true);

            //��������Ƿ����޸�
            if (EditorGUI.EndChangeCheck())
            {//�ύ�޸�
                _serializedObject.ApplyModifiedProperties();
            }
            UIPrefabspath = EditorGUILayout.TextField("�ƶ���UIĿ¼", UIPrefabspath);
            UIPrefabsname = EditorGUILayout.TextField("Ԥ���幦������", UIPrefabsname);
            if (GUILayout.Button("��Դ�ƶ�", GUILayout.Width(240), GUILayout.Height(30)))
            {

                PrefabsUImove();

            }
        }
        private void PrefabsUImove()
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
                    a = 0;
                    if (path.Substring(0, UIPrefabspath.Length) == UIPrefabspath)
                    {
                        if (path.Substring(0, UIPrefabspath.Length+3) != UIPrefabspath + "ͨ��/")
                        {
                            if (!Directory.Exists(UIPrefabspath + "ͨ��/" + UIPrefabsname))
                            {
                                Directory.CreateDirectory(UIPrefabspath + "ͨ��/" + UIPrefabsname + "/");
                                AssetDatabase.SaveAssets();
                                AssetDatabase.Refresh();
                                AssetDatabase.MoveAsset(path, UIPrefabspath + "ͨ��/" + UIPrefabsname + "/" + texture.name + ".png");
                                AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + "ͨ��/" + UIPrefabsname + "/" + texture.name + ".png" + ".meta");
                            }

                            else
                            {
                                if (File.Exists(UIPrefabspath + "ͨ��/" + UIPrefabsname + "/" + texture.name + ".png"))
                                {
                                    Directory.CreateDirectory(UIPrefabspath + "ͨ��/" + UIPrefabsname + "/�����ظ�" + i + "/");
                                    AssetDatabase.SaveAssets();
                                    AssetDatabase.Refresh();
                                    AssetDatabase.MoveAsset(path, UIPrefabspath + "ͨ��/" + UIPrefabsname + "/�����ظ�" + i + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + "ͨ��/" + UIPrefabsname + "/�����ظ�" + i + "/" + texture.name + ".png" + ".meta");
                                    i++;
                                }
                                else
                                {
                                    AssetDatabase.MoveAsset(path, UIPrefabspath + "ͨ��/" + UIPrefabsname + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + "ͨ��/" + UIPrefabsname + "/" + texture.name + ".png" + ".meta");
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
                        //�ж��ų��ض��ļ��в��ƶ� 
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
                                    Directory.CreateDirectory(UIPrefabspath + UIPrefabsname + "/�����ظ�" + j + "/");
                                    AssetDatabase.SaveAssets();
                                    AssetDatabase.Refresh();
                                    AssetDatabase.MoveAsset(path, UIPrefabspath + UIPrefabsname + "/�����ظ�" + j + "/" + texture.name + ".png");
                                    AssetDatabase.MoveAsset(path + ".meta", UIPrefabspath + UIPrefabsname + "/�����ظ�" + j + "/" + texture.name + ".png" + ".meta");
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

        //������Դ·��
        private void TestingPathLog()
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
                //if (File.Exists(UIpath+"ͨ��/" +texture.name +".png"))
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

        //���ݳ�������UI
        //private void ScreenUImove()
        //{
        //    Object[] textures = GetSelectedTextures();
        //    if (textures.Length == 0)
        //    {
        //        EditorUtility.DisplayDialog("����", "ѡ��һ��������ͼ���ļ��л��ߵ�����ͼ��", "OK");
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
        //                if (path.Substring(0, UIpath.Length+3) != UIpath + "ͨ��/")
        //                {
        //                    if (!Directory.Exists(UIpath + "ͨ��/" + UIScenesname))
        //                    {
        //                        Directory.CreateDirectory(UIpath + "ͨ��/" + UIScenesname + "/");
        //                        AssetDatabase.SaveAssets();
        //                        AssetDatabase.Refresh();
        //                        AssetDatabase.MoveAsset(path, UIpath + "ͨ��/" + UIScenesname + "/" + texture.name + ".png");
        //                        AssetDatabase.MoveAsset(path + ".meta", UIpath + "ͨ��/" + UIScenesname + "/" + texture.name + ".png" + ".meta");
        //                    }

        //                    else
        //                    {
        //                        if (File.Exists(UIpath + "ͨ��/" + UIScenesname + "/" + texture.name + ".png"))
        //                        {
        //                            Directory.CreateDirectory(UIpath + "ͨ��/" + UIScenesname +  "/�����ظ�" + i + "/");
        //                            AssetDatabase.SaveAssets();
        //                            AssetDatabase.Refresh();
        //                            AssetDatabase.MoveAsset(path, UIpath + "ͨ��/" + UIScenesname +"/�����ظ�" + i + "/" + texture.name + ".png");
        //                            AssetDatabase.MoveAsset(path + ".meta", UIpath + "ͨ��/" + UIScenesname +"/�����ظ�" + i + "/" + texture.name + ".png" + ".meta");
        //                            i++;
        //                        }
        //                        else
        //                        {
        //                            AssetDatabase.MoveAsset(path, UIpath + "ͨ��/" + UIScenesname + "/" + texture.name + ".png");
        //                            AssetDatabase.MoveAsset(path + ".meta", UIpath + "ͨ��/" + UIScenesname + "/" + texture.name + ".png" + ".meta");
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

        //                //�ж��ų��ض��ļ��в��ƶ�
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
        //                            Directory.CreateDirectory(targetDirectory + "/�ظ���Դ" + j + "/");
        //                            AssetDatabase.SaveAssets();
        //                            AssetDatabase.Refresh();
        //                            AssetDatabase.MoveAsset(path, targetDirectory + "/�ظ���Դ" + j + "/" + texture.name + ".png");
        //                            AssetDatabase.MoveAsset(path + ".meta", targetDirectory + "/�ظ���Դ" + j + "/" + texture.name + ".png" + ".meta");
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