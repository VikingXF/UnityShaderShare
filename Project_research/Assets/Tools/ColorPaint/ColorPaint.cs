﻿//=======================================================
// 作者：xf
// 描述：绘图工具
//=======================================================

#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
using System.IO;
using System.Collections;

namespace xfColorPaint
{

    public class ColorPaint : EditorWindow
    {
        int resWidth = 512;
        int resHeight = 512;

        public Color foregroundColor;
        public bool allowPainting = false;
        float brushSize = 16f;
        float brushOpacity = 0.5f;
        public string MeshPaintEditorFolder = "Assets/Tools/ColorPaint/Brushes/";
        public string PaintTextureFolder = "Assets/Tools/ColorPaint/";
        Texture[] brushTex;
        // Texture[] texLayer;
        int selBrush = 0;
        //int selTex = 0;
        string MaskTexName = "1";

        public bool exporNameSuccess = true;

        public RaycastHit curHit;
        public Vector2 mousePos;
        public bool changeingBrushValue = false;
        public bool down = false;

               [MenuItem("Tools/绘图工具")]
        public static void ShowWindow()
        {

            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(ColorPaint));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.title = "绘图工具";
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


            //判断绘制
            if (allowPainting)
            {

                if (Selection.activeTransform == null)
                {
                    EditorUtility.DisplayDialog("警告", "请选择一个需要绘制贴图的模型！", "OK");
                    allowPainting = false;
                }
                else
                {
                    PaintColor();

                }

            }

            if (allowPainting == false && down)
            {
                SaveTexture();
                Debug.Log("保存");
                down = false;
            }

        }




        void OnGUI()
        {
            
            GUILayout.Space(10f);

            //画笔设置
            foregroundColor = EditorGUILayout.ColorField("画笔颜色:", foregroundColor);
            brushSize = (int)EditorGUILayout.Slider("画笔大小", brushSize, 1, 36);//笔刷大小						
            brushOpacity = EditorGUILayout.Slider("画笔透明度", brushOpacity, 0, 1f);//笔刷透明度

            //画笔样式
            IniBrush();
            GUILayout.BeginHorizontal("box", GUILayout.Width(300));
            selBrush = GUILayout.SelectionGrid(selBrush, brushTex, 9, "gridlist", GUILayout.Width(300), GUILayout.Height(65));
            GUILayout.EndHorizontal();

            //绘制按钮
            allowPainting = GUILayout.Toggle(allowPainting, "绘制", GUI.skin.button, GUILayout.Height(60));
            if (allowPainting)
            {
                down = true;
            }


            //创建贴图
            if (GUILayout.Button("创建贴图"))
            {
                //判断是否重名
                if (File.Exists(PaintTextureFolder + MaskTexName + ".png"))
                {
                    EditorUtility.DisplayDialog("警告", "有重复名称贴图，请更改贴图名称！", "OK");
                    exporNameSuccess = false;
                }
                else
                {
                    exporNameSuccess = true;
                }
                creatMaskTex();
            }

            //贴图大小设置
            EditorGUILayout.LabelField("创建贴图的分辨率设置", EditorStyles.boldLabel);
            resWidth = EditorGUILayout.IntField("Width", resWidth);
            resHeight = EditorGUILayout.IntField("Height", resHeight);
            MaskTexName = EditorGUILayout.TextField("贴图名称 ", MaskTexName);

            if (GUILayout.Button("设置贴图"))
            {
               setMaskTex(PaintTextureFolder + MaskTexName + ".png");
            }

            //存放目录
            GUILayout.Label("笔刷存放路径", EditorStyles.boldLabel);
            EditorGUILayout.BeginHorizontal();
            MeshPaintEditorFolder = EditorGUILayout.TextField(MeshPaintEditorFolder, GUILayout.ExpandWidth(false));             
            EditorGUILayout.EndHorizontal();

            GUILayout.Label("贴图存放路径", EditorStyles.boldLabel);
            EditorGUILayout.BeginHorizontal();
            PaintTextureFolder = EditorGUILayout.TextField(PaintTextureFolder, GUILayout.ExpandWidth(false));
            EditorGUILayout.EndHorizontal();

            //标签
            GUILayout.FlexibleSpace();
            GUILayout.Box("2018.11.6@xf", GUILayout.Height(30), GUILayout.ExpandWidth(true));

          
        }

        //获取笔刷  
        void IniBrush()
        {

            ArrayList BrushList = new ArrayList();
            Texture BrushesTL;
            int BrushNum = 0;
            do
            {
                BrushesTL = (Texture)AssetDatabase.LoadAssetAtPath(MeshPaintEditorFolder + "Brush" + BrushNum + ".png", typeof(Texture));

                if (BrushesTL)
                {
                    BrushList.Add(BrushesTL);
                }
                BrushNum++;
            } while (BrushesTL);
            brushTex = BrushList.ToArray(typeof(Texture)) as Texture[];
        }

        //创建贴图
        void creatMaskTex()
        {
            if (exporNameSuccess)
            {
                Debug.Log("MaskTexName：" + MaskTexName);
                //创建一个新的贴图

                Texture2D newMaskTex = new Texture2D(resWidth, resHeight, TextureFormat.ARGB32, true);
                Color[] colorBase = new Color[resWidth * resHeight];
                for (int t = 0; t < colorBase.Length; t++)
                {
                    colorBase[t] = new Color(1, 0, 0, 0);
                }
                newMaskTex.SetPixels(colorBase);

                string path = PaintTextureFolder + MaskTexName + ".png";
                byte[] bytes = newMaskTex.EncodeToPNG();

                File.WriteAllBytes(path, bytes);//保存

                AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//导入资源

                //贴图的导入设置
                TextureImporter textureIm = AssetImporter.GetAtPath(path) as TextureImporter;
                textureIm.textureCompression = TextureImporterCompression.Uncompressed;
                textureIm.isReadable = true;
                textureIm.anisoLevel = 9;
                textureIm.mipmapEnabled = false;
                textureIm.wrapMode = TextureWrapMode.Clamp;
                AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//刷新
            }
        }

        //设置贴图
        void setMaskTex(string directory)
        {
            Texture2D MaskTex = (Texture2D)AssetDatabase.LoadAssetAtPath(directory, typeof(Texture2D));
            Selection.activeTransform.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_MaskTex", MaskTex);
        }

        




        int brushSizeInPourcent;
        Texture2D MaskTex;
        void PaintColor()
        {

            Transform CurrentSelect = Selection.activeTransform;

            MeshFilter temp = CurrentSelect.GetComponent<MeshFilter>();//获取当前模型的MeshFilter
            float orthographicSize = (brushSize * CurrentSelect.localScale.x) * (temp.sharedMesh.bounds.size.x / 200);//笔刷在模型上的正交大小
            MaskTex = (Texture2D)CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_MaskTex");//从材质球中获取MaskTex贴图

            brushSizeInPourcent = (int)Mathf.Round((brushSize * MaskTex.width) / 100);//笔刷在模型上的大小
            

            Event e = Event.current;//检测输入

            HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));
            curHit = new RaycastHit();

            Ray worldRay = HandleUtility.GUIPointToWorldRay(e.mousePosition);//从鼠标位置发射一条射线           
            //Debug.Log(worldRay);

            if (Physics.Raycast(worldRay, out curHit, Mathf.Infinity, 1 << LayerMask.NameToLayer("Default")))//射线检测名为"Default"的层
            {

                Handles.color = new Color(foregroundColor.r, foregroundColor.g, foregroundColor.b, brushOpacity);//颜色
                //Handles.DrawSolidDisc(curHit.point, curHit.normal, orthographicSize);
                //Handles.color = Color.green;
                Handles.DrawWireDisc(curHit.point, curHit.normal, orthographicSize);//根据笔刷大小在鼠标位置显示一个圆


                //鼠标点击或按下并拖动进行绘制
                if ((e.type == EventType.MouseDrag && e.alt == false && e.control == false && e.shift == false && e.button == 0) || (e.type == EventType.MouseDown && e.shift == false && e.alt == false && e.control == false && e.button == 0))
                {
                    //选择绘制的通道
                    Color targetColor = new Color(1f, 0f, 0f, 0f);

                    targetColor = foregroundColor;

                    Vector2 pixelUV = curHit.textureCoord;

                    //计算笔刷所覆盖的区域
                    int PuX = Mathf.FloorToInt(pixelUV.x * MaskTex.width);
                    int PuY = Mathf.FloorToInt(pixelUV.y * MaskTex.height);
                    int x = Mathf.Clamp(PuX - brushSizeInPourcent / 2, 0, MaskTex.width - 1);
                    int y = Mathf.Clamp(PuY - brushSizeInPourcent / 2, 0, MaskTex.height - 1);
                    int width = Mathf.Clamp((PuX + brushSizeInPourcent / 2), 0, MaskTex.width) - x;
                    int height = Mathf.Clamp((PuY + brushSizeInPourcent / 2), 0, MaskTex.height) - y;

                    Color[] terrainBay = MaskTex.GetPixels(x, y, width, height, 0);//获取贴图被笔刷所覆盖的区域的颜色

                    Texture2D TBrush = brushTex[selBrush] as Texture2D;//获取笔刷性状贴图
                    float[] brushAlpha = new float[brushSizeInPourcent * brushSizeInPourcent];//笔刷透明度

                    //根据笔刷贴图计算笔刷的透明度
                    for (int i = 0; i < brushSizeInPourcent; i++)
                    {
                        for (int j = 0; j < brushSizeInPourcent; j++)
                        {
                            brushAlpha[j * brushSizeInPourcent + i] = TBrush.GetPixelBilinear(((float)i) / brushSizeInPourcent, ((float)j) / brushSizeInPourcent).a;
                        }
                    }

                    //计算绘制后的颜色
                    for (int i = 0; i < height; i++)
                    {
                        for (int j = 0; j < width; j++)
                        {
                            int index = (i * width) + j;
                            float Stronger = brushAlpha[Mathf.Clamp((y + i) - (PuY - brushSizeInPourcent / 2), 0, brushSizeInPourcent - 1) * brushSizeInPourcent + Mathf.Clamp((x + j) - (PuX - brushSizeInPourcent / 2), 0, brushSizeInPourcent - 1)] * brushOpacity;

                            terrainBay[index] = Color.Lerp(terrainBay[index], targetColor, Stronger);
                        }
                    }
                    Undo.RegisterCompleteObjectUndo(MaskTex, "meshPaint");//保存历史记录以便撤销

                    MaskTex.SetPixels(x, y, width, height, terrainBay, 0);//把绘制后的MaskTex贴图保存起来
                    MaskTex.Apply();
                  

                }

                

            }
            


        }

        public void SaveTexture()
        {
            var path = AssetDatabase.GetAssetPath(MaskTex);
            var bytes = MaskTex.EncodeToPNG();
            File.WriteAllBytes(path, bytes);
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//刷新
        }



    }
}
#endif
