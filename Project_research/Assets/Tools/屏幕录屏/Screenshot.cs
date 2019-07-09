//=======================================================
// 作者：xuefei
// 描述：渲染工具1.0版本
//=======================================================
#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace xfScreenshot
{
   // [CustomEditor(typeof(NewBehaviourScript))]
    public class Screenshot : EditorWindow
    {

        public int resWidth = 1920;
        public int resHeight = 1080;

        public Camera myCamera;
        public int scale = 1;

        public string path = "";
       
        private  bool showPreview = true;
        private RenderTexture renderTexture;

        private bool isTransparent = false;
        private  bool isAnimation = false;

        //保存图片名称
        public string pngName = "";

        //图片序号
        public int pngCount = 0;

        //需要录制帧数
        public int frameCount = 1;

        //每秒帧数
        public int frameRate = 1;

        public float timeStart = 0 ;

        private string listpath = "Tools/屏幕录屏/Data/AnimationData.xml";
        private IDataDispose _dataDispose = new XMLDataDispose();
      
 
        [MenuItem("Tools/渲染工具")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(Screenshot));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.title = "渲染工具1.0";
        }

        float lastTime;

        void OnGUI()
        {
            EditorGUILayout.LabelField (">>>分辨率设置<<<", EditorStyles.boldLabel);
            resWidth = EditorGUILayout.IntField ("Width", resWidth);
            resHeight = EditorGUILayout.IntField ("Height", resHeight);

            scale = EditorGUILayout.IntSlider ("Scale", scale, 1, 15);

            EditorGUILayout.Space();


            pngName =  EditorGUILayout.TextField("保存图片名称 ", pngName);
            EditorGUILayout.LabelField (">>>动画设置<<<", EditorStyles.boldLabel);         
            isAnimation = EditorGUILayout.Toggle("动画序列", isAnimation);
            EditorGUILayout.HelpBox("如果需要录制动画序列，请勾选“动画序列选项”",MessageType.None);

            if (isAnimation)
            {
                //pngCount = EditorGUILayout.IntField ("图片序号", pngCount);
                frameRate = EditorGUILayout.IntField("每秒帧数", frameRate);
                frameCount = EditorGUILayout.IntField("录制时间(多少帧)", frameCount);

                EditorGUILayout.Space();
            }
           


            GUILayout.Label (">>>渲染保存路径<<<", EditorStyles.boldLabel);

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.TextField(path,GUILayout.ExpandWidth(false));
            if(GUILayout.Button("Browse",GUILayout.ExpandWidth(false)))
                path = EditorUtility.SaveFolderPanel("Path to Save Images",path,Application.dataPath);

            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space();

            GUILayout.Label (">>>选择渲染的摄像机<<<", EditorStyles.boldLabel);

            myCamera = EditorGUILayout.ObjectField(myCamera, typeof(Camera), true,null) as Camera;

            if(myCamera == null)
            {
                myCamera = Camera.main;
            }

            isTransparent = EditorGUILayout.Toggle("透明背景", isTransparent);

            EditorGUILayout.HelpBox("选择拍摄渲染的相机。您可以使用“透明”选项使背景透明，但摄像机Clear Flags设置必须是Solid Color（Background是透明的）或者Depth only",MessageType.None);

            EditorGUILayout.Space();
            EditorGUILayout.BeginVertical();
            EditorGUILayout.LabelField (">>>默认分辨率设置<<<", EditorStyles.boldLabel);

            if(GUILayout.Button("屏幕尺寸"))
            {
                
                resHeight = (int)Handles.GetMainGameViewSize().y;
                resWidth = (int)Handles.GetMainGameViewSize().x;

            }

            if(GUILayout.Button("默认大小1920*1080"))
            {
                resHeight = 1080;
                resWidth = 1920;
                scale = 1;
            }

            EditorGUILayout.EndVertical();

            EditorGUILayout.Space();
            EditorGUILayout.LabelField ("渲染的结果分辨率： " + resWidth*scale + " x " + resHeight*scale + " px", EditorStyles.boldLabel);
            if (isAnimation)
            {
                if (GUILayout.Button("创建帧动画脚本", GUILayout.MinHeight(60)))
                {
                    if (path == "")
                    {
                        path = EditorUtility.SaveFolderPanel("Path to Save Images", path, Application.dataPath);
                        RenderFrame();
                    }
                    else
                    {
                        RenderFrame();
                    }

                }
            }
            else
            {
                if (GUILayout.Button("渲染当前帧", GUILayout.MinHeight(60)))
                {
                    if (path == "")
                    {
                        path = EditorUtility.SaveFolderPanel("Path to Save Images", path, Application.dataPath);
                        Debug.Log("Path Set");
                        //ScreenshotAnimation.Instance.SendData(3333333);
                        TakeHiResShot();
                    }
                    else
                    {
                        //ScreenshotAnimation.Instance.SendData(3333333);
                        TakeHiResShot();
                    }
                }
            }

            EditorGUILayout.Space();
            EditorGUILayout.BeginHorizontal();

            if(GUILayout.Button("打开最近保存的渲染",GUILayout.MaxWidth(160),GUILayout.MinHeight(40)))
            {
                if(lastScreenshot != "")
                {
                    Application.OpenURL("file://" + lastScreenshot);
                    Debug.Log("Opening File " + lastScreenshot);
                }
            }

            if(GUILayout.Button("打开保存的渲染路径",GUILayout.MaxWidth(160),GUILayout.MinHeight(40)))
            {
                Debug.Log(timeStart);
                Application.OpenURL("file://" + path);
            }
            

            EditorGUILayout.EndHorizontal();

            
            if (takeHiResShot) 
            {
                               
                int resWidthN = resWidth*scale;
                int resHeightN = resHeight*scale;
                RenderTexture rt = new RenderTexture(resWidthN, resHeightN, 24);
                myCamera.targetTexture = rt;

                TextureFormat tFormat;
                if(isTransparent)
                    tFormat = TextureFormat.ARGB32;
                else
                    tFormat = TextureFormat.RGB24;

                Texture2D screenShot = new Texture2D(resWidthN, resHeightN, tFormat,false);
                myCamera.Render();
                RenderTexture.active = rt;
                screenShot.ReadPixels(new Rect(0, 0, resWidthN, resHeightN), 0, 0);
                myCamera.targetTexture = null;
                RenderTexture.active = null; 
                byte[] bytes = screenShot.EncodeToPNG();
                string filename = ScreenShotName(resWidthN, resHeightN);

                System.IO.File.WriteAllBytes(filename, bytes);
                Debug.Log(string.Format("Took screenshot to: {0}", filename));
                pngCount++;
                takeHiResShot = false;               

            }

            if(istime)
            {
                
                timeStart = Time.realtimeSinceStartup;
                Debug.Log(timeStart);  
                istime =false;
            }


        }
        private bool istime = false;
        private bool takeHiResShot = false;
        public string lastScreenshot = "";


        public string ScreenShotName(int width, int height) {

            string strPath="";

            if(isAnimation)
            {
                strPath = string.Format("{0}/{1}_{2}.png", 
                                                path, 
                                                pngName,
                                                    pngCount);
            
            } 
            else
            {
                strPath = string.Format("{0}/{1}_{2}x{3}_{4}.png", 
                                path, 
                                pngName,
                                width, height, 
                                        System.DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss"));
            
            }                        

            lastScreenshot = strPath;

            return strPath;
        }

        //渲染单帧
        public void TakeHiResShot() {

            Debug.Log("Taking Screenshot");            
            istime = true;
			takeHiResShot = true;
                     
        }
        //渲染序列帧
        public void RenderFrame()
        {
            if (GameObject.Find("帧动画"))
            {
                listget();
                return;
            }
            else
            {
                listget();
                GameObject go = new GameObject("帧动画");
                go.AddComponent<RenderSequenceFrame>();
            }

        }
        public void listget()
        {
            
            AnimationData animationData = new AnimationData();
            animationData.pngName = pngName;
            animationData.resWidth = resWidth;
            animationData.resHeight = resHeight;
            animationData.scale = scale;
            animationData.frameCount = frameCount;
            animationData.frameRate = frameRate;
            animationData.myCameraname = myCamera.name;
            animationData.path = path;
            _dataDispose.Write(Application.dataPath+"/"+ listpath, animationData);
        }

    }
    [System.Serializable]
    public class AnimationData
    {
        public string pngName;
        public int resWidth;
        public int resHeight;
        public int scale;
        public int frameCount;
        public int frameRate;
        public string myCameraname;
        public string path;
    }
}
#endif