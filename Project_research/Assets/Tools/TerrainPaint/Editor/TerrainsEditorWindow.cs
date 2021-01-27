#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
using System.Linq;
using System.IO;
using System.Collections;
using System.Text;
using System;

public class TerrainsEditorWindow : EditorWindow
{
    GUIContent[] MenuIcon = new GUIContent[4];
    string TerrainEditorFolder = "Assets/Tools/TerrainPaint/Editor/";
    static public int TerrainMenuToolbar = 0;
    //static public string TerrainActived = "Deactivated";

    [MenuItem("Tools/地形工具")]
    static void ShowWindow()
    {
        //EditorWindow editorWindow = EditorWindow.GetWindow(typeof(TerrainsEditorWindow));
        //editorWindow.autoRepaintOnSceneChange = true;
        //editorWindow.Show();
        //editorWindow.title = "地形工具";

        TerrainsEditorWindow window = (TerrainsEditorWindow)EditorWindow.GetWindowWithRect(typeof(TerrainsEditorWindow), new Rect(0, 0, 386, 560), false, "地形工具");
        window.Show();
    }


    void OnEnable()
    {
        SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
        SceneView.onSceneGUIDelegate += this.OnSceneGUI;
    }
    void OnDestroy()
    {
        SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
        DestroyImmediate(PlantObjPreview);

    }
    void OnSceneGUI(SceneView sceneView)
    {

        if (TerrainMenuToolbar == 1 && allowPainting && Selection.activeTransform != null)
        {
            Painter();
        }
        if (allowPainting == false && down )
        {
            SaveTexture();
            Debug.Log("保存");
            down = false;
            allowPainting = false;
        }
       
        if (TerrainMenuToolbar == 2 && allowPlant == true)
        {
            planting();
        }
        if (allowPlant == false )
        {
            DestroyImmediate(PlantObjPreview);
            RandomJudge = true;
            RandomRotateJudge = true;

            allowPlant = false;
        }
        if (TerrainMenuToolbar != 1)
        {
            allowPainting = false;
        }
        if (TerrainMenuToolbar != 2)
        {
            allowPlant = false;
        }
    }


    void OnGUI()
    {
        MenuIcon[0] = new GUIContent(AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Icons/updown.png", typeof(Texture2D)) as Texture);
        MenuIcon[1] = new GUIContent(AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Icons/paint.png", typeof(Texture2D)) as Texture);
        MenuIcon[2] = new GUIContent(AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Icons/plant.png", typeof(Texture2D)) as Texture);
        MenuIcon[3] = new GUIContent(AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Icons/Settings.png", typeof(Texture2D)) as Texture);

        GUILayout.BeginArea(new Rect(10, 0, 363, 540));
        EditorGUILayout.Space();
        GUILayout.BeginHorizontal("box");
        TerrainMenuToolbar = (int)GUILayout.Toolbar(TerrainMenuToolbar, MenuIcon, GUILayout.Width(135), GUILayout.Height(28));


        GUILayout.FlexibleSpace();

            GUILayout.EndHorizontal();
        

        switch (TerrainMenuToolbar)
        {
            case 0:
                ConverteTerrainrGUI();
                break;

            case 1:

                PainterGUI();
                break;

            case 2:
                plantGUI();
                break;

            case 3:
                SetGUI();
                break;


        }
        GUILayout.EndArea();

       
    }
    //减面
    #region
    static public string terrainName;
    static public bool keepTerrainTexture;
    static public int VertsNumber = 90;
    float tRes = 4.1f;
    float HeightmapWidth = 0;
    float HeightmapHeight = 0;
    int X;
    int Y;
    static public TerrainData terrain;
    string FinalExpName;
    int tCount;
    int counter;
    int totalCount;
    float progressUpdateInterval = 10000;
    GameObject Child;
    GameObject UnityTerrain;
    TerrainData terrainDat;

    void ConverteTerrainrGUI()
    {
        if (Selection.activeTransform != null)
        {
            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.Label(">>>>>>>>>>       Unity地形减面           <<<<<<<<<<", EditorStyles.boldLabel);
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();

            if (Selection.activeTransform.gameObject.GetComponent<Terrain>())
            {
                terrainDat = Selection.activeTransform.gameObject.GetComponent<Terrain>().terrainData;
                HeightmapWidth = terrainDat.heightmapResolution;
                HeightmapHeight = terrainDat.heightmapResolution;
                EditorGUILayout.Space();
                GUILayout.Label("Set", EditorStyles.boldLabel);
                GUILayout.BeginVertical("box");
                GUILayout.BeginHorizontal();
                GUILayout.Label("地形减面后的模型名：", GUILayout.Width(120));

                terrainName = GUILayout.TextField(terrainName, GUILayout.ExpandWidth(true));

                GUILayout.EndHorizontal();
                GUILayout.BeginHorizontal();
                GUILayout.Label("选择是否保存地形贴图", EditorStyles.boldLabel, GUILayout.Width(150));
                keepTerrainTexture = EditorGUILayout.Toggle(keepTerrainTexture, GUILayout.Width(53));
                GUILayout.EndHorizontal();
                GUILayout.Label("(只能保存Unity 地形的前面四张贴图)", GUILayout.Width(300));

                GUILayout.EndVertical();

                GUILayout.Label("Quality", EditorStyles.boldLabel);
                GUILayout.BeginVertical("box");
                GUILayout.BeginHorizontal();
                GUILayout.Label(" <<");
                GUILayout.FlexibleSpace();
                VertsNumber = EditorGUILayout.IntField(VertsNumber, GUILayout.Width(30));
                GUILayout.Label("x " + VertsNumber + " : " + (X * Y).ToString() + " Verts");
                GUILayout.FlexibleSpace();
                GUILayout.Label(" >>");
                GUILayout.EndHorizontal();
                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                VertsNumber = (int)GUILayout.HorizontalScrollbar(VertsNumber, 0, 32, 350, GUILayout.Width(350));
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();
                EditorGUILayout.Space();
                EditorGUILayout.Space();
                tRes = (HeightmapWidth) / VertsNumber;
                X = (int)((HeightmapWidth - 1) / tRes + 1);
                Y = (int)((HeightmapHeight - 1) / tRes + 1);

                GUILayout.EndVertical();
                EditorGUILayout.Space();
                EditorGUILayout.Space();

                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                GUILayout.Label("设定清楚后请点击（减面）按钮", EditorStyles.boldLabel);
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();

                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                if (GUILayout.Button("减面", GUILayout.Width(300), GUILayout.Height(50)))
                {
                    ConverteTerrain();
                }
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();
            }
            else
            {
                GUILayout.BeginVertical("box");
                EditorGUILayout.HelpBox("请选择Terrain！", MessageType.Error);
                GUILayout.EndVertical();
            }
        }
        else
        {
            EditorGUILayout.HelpBox("请选择Terrain！", MessageType.Error);
        }
        
        
    }
   
    void ConverteTerrain()
    {
        Transform CurrentSelect = Selection.activeTransform;
        if (terrainName == "")
            terrainName = CurrentSelect.name;

        if (!System.IO.Directory.Exists(TerrainEditorFolder + "Terrains/"))
        {
            System.IO.Directory.CreateDirectory(TerrainEditorFolder + "Terrains/");
        }
        if (!System.IO.Directory.Exists(TerrainEditorFolder + "Terrains/Material/"))
        {
            System.IO.Directory.CreateDirectory(TerrainEditorFolder + "Terrains/Material/");
        }
        if (!System.IO.Directory.Exists(TerrainEditorFolder + "Terrains/Texture/"))
        {
            System.IO.Directory.CreateDirectory(TerrainEditorFolder + "Terrains/Texture/");
        }
        if (!System.IO.Directory.Exists(TerrainEditorFolder + "Terrains/Meshes/"))
        {
            System.IO.Directory.CreateDirectory(TerrainEditorFolder + "Terrains/Meshes/");
        }
        AssetDatabase.Refresh();

        terrain = CurrentSelect.GetComponent<Terrain>().terrainData;

        int w = terrain.heightmapResolution;
        int h = terrain.heightmapResolution;
        //Debug.Log("w："+w);
       //Debug.Log("h：" + h);
        Vector3 meshScale = terrain.size;
        meshScale = new Vector3(meshScale.x / (h - 1) * tRes, meshScale.y, meshScale.z / (w - 1) * tRes);
        Vector2 uvScale = new Vector2((float)(1.0 / (w - 1)), (float)(1.0 / (h - 1)));

        float[,] tData = terrain.GetHeights(0, 0, w, h);
        w = (int)((w - 1) / tRes + 1);
        h = (int)((h - 1) / tRes + 1);
        Vector3[] tVertices = new Vector3[w * h];
        Vector2[] tUV = new Vector2[w * h];
        int[] tPolys = new int[(w - 1) * (h - 1) * 6];
       
        int y = 0;
        int x = 0;
        for (y = 0; y < h; y++)
        {
            for (x = 0; x < w; x++)
            {
                tVertices[y * w + x] = Vector3.Scale(meshScale, new Vector3(x, tData[(int)(x * tRes), (int)(y * tRes)], y));
                tUV[y * w + x] = Vector2.Scale(new Vector2(y * tRes, x * tRes), uvScale);
            }
        }

        y = 0;
        x = 0;
        int index = 0;

        for (y = 0; y < h - 1; y++)
        {
            for (x = 0; x < w - 1; x++)
            {
                //Debug.Log(tPolys);
                //Debug.Log(index);
                tPolys[index++] = (y * w) + x;
                tPolys[index++] = ((y + 1) * w) + x;
                tPolys[index++] = (y * w) + x + 1;

                tPolys[index++] = ((y + 1) * w) + x;
                tPolys[index++] = ((y + 1) * w) + x + 1;
                tPolys[index++] = (y * w) + x + 1;
            }
        }

        bool ExportNameSuccess = false;
        int num = 1;
        string Next;
        do
        {
            Next = terrainName + num;

            if (!System.IO.File.Exists(TerrainEditorFolder + "Terrains/" + terrainName + ".prefab"))
            {
                FinalExpName = terrainName;
                ExportNameSuccess = true;
            }
            else if (!System.IO.File.Exists(TerrainEditorFolder + "Terrains/" + Next + ".prefab"))
            {
                FinalExpName = Next;
                ExportNameSuccess = true;
            }
            num++;
        } while (!ExportNameSuccess);


        StreamWriter sw = new StreamWriter(FinalExpName + ".obj");
        try
        {          
            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-US");
            counter = tCount = 0;
            totalCount = (int)((tVertices.Length * 2 + (tPolys.Length / 3)) / progressUpdateInterval);
            for (int i = 0; i < tVertices.Length; i++)
            {
                UpdateProgress();
                StringBuilder sb = new StringBuilder("v ", 20);
                sb.Append(tVertices[i].x.ToString()).Append(" ").
                   Append(tVertices[i].y.ToString()).Append(" ").
                   Append(tVertices[i].z.ToString());
                sw.WriteLine(sb);
            }

            for (int i = 0; i < tUV.Length; i++)
            {
                UpdateProgress();
                StringBuilder sb = new StringBuilder("vt ", 22);
                sb.Append(tUV[i].x.ToString()).Append(" ").
                   Append(tUV[i].y.ToString());
                sw.WriteLine(sb);
            }
            for (int i = 0; i < tPolys.Length; i += 3)
            {
                UpdateProgress();
                StringBuilder sb = new StringBuilder("f ", 43);
                sb.Append(tPolys[i] + 1).Append("/").Append(tPolys[i] + 1).Append(" ").
                   Append(tPolys[i + 1] + 1).Append("/").Append(tPolys[i + 1] + 1).Append(" ").
                   Append(tPolys[i + 2] + 1).Append("/").Append(tPolys[i + 2] + 1);
                sw.WriteLine(sb);
            }
        }
        catch (Exception err)
        {
            Debug.Log("Error saving file: " + err.Message);
        }
        sw.Close();
        AssetDatabase.SaveAssets();

        string path = TerrainEditorFolder + "Terrains/Texture/" + FinalExpName + ".png";

        //_Control纹理创建或复原
        string AssetName = AssetDatabase.GetAssetPath(CurrentSelect.GetComponent<Terrain>().terrainData) as string;
        UnityEngine.Object[] AssetName2 = AssetDatabase.LoadAllAssetsAtPath(AssetName);
        if (AssetName2 != null && AssetName2.Length > 1 && keepTerrainTexture)
        {
            for (var b = 0; b < AssetName2.Length; b++)
            {
                if (AssetName2[b].name == "SplatAlpha 0")
                {                  
                    Texture2D texture = AssetName2[b] as Texture2D;
                    byte[] bytes = texture.EncodeToPNG();
                    File.WriteAllBytes(path, bytes);
                    AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
                }
            }
        }
        else
        {
           
            Texture2D NewMaskText = new Texture2D(512, 512, TextureFormat.ARGB32, true);
            Color[] ColorBase = new Color[512 * 512];
            for (var t = 0; t < ColorBase.Length; t++)
            {
                ColorBase[t] = new Color(1, 0, 0, 0);
            }
            NewMaskText.SetPixels(ColorBase);
            byte[] data = NewMaskText.EncodeToPNG();
            File.WriteAllBytes(path, data);
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
        }
        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);

        UpdateProgress();

        //修改纹理
        TextureImporter TextureI = AssetImporter.GetAtPath(path) as TextureImporter;
       
        TextureI.SetPlatformTextureSettings("Android", 1024, TextureImporterFormat.RGBA32);
        TextureI.SetPlatformTextureSettings("iPhone", 1024, TextureImporterFormat.RGBA32);
        //TextureI.textureFormat = TextureImporterFormat.ARGB32;
        TextureI.isReadable = true;
        TextureI.anisoLevel = 9;
        TextureI.mipmapEnabled = false;
        TextureI.wrapMode = TextureWrapMode.Clamp;
        AssetDatabase.Refresh();

        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);

        UpdateProgress();

        //创建材质球
        Material Tmaterial;
        Tmaterial = new Material(Shader.Find("Babybus/Terrain Blend/Unlit Blend Shader"));
        AssetDatabase.CreateAsset(Tmaterial, TerrainEditorFolder + "Terrains/Material/" + FinalExpName + ".mat");
        AssetDatabase.ImportAsset(TerrainEditorFolder + "Terrains/Material/" + FinalExpName + ".mat", ImportAssetOptions.ForceUpdate);
        AssetDatabase.Refresh();

        //恢复地形纹理
        if (keepTerrainTexture)
        {
            SplatPrototype[] texts = CurrentSelect.GetComponent<Terrain>().terrainData.splatPrototypes;
            for (int i = 0; i < texts.Length; i++)
            {
                if (i < 3)
                {
                    Tmaterial.SetTexture("_Splat" + i, texts[i].texture);
                    Tmaterial.SetTextureScale("_Splat" + i, texts[i].tileSize * 8.9f);
                }
                if (i == 3)
                {
                    Tmaterial.SetTexture("_Splat" + i, texts[i].texture);
                    Tmaterial.SetVector("_Tiling3" , texts[3].tileSize * 8.9f);                  
                }
            }
        }

        //_Control材质的设置
        Texture test = (Texture)AssetDatabase.LoadAssetAtPath(path, typeof(Texture));
        Tmaterial.SetTexture("_Control", test);


        UpdateProgress();


        //obj在网格目录中的位置
        FileUtil.CopyFileOrDirectory(FinalExpName + ".obj", TerrainEditorFolder + "Terrains/Meshes/" + FinalExpName + ".obj");
        FileUtil.DeleteFileOrDirectory(FinalExpName + ".obj");



        //强制更新
        AssetDatabase.ImportAsset(TerrainEditorFolder + "Terrains/Meshes/" + FinalExpName + ".obj", ImportAssetOptions.ForceUpdate);

        UpdateProgress();

        //实例化转换后的模型
        GameObject prefab = (GameObject)AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Terrains/Meshes/" + FinalExpName + ".obj", typeof(GameObject));

        AssetDatabase.Refresh();


        GameObject forRotate = (GameObject)Instantiate(prefab, CurrentSelect.transform.position, Quaternion.identity) as GameObject;
        Transform childCheck = forRotate.transform.Find("default");
        Child = childCheck.gameObject;
        forRotate.transform.DetachChildren();
        DestroyImmediate(forRotate);
        Child.name = FinalExpName;
        Add();
        Child.layer =  LayerMask.NameToLayer("TerrainModle");
        Child.AddComponent<MeshCollider>();        
        Child.GetComponent<MeshRenderer>().sharedMaterial = Tmaterial;
        Child.transform.rotation = Quaternion.Euler(0, 90, 0);

        UpdateProgress();

        //Application des Parametres sur le Script
        //Child.GetComponent<T4MObjSC>().T4MMaterial = Tmaterial;
        // Child.GetComponent<T4MObjSC>().ConvertType = "UT";

        //Regalges Divers
        //vertexInfo = 0;
        //partofT4MObj = 0;
        //trisInfo = 0;
        //int countchild = Child.transform.childCount;
        //if (countchild > 0)
        //{
        //    Renderer[] T4MOBJPART = Child.GetComponentsInChildren<Renderer>();
        //    for (int i = 0; i < T4MOBJPART.Length; i++)
        //    {
        //        if (!T4MOBJPART[i].gameObject.AddComponent<MeshCollider>())
        //            T4MOBJPART[i].gameObject.AddComponent<MeshCollider>();
        //        T4MOBJPART[i].gameObject.isStatic = true;
        //        T4MOBJPART[i].material = Tmaterial;
        //        T4MOBJPART[i].gameObject.layer = 30;
        //        T4MOBJPART[i].gameObject.AddComponent<T4MPartSC>();
        //        Child.GetComponent<T4MObjSC>().T4MMesh = T4MOBJPART[0].GetComponent<MeshFilter>();
        //        partofT4MObj += 1;
        //        vertexInfo += T4MOBJPART[i].gameObject.GetComponent<MeshFilter>().sharedMesh.vertexCount;
        //        trisInfo += T4MOBJPART[i].gameObject.GetComponent<MeshFilter>().sharedMesh.triangles.Length / 3;
        //    }
        //}
        //else
        //{
        //    Child.AddComponent<MeshCollider>();
        //    Child.isStatic = true;
        //    Child.GetComponent<Renderer>().material = Tmaterial;
        //    Child.layer = 30;
        //    vertexInfo += Child.GetComponent<MeshFilter>().sharedMesh.vertexCount;
        //    trisInfo += Child.GetComponent<MeshFilter>().sharedMesh.triangles.Length / 3;
        //    partofT4MObj += 1;
        //}

        //UpdateProgress();


        GameObject BasePrefab2 = PrefabUtility.CreatePrefab(TerrainEditorFolder + "Terrains/" + FinalExpName + ".prefab", Child);
        AssetDatabase.ImportAsset(TerrainEditorFolder + "Terrains/" + FinalExpName + ".prefab", ImportAssetOptions.ForceUpdate);
        GameObject forRotate2 = (GameObject)PrefabUtility.InstantiatePrefab(BasePrefab2) as GameObject;

        DestroyImmediate(Child.gameObject);

        Child = forRotate2.gameObject;

        CurrentSelect.GetComponent<Terrain>().enabled = false;


        EditorUtility.SetSelectedWireframeHidden(Child.GetComponent<Renderer>(), true);


        UnityTerrain = CurrentSelect.gameObject;

        EditorUtility.ClearProgressBar();

        AssetDatabase.DeleteAsset(TerrainEditorFolder + "Terrains/Meshes/Materials");
        terrainName = "";
        AssetDatabase.StartAssetEditing();
        //在预制之前修改网格的属性
        ModelImporter OBJI = ModelImporter.GetAtPath(TerrainEditorFolder + "Terrains/Meshes/" + FinalExpName + ".obj") as ModelImporter;
        OBJI.globalScale = 1;
        OBJI.splitTangentsAcrossSeams = true;
        OBJI.normalImportMode = ModelImporterTangentSpaceMode.Calculate;
        OBJI.tangentImportMode = ModelImporterTangentSpaceMode.Calculate;
        OBJI.generateAnimations = ModelImporterGenerateAnimations.None;
        OBJI.meshCompression = ModelImporterMeshCompression.Off;
        OBJI.normalSmoothingAngle = 180f;
        AssetDatabase.ImportAsset(TerrainEditorFolder + "Terrains/Meshes/" + FinalExpName + ".obj", ImportAssetOptions.ForceSynchronousImport);
        AssetDatabase.StopAssetEditing();
        PrefabUtility.ResetToPrefabState(Child);
    }

    void UpdateProgress()
    {
        if (counter++ == progressUpdateInterval)
        {
            counter = 0;
            EditorUtility.DisplayProgressBar("Generate...", "", Mathf.InverseLerp(0, totalCount, ++tCount));
        }
    }

    //添加层
    static void Add()
    {
        AutoAddLayer("TerrainModle");
    }

    static void AutoAddLayer(string layer)
    {
        if (!HasThisLayer(layer))
        {
            SerializedObject tagMagager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/Tagmanager.asset"));
            SerializedProperty it = tagMagager.GetIterator();
            while (it.NextVisible(true))
            {
                if (it.name.Equals("layers"))
                {
                    for (int i = 0; i < it.arraySize; i++)
                    {
                        if (i <= 7)
                        {
                            continue;
                        }
                        SerializedProperty sp = it.GetArrayElementAtIndex(i);
                        if (string.IsNullOrEmpty(sp.stringValue))
                        {
                            sp.stringValue = layer;
                            tagMagager.ApplyModifiedProperties();                          
                            return;
                        }
                    }
                }
            }
        }
    }
    //判断是否存在层
    static bool HasThisLayer(string layer)
    {
        //先清除已保存的
        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/Tagmanager.asset"));
        SerializedProperty it = tagManager.GetIterator();
        while (it.NextVisible(true))
        {
            if (it.name.Equals("layers"))
            {
                for (int i = 0; i < it.arraySize; i++)
                {
                    if (i <= 7)
                    {
                        continue;
                    }
                    SerializedProperty sp = it.GetArrayElementAtIndex(i);
                    if (!string.IsNullOrEmpty(sp.stringValue))
                    {
                        if (sp.stringValue.Equals(layer))
                        {
                            sp.stringValue = string.Empty;
                            tagManager.ApplyModifiedProperties();
                        }
                    }
                }
            }
        }
        for (int i = 0; i < UnityEditorInternal.InternalEditorUtility.layers.Length; i++)
        {
            if (UnityEditorInternal.InternalEditorUtility.layers[i].Contains(layer))
            {
                return true;
            }
        }
        return false;
    }

    #endregion

    //地形贴图绘制
    #region 

    void PainterGUI()
    {
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        MenChoose = GUILayout.Toolbar(MenChoose, PainterGUIMen, GUILayout.Width(290), GUILayout.Height(20));
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        switch (MenChoose)
        {
            case 0:
                MenChoosePainter();
                break;
            case 1:
                MenChooseMaterials();
                break;
        }
    }

    //Painter
    #region
    Texture[] brushTex;
    float brushSize = 16f;
    float brushOpacity = 0.5f;
    int selBrush = 0;

    
    public bool down = false;
    public bool allowPainting = false;
    public bool Tiling;
    Vector2 Layer1Tile;
    Vector2 Layer2Tile;
    Vector2 Layer3Tile;
    Vector2 Layer4Tile;

    void MenChoosePainter()
    {
        LockButton = false;
        if (Selection.activeTransform != null )
        {
            if (Cheak())
            {
                if (!Tiling)
                {
                    TilingSel();
                }
               
                GUILayout.Space(5);
                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();

                allowPainting = GUILayout.Toggle(allowPainting, EditorGUIUtility.IconContent("TerrainInspector.TerrainToolSplat"), GUI.skin.button, GUILayout.Width(340), GUILayout.Height(40));//编辑模式开关               
                if (allowPainting)
                {
                    down = true;
                }
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();
                GUILayout.Space(3);
                IniBrush();
                layerTex();

                GUILayout.BeginHorizontal("box", GUILayout.Width(340));
                selTex = GUILayout.SelectionGrid(selTex, texLayer, 4, "gridlist", GUILayout.Width(346), GUILayout.Height(86));
                GUILayout.EndHorizontal();

                GUILayout.BeginHorizontal("box", GUILayout.Width(318));
                selBrush = GUILayout.SelectionGrid(selBrush, brushTex, 9, "gridlist", GUILayout.Width(346), GUILayout.Height(70));
                GUILayout.EndHorizontal();
                GUILayout.BeginVertical("box");
                brushSize = (int)EditorGUILayout.Slider("Brush Size", brushSize, 1, 36);//笔刷大小						
                brushOpacity = EditorGUILayout.Slider("Brush Opacity", brushOpacity, 0, 1f);//笔刷强度
                GUILayout.EndVertical();

                GUILayout.BeginVertical("box",GUILayout.Height(500));
                Tiling = EditorGUILayout.Toggle("Tiling :  Same Scale X/Y", Tiling);
                GUILayout.Space(5);

                Transform CurrentSelect = Selection.activeTransform;
                if (Tiling)
                {
                    Layer1Tile.x = Layer1Tile.y = EditorGUILayout.Slider("Layer 1(RGBA) Tiling :", Layer1Tile.x, 1, 500);
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTextureScale("_Splat0", new Vector2(Layer1Tile.x, Layer1Tile.x));
                    EditorGUILayout.Space();

                    Layer2Tile.x = Layer1Tile.y = EditorGUILayout.Slider("Layer 2(RGBA) Tiling :", Layer2Tile.x, 1, 500);
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTextureScale("_Splat1", new Vector2(Layer2Tile.x, Layer2Tile.x));
                    EditorGUILayout.Space();

                    Layer3Tile.x = Layer1Tile.y = EditorGUILayout.Slider("Layer 3(RGBA) Tiling :", Layer3Tile.x, 1, 500);
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTextureScale("_Splat2", new Vector2(Layer3Tile.x, Layer3Tile.x));
                    EditorGUILayout.Space();

                    Layer4Tile.x = Layer1Tile.y = EditorGUILayout.Slider("Layer 4(RGBA) Tiling :", Layer4Tile.x, 1, 500);                   
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetVector("_Tiling3", new Vector2(Layer4Tile.x, Layer4Tile.x));
                    EditorGUILayout.Space();
                }
                else
                {
                    Layer1Tile.x = EditorGUILayout.Slider("Layer 1(RGBA) TilingX :", Layer1Tile.x, 1, 500);
                    Layer1Tile.y = EditorGUILayout.Slider("Layer 1(RGBA) TilingY :", Layer1Tile.y, 1, 500);
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTextureScale("_Splat0", new Vector2(Layer1Tile.x, Layer1Tile.y));
                    EditorGUILayout.Space();

                    Layer2Tile.x = EditorGUILayout.Slider("Layer 2(RGBA) TilingX :", Layer2Tile.x, 1, 500);
                    Layer2Tile.y = EditorGUILayout.Slider("Layer 2(RGBA) TilingY :", Layer2Tile.y, 1, 500);
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTextureScale("_Splat1", new Vector2(Layer2Tile.x, Layer2Tile.y));
                    EditorGUILayout.Space();

                    Layer3Tile.x = EditorGUILayout.Slider("Layer 3(RGBA) TilingX :", Layer3Tile.x, 1, 500);
                    Layer3Tile.y = EditorGUILayout.Slider("Layer 3(RGBA) TilingY :", Layer3Tile.y, 1, 500);
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTextureScale("_Splat2", new Vector2(Layer3Tile.x, Layer3Tile.y));
                    EditorGUILayout.Space();

                    Layer4Tile.x = EditorGUILayout.Slider("Layer 4(RGBA) TilingX :", Layer4Tile.x, 1, 500);
                    Layer4Tile.y = EditorGUILayout.Slider("Layer 4(RGBA) TilingY :", Layer4Tile.y, 1, 500);
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetVector("_Tiling3", new Vector2(Layer4Tile.x, Layer4Tile.y));
                    EditorGUILayout.Space();

                }
                GUILayout.FlexibleSpace();
                GUILayout.EndVertical();


            }
        }
        else
        {
            EditorGUILayout.HelpBox("请选择需要绘制的模型！", MessageType.Error);
        }
    }
    void TilingSel()
    {
        Transform TilingSelect = Selection.activeTransform;
        Layer1Tile = TilingSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTextureScale("_Splat0");
        Layer2Tile = TilingSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTextureScale("_Splat1");
        Layer3Tile = TilingSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTextureScale("_Splat2");
        Layer4Tile = TilingSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetVector("_Tiling3");
    }


    //检查
    bool Cheak()
    {
        
        bool Cheak = false;
        Transform Select = Selection.activeTransform;

        if (Select.gameObject.GetComponent<MeshRenderer>() != null)
        {
            if (Select.gameObject.GetComponent<MeshRenderer>().sharedMaterial.shader == Shader.Find("Babybus/Terrain Blend/Unlit Blend Shader") || Select.gameObject.GetComponent<MeshRenderer>().sharedMaterial.shader == Shader.Find("Babybus/Terrain Blend/blend_diffuse") || Select.gameObject.GetComponent<MeshRenderer>().sharedMaterial.shader == Shader.Find("Babybus/Terrain Blend/blend_normal"))
            {
                Texture ControlTex = Select.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_Control");
                if (ControlTex == null)
                {
                    EditorGUILayout.HelpBox("当前模型材质球中未找到Control贴图，绘制功能不可用！", MessageType.Error);
                }
                else
                {
                    Cheak = true;
                }
            }
            else
            {
                EditorGUILayout.HelpBox("当前模型shader错误！请更换！", MessageType.Error);
            }
        }
        else
        {
            EditorGUILayout.HelpBox("当前模型无材质球，绘制功能不可用！", MessageType.Error);
        }
        
        return Cheak;
    }

    Texture2D MaskTex;
    int brushSizeInPourcent;

    void Painter()
    {
       
        Transform PainterSelect = Selection.activeTransform;
        
        MeshFilter temp = PainterSelect.GetComponent<MeshFilter>();//获取当前模型的MeshFilter
        float orthographicSize = (brushSize * PainterSelect.localScale.x) * (temp.sharedMesh.bounds.size.x / 200);//笔刷在模型上的正交大小
        MaskTex = (Texture2D)PainterSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_Control");//从材质球中获取MaskTex贴图

        brushSizeInPourcent = (int)Mathf.Round((brushSize * MaskTex.width) / 100);//笔刷在模型上的大小


        Event e = Event.current;//检测输入

        HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));
        RaycastHit curHit = new RaycastHit();
      
        Ray worldRay = HandleUtility.GUIPointToWorldRay(e.mousePosition);//从鼠标位置发射一条射线   

        //Debug.Log(worldRay);

        if (Physics.Raycast(worldRay, out curHit, Mathf.Infinity, 1 << LayerMask.NameToLayer("TerrainModle")))//射线检测名为"TerrainModle"的层
        {

            Handles.color = new Color(1f, 1f, 0f, brushOpacity);//颜色
            //Handles.DrawSolidDisc(curHit.point, curHit.normal, orthographicSize);
            //Handles.color = Color.green;

            Handles.DrawWireDisc(curHit.point, curHit.normal, orthographicSize);//根据笔刷大小在鼠标位置显示一个圆


            //鼠标点击或按下并拖动进行绘制
            if ((e.type == EventType.MouseDrag && e.alt == false && e.control == false && e.shift == false && e.button == 0) || (e.type == EventType.MouseDown && e.shift == false && e.alt == false && e.control == false && e.button == 0))
            {
                //选择绘制的通道
                Color targetColor = new Color(1f, 0f, 0f, 0f);

                switch (selTex)
                {
                    case 0:
                        targetColor = new Color(1f, 0f, 0f, 0f);
                        break;
                    case 1:
                        targetColor = new Color(0f, 1f, 0f, 0f);
                        break;
                    case 2:
                        targetColor = new Color(0f, 0f, 1f, 0f);
                        break;
                    case 3:
                        targetColor = new Color(0f, 0f, 0f, 1f);
                        break;

                }


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

    //获取材质球中的贴图
    void layerTex()
    {
        Transform layerTexSelect = Selection.activeTransform;
        texLayer = new Texture[4];
        texLayer[0] = AssetPreview.GetAssetPreview(layerTexSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_Splat0")) as Texture;
        texLayer[1] = AssetPreview.GetAssetPreview(layerTexSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_Splat1")) as Texture;
        texLayer[2] = AssetPreview.GetAssetPreview(layerTexSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_Splat2")) as Texture;
        texLayer[3] = AssetPreview.GetAssetPreview(layerTexSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_Splat3")) as Texture;
    }

    //获取笔刷  
    void IniBrush()
    {

        ArrayList BrushList = new ArrayList();
        Texture BrushesTL;
        int BrushNum = 0;
        do
        {
            BrushesTL = (Texture)AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Brushes/"+"Brush" + BrushNum + ".png", typeof(Texture));

            if (BrushesTL)
            {
                BrushList.Add(BrushesTL);
            }
            BrushNum++;
        } while (BrushesTL);
        brushTex = BrushList.ToArray(typeof(Texture)) as Texture[];
    }
    #endregion

    //Materials
    #region

    static public string[] PainterGUIMen = { "Painter", "Materials" };
    static public int MenChoose;
    static public Texture AddTexture;
    static public Texture ControlTex;
    static public Texture[] texLayer = new Texture[4];
    static private Texture[] ThumbnailTex = new Texture[4];
    static public int selTex;
    public string ContolTexFolder = "";
    public string contolTexName = "";
    public bool LockButton = false;
    public bool ClickLockButton = false;

    public enum TerrainShader
    {
        UnlitBlendshader,
        blend_diffuse,
        blend_normal
    }
    static public TerrainShader TerrainShaderSet = TerrainShader.UnlitBlendshader;
    void MenChooseMaterials()
    {
        if (Selection.activeTransform != null)
        {
            Transform CurrentSelect = Selection.activeTransform;
            EditorGUILayout.Space();
            GUILayout.BeginVertical("box");
            if (GUILayout.Button("创建MeshCollider"))
            {

                if (CurrentSelect.gameObject.GetComponent<MeshCollider>() == null)
                {
                    CurrentSelect.gameObject.AddComponent<MeshCollider>();
                  
                }
                else
                {
                    EditorUtility.DisplayDialog("警告", "该模型已经创建了碰撞器", "OK");
                }


            }
            if (GUILayout.Button("设置Layer为TerrainModle(绘图需求)"))
            {
                Add();
                CurrentSelect.gameObject.layer = LayerMask.NameToLayer("TerrainModle");
            }
                GUILayout.Space(5);
            TerrainShaderSet = (TerrainShader)EditorGUILayout.EnumPopup("Shader", TerrainShaderSet, GUILayout.Width(340));

            GUILayout.BeginHorizontal();
            if (GUILayout.Button("同步材质", GUILayout.Width(100)))
            {

                for (int i = 0; i < 4; i++)
                {
                    //Transform CurrentSelect = Selection.activeTransform;
                    texLayer[i] = CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_Splat" + i) as Texture;
                    ControlTex = CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.GetTexture("_Control") as Texture;
                }

            }
            GUILayout.FlexibleSpace();
            if (GUILayout.Button("更改模型shader(更改前请同步材质)", GUILayout.Width(200)))
            {

                //Transform CurrentSelect = Selection.activeTransform;
                if (TerrainShaderSet == TerrainShader.UnlitBlendshader)
                {
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.shader = Shader.Find("Babybus/Terrain Blend/Unlit Blend Shader");

                    //for (int i = 0; i < 4; i++)
                    //{
                    //   // CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_Splat" + i, texLayer[i]);
                    //}

                }
                else if (TerrainShaderSet == TerrainShader.blend_diffuse)
                {
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.shader = Shader.Find("Babybus/Terrain Blend/blend_diffuse");
                    //for (int i = 0; i < 4; i++)
                    //{
                    //    //CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_Splat" + i, texLayer[i]);
                    //}
                }
                else if (TerrainShaderSet == TerrainShader.blend_normal)
                {
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.shader = Shader.Find("Babybus/Terrain Blend/blend_normal");
                    //for (int i = 0; i < 4; i++)
                    //{
                    //   // CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_Splat" + i, texLayer[i]);
                    //}
                }



            }
            GUILayout.EndHorizontal();
            GUILayout.EndVertical();
            GUILayout.Space(5);

            GUILayout.BeginVertical("box");

            GUILayout.BeginHorizontal();
            GUILayout.Label("Contrlo贴图:", GUILayout.Width(75));
            ControlTex = EditorGUILayout.ObjectField(ControlTex, typeof(Texture2D), true, GUILayout.Width(75), GUILayout.Height(75)) as Texture;


            if (LockButton == true)
            {

                CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_Control", ControlTex);
            }
            if (ClickLockButton == true)
            {
                CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_Control", ControlTex);
                for (int i = 0; i < 4; i++)
                {
                    CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_Splat" + i, texLayer[i]);
                }               
                ClickLockButton = false;
            }



            GUILayout.FlexibleSpace();

            GUILayout.BeginVertical();

            GUILayout.Label("新建Control贴图名：", GUILayout.Width(125));
            contolTexName = GUILayout.TextField(contolTexName, GUILayout.ExpandWidth(true));


            GUILayout.Label("如果需要新建Contrlo贴图请点击:", GUILayout.Width(170));

            if (GUILayout.Button("新建Control贴图", GUILayout.Width(180), GUILayout.Height(20)))
            {
                creatContolTex();
                CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_Control", ControlTex);
            }
            GUILayout.EndVertical();

            GUILayout.EndHorizontal();

            GUILayout.EndVertical();

            GUILayout.Space(5);

            GUILayout.BeginVertical("box");
            GUILayout.BeginHorizontal();
            GUILayout.Label("添加贴图", GUILayout.Width(105));
            GUILayout.FlexibleSpace();
            AddTexture = EditorGUILayout.ObjectField(AddTexture, typeof(Texture2D), true, GUILayout.Width(190)) as Texture;
            // AddTexture = (Texture2D)EditorGUILayout.ObjectField("", AddTexture, typeof(Texture2D), true, GUILayout.Width(190));

            GUILayout.EndHorizontal();


            EditorGUILayout.BeginHorizontal();
            for (int i = 0; i < 4; i++)
            {
                if (GUILayout.Button((Texture)AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Icons/ObjChoose.png", typeof(Texture)), GUILayout.Width(84), GUILayout.Height(15)))
                {
                    if (AddTexture)
                    {
                        texLayer[i] = AddTexture;
                        if (LockButton == true)
                        {
                            //Transform CurrentSelect = Selection.activeTransform;
                            CurrentSelect.gameObject.GetComponent<MeshRenderer>().sharedMaterial.SetTexture("_Splat" + i, texLayer[i]);
                        }
                        
                    }

                    else
                    {
                        texLayer[i] = null;
                    }
                    AddTexture = null;
                }
            }
            for (int i = 0; i < 4; i++)
            {
                if (texLayer[i] != null)
                {
                    ThumbnailTex[i] = AssetPreview.GetAssetPreview(texLayer[i]) as Texture;
                   
                }
                else
                {
                    ThumbnailTex[i] = null;

                }
            }

            GUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            selTex = GUILayout.SelectionGrid(selTex, ThumbnailTex, 4, "gridlist", GUILayout.Width(346), GUILayout.Height(68));

            EditorGUILayout.EndHorizontal();

            GUILayout.EndVertical();

            GUILayout.BeginVertical("box");
            LockButton = GUILayout.Toggle(LockButton, "       实时更改材质");
            if (GUILayout.Button("点击同步材质", GUILayout.Width(180), GUILayout.Height(20)))
            {
                ClickLockButton = true;

            }
            GUILayout.EndVertical();
        }
        else
        {
            EditorGUILayout.HelpBox("请选择需要绘制的模型！", MessageType.Error);
        }
        

    }

    //创建Contol贴图

    bool exporNameSuccess = true;
    void creatContolTex()
    {
        //Selection.activeTransform.gameObject.layer = 4;
        ContolTexFolder = TerrainEditorFolder + "Controler/";
        //创建Contol贴图存放文件夹
        CreateContolTexFolder();
       
        //创建一个新的Contol贴图

        Texture2D newMaskTex = new Texture2D(512, 512, TextureFormat.ARGB32, true);
        Color[] colorBase = new Color[512 * 512];
        for (int t = 0; t < colorBase.Length; t++)
        {
            colorBase[t] = new Color(1, 0, 0, 0);
        }
        newMaskTex.SetPixels(colorBase);

        //判断是否重名

        if (File.Exists(ContolTexFolder + contolTexName + ".png"))
        {
            Debug.Log(ContolTexFolder + contolTexName + ".png");
            EditorUtility.DisplayDialog("警告", "有重复名称贴图，请更改贴图名称！", "OK");
            exporNameSuccess = false;
        }
        else
        {
            exporNameSuccess = true;
        }

        if (exporNameSuccess)
        {
            string path = ContolTexFolder + contolTexName + ".png";
            byte[] bytes = newMaskTex.EncodeToPNG();
            File.WriteAllBytes(path, bytes);//保存


            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//导入资源
                                                                            //Contol贴图的导入设置
            TextureImporter textureIm = AssetImporter.GetAtPath(path) as TextureImporter;
            textureIm.textureCompression = TextureImporterCompression.Uncompressed;
            textureIm.isReadable = true;
            textureIm.anisoLevel = 9;
            textureIm.mipmapEnabled = false;
            textureIm.wrapMode = TextureWrapMode.Clamp;
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//刷新
            setContolTex(path);//设置Contol贴图
        }       

    }
    //创建Contol贴图存放文件夹
    void CreateContolTexFolder()
    {
        Directory.CreateDirectory(ContolTexFolder);
    }

    //设置Contol贴图
    void setContolTex(string peth)
    {
        ControlTex = (Texture2D)AssetDatabase.LoadAssetAtPath(peth, typeof(Texture2D));
        
    }
 #endregion
  
 #endregion

    //装饰物
    #region 

    // 摆放装饰物编辑器界面
    #region 
    // 摆放装饰物
    public enum PlantTowardMode
    {
        Vertical,
        Normals
    }
    GameObject AddObject;
    static public GameObject[] ObjectPlant = new GameObject[5];
    static private Texture[] PlantTex = new Texture[5];
    static private string[] PlantName = new string[5];

    static public int PlantSel = 0;
    static public PlantTowardMode PlantToward = PlantTowardMode.Vertical;
    static public float ObjectPlantSize = 1f;
    static public float ObjectPlantSizeRandom;
    static public float ObjectPlantYOrigin;
    static public string ObjectPlantGroupName = "装饰物";

    static public bool ObjectPlantRandomRot = true;
    static public float ObjectPlantRX = 0.0f;
    static public float ObjectPlantRY = 1.0f;
    static public float ObjectPlantRZ = 0.0f;
    static public bool allowPlant = false;
    void plantGUI()
    {
       
        GUILayout.Space(3);
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        allowPlant = GUILayout.Toggle(allowPlant, EditorGUIUtility.IconContent("TerrainInspector.TerrainToolTrees"), GUI.skin.button, GUILayout.Width(340), GUILayout.Height(40));//编辑模式开关               

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        GUILayout.Space(3);

        GUILayout.BeginVertical("box");
        GUILayout.BeginHorizontal();
        GUILayout.Label("添加装饰物", GUILayout.Width(105));
        GUILayout.FlexibleSpace();
        AddObject = (GameObject)EditorGUILayout.ObjectField("", AddObject, typeof(GameObject), true, GUILayout.Width(190));
        GUILayout.EndHorizontal();

        GUILayout.EndVertical();

        GUILayout.BeginVertical("box");

        EditorGUILayout.BeginHorizontal();
        for (int i = 0; i < 5; i++)
        {
            if (GUILayout.Button((Texture)AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Icons/ObjChoose.png", typeof(Texture)), GUILayout.Width(66), GUILayout.Height(15)))
            {
                if (AddObject)
                    ObjectPlant[i] = AddObject;
                else
                {
                    ObjectPlant[i] = null;
                }
                AddObject = null;
            }
        }

        for (int i = 0; i < 5; i++)
        {
            if (ObjectPlant[i] != null)
            {
                PlantTex[i] = AssetPreview.GetAssetPreview(ObjectPlant[i]) as Texture;
                PlantName[i] = ObjectPlant[i].name;
            }
            else
            {
                PlantTex[i] = null;
                PlantName[i] = null;
            }
        }


        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();

        PlantSel = GUILayout.SelectionGrid(PlantSel, PlantTex, 5, "gridlist", GUILayout.Width(346), GUILayout.Height(68));


        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();

        GUILayout.SelectionGrid(PlantSel, PlantName, 5, "GridListText", GUILayout.Width(346), GUILayout.Height(15));
        EditorGUILayout.EndHorizontal();

        GUILayout.EndVertical();

        if (GUILayout.Button("创建MeshCollider"))
        {
            if (Selection.activeTransform == null)
            {
                EditorUtility.DisplayDialog("警告", "请选择需要创建碰撞器的模型", "OK");
            }
            else
            {
                Transform ColliderSelect = Selection.activeTransform;

                if (ColliderSelect.gameObject.GetComponent<MeshCollider>() == null)
                {
                    ColliderSelect.gameObject.AddComponent<MeshCollider>();
                    //EditorUtility.DisplayDialog("警告", "已经创建好碰撞器", "OK");
                }
                else
                {
                    EditorUtility.DisplayDialog("警告", "该模型已经创建了碰撞器", "OK");
                }
            }

        }
        GUILayout.BeginVertical("box");
            GUILayout.BeginHorizontal();
            GUILayout.Label("模型组名", GUILayout.Width(50));
          //GUILayout.FlexibleSpace();
            ObjectPlantGroupName = GUILayout.TextField(ObjectPlantGroupName, GUILayout.ExpandWidth(true));

        GUILayout.EndHorizontal();
        GUILayout.EndVertical();

        GUILayout.BeginVertical("box");
        GUILayout.Label("装饰物设置（shift+鼠标右键随机切换）", EditorStyles.boldLabel);
        EditorGUILayout.Space();

        

        PlantToward = (PlantTowardMode)EditorGUILayout.EnumPopup("摆放朝向", PlantToward, GUILayout.Width(340));


        ObjectPlantSize = EditorGUILayout.Slider("模型大小", ObjectPlantSize, 0.1f, 4);
        ObjectPlantSizeRandom = EditorGUILayout.Slider("模型大小(随机 +/-)", ObjectPlantSizeRandom, 0, 0.5f);
        ObjectPlantYOrigin = EditorGUILayout.Slider("模型Y轴偏移 ", ObjectPlantYOrigin, -10, 10);



        GUILayout.EndVertical();

        GUILayout.BeginVertical("box");
        GUILayout.BeginHorizontal();
        GUILayout.Label("是否随机旋转模型", EditorStyles.boldLabel, GUILayout.Width(150));
        ObjectPlantRandomRot = EditorGUILayout.Toggle(ObjectPlantRandomRot, GUILayout.Width(15));
        GUILayout.EndHorizontal();
        EditorGUILayout.Space();
        if (ObjectPlantRandomRot)
        {
            ObjectPlantRX = EditorGUILayout.Slider("X轴旋转:", ObjectPlantRX, 0, 1);
            ObjectPlantRY = EditorGUILayout.Slider("Y轴旋转:", ObjectPlantRY, 0, 1);
            ObjectPlantRZ = EditorGUILayout.Slider("Z轴旋转:", ObjectPlantRZ, 0, 1);
        }

        GUILayout.EndVertical();

    }
    #endregion

    //扩展10个添加物体
    //void plant()
    //{
    //    GUILayout.BeginVertical("box");
    //    GUILayout.BeginHorizontal();
    //    GUILayout.Label("添加装饰物", GUILayout.Width(105));
    //    GUILayout.FlexibleSpace();
    //    AddObject = (GameObject)EditorGUILayout.ObjectField("", AddObject, typeof(GameObject), true, GUILayout.Width(190));
    //    GUILayout.EndHorizontal();

    //    if (GUILayout.Button((Texture)AssetDatabase.LoadAssetAtPath(TerrainEditorFolder + "Icons/ObjChoose.png", typeof(Texture)), GUILayout.Width(66), GUILayout.Height(15)))
    //    {
    //        if (AddObject)
    //            ObjectPlant[PlantSel] = AddObject;
    //        else
    //        {
    //            ObjectPlant[PlantSel] = null;
    //        }
    //        AddObject = null;
    //    }


    //    GUILayout.EndVertical();

    //    //====================================================================

    //    GUILayout.BeginVertical("box");

    //    EditorGUILayout.BeginHorizontal();
    //    for (int i = 0; i < 10; i++)
    //    {
    //        if (ObjectPlant[i] != null)
    //        {
    //            PlantTex[i] = AssetPreview.GetAssetPreview(ObjectPlant[i]) as Texture;
    //            PlantName[i] = ObjectPlant[i].name;
    //        }
    //        else PlantTex[i] = null;
    //    }


    //    PlantSel = GUILayout.SelectionGrid(PlantSel, PlantTex, 5, "gridlist", GUILayout.Width(346), GUILayout.Height(170));



    //    EditorGUILayout.BeginHorizontal();
    //    GUILayout.SelectionGrid(PlantSel, PlantName, 5, "GridListText", GUILayout.Width(346), GUILayout.Height(18));
    //    EditorGUILayout.EndHorizontal();

    //    EditorGUILayout.EndHorizontal();



    //    GUILayout.EndVertical();


    //    PlantToward = (PlantTowardMode)EditorGUILayout.EnumPopup("摆放朝向", PlantToward, GUILayout.Width(340));


    //}

    #region 
    //摆放装饰物   
    static public GameObject PlantObjPreview ;   
    static public GameObject PlantObj;
    static public GameObject PlantPrevieToObj;
    static public bool RandomJudge = true;
    static public bool RandomRotateJudge = true;
    static public int sel = PlantSel;
    static public Vector3 RotateY;
    void planting()
    {
        //Debug.Log(RandomJudge);
        Event e = Event.current;//检测输入

        RaycastHit curHit = new RaycastHit();
        Ray worldRay = HandleUtility.GUIPointToWorldRay(e.mousePosition);//从鼠标位置发射一条射线   

        if (Physics.Raycast(worldRay, out curHit, Mathf.Infinity))
        {

            Handles.color = new Color(0f, 1f, 0f, 0.2f);

            //Handles.DrawWireDisc(curHit.point, curHit.normal, 1);
            Handles.DrawSolidDisc(curHit.point, curHit.normal, 0.5f);
            if (sel != PlantSel)
            {
                sel = PlantSel;
                RandomJudge = true;
                RandomRotateJudge = true;
                //Debug.Log(1222);
            }

            PlantPrevieToObj = ObjectPlant[PlantSel];
           // Debug.Log(PlantPrevieToObj.transform.localScale);
            if (PlantPrevieToObj && RandomJudge == true)
            {

                RandomSizeAndRotate(PlantPrevieToObj);
            }

            if (PlantPrevieToObj)
            {
                DestroyImmediate(PlantObjPreview);
                PlantObjPreview = Instantiate(PlantPrevieToObj) as GameObject;
                //PlantObjPreview = PrefabUtility.InstantiatePrefab(PlantPrevieToObj) as GameObject;              
                PlantObjPreview.transform.localPosition = curHit.point + curHit.normal* ObjectPlantYOrigin;

                if (PlantToward == PlantTowardMode.Normals)
                {
                    PlantObjPreview.transform.up = PlantObjPreview.transform.up + curHit.normal;     

                    if (RandomRotateJudge  == true && ObjectPlantRandomRot ==true )
                    {
                       
                        RandomRotateY(RotateY);
                       // Debug.Log(RotateY);
                                            
                    }
                    PlantObjPreview.transform.Rotate(RotateY);


                }

                if (e.type == EventType.MouseDown && e.alt == false && e.button == 0 && e.shift == false && e.control == false)
                {
                    
                     GameObject ObjectPlantGroup = GameObject.Find(ObjectPlantGroupName);
                     if (!ObjectPlantGroup)
                     {
                         ObjectPlantGroup = new GameObject(ObjectPlantGroupName);
                     }

                    PlantObj = Instantiate(PlantPrevieToObj) as GameObject;
                    PlantObj.name = PlantPrevieToObj.name;
                    PlantObj.transform.localPosition = curHit.point + curHit.normal * ObjectPlantYOrigin;
                    PlantObj.transform.parent = ObjectPlantGroup.transform;
                    if (PlantToward == PlantTowardMode.Normals)
                    {
                        PlantObj.transform.up = PlantObj.transform.up + curHit.normal;
                        PlantObj.transform.Rotate(RotateY);
                    }

                    RandomJudge = true;
                    RandomRotateJudge = true;
                }
                if (e.button == 1 && e.shift)
                {
                    RandomJudge = true;
                    RandomRotateJudge = true;
                }               

            }

        }

    }
    private Vector3 RandomRotateY(Vector3 RandomY)
    {
        RandomY = new Vector3( 0f, UnityEngine.Random.Range(-ObjectPlantRY * 180, ObjectPlantRY * 180),0f);
        RotateY = RandomY;
        RandomRotateJudge = false;
        return RotateY;
    }

    private GameObject RandomSizeAndRotate(GameObject RandomObj)
    {
        //大小随机
        float Var = UnityEngine.Random.Range(-ObjectPlantSizeRandom, ObjectPlantSizeRandom);
        float variation = ObjectPlantSize * Var;
        RandomObj.transform.localScale = new Vector3(ObjectPlantSize + variation, ObjectPlantSize + variation, ObjectPlantSize + variation);

        //旋转随机
        if (ObjectPlantRandomRot)
        {
            
              RandomObj.transform.localEulerAngles = new Vector3(0.0f, 0.0f, 0.0f);
              Vector3 RandomRotation = new Vector3(UnityEngine.Random.Range(-ObjectPlantRX * 25, ObjectPlantRX * 25), UnityEngine.Random.Range(-ObjectPlantRY * 180, ObjectPlantRY * 180), UnityEngine.Random.Range(-ObjectPlantRZ * 25, ObjectPlantRZ * 25));
              RandomObj.transform.Rotate(RandomRotation);

        }

        PlantPrevieToObj = RandomObj;
        RandomJudge = false;
        return PlantPrevieToObj;

    }

    #endregion

    #endregion

    //未完成功能
    #region
    void SetGUI()
    {
        GUILayout.BeginVertical("box");
      
        GUILayout.Label("拓展功能待续添加", GUILayout.Width(105));


        GUILayout.EndVertical();
    }

    #endregion

}
#endif