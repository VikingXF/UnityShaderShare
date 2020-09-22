using UnityEngine;
using System.Collections;
using UnityEditor;

public class ChangerShader : EditorWindow
{

    static TextAsset textAsset;
    static string[] lineArray;
    static public int MenuToolbar = 0;
    static public string[] MenuToolbarString = { "一键批处理转换shader", "批量选择修改shader"};
    static public int MenChoose = 0;
    static public string[] GUIMen ={ "Unlit", "Particle", "Mobile", "Special", "自定义" };
    static public string[] UnlitshaderName = { "Babybus/Unlit/Texture",
        "Babybus/Unlit/Color Texture",
        "Babybus/Unlit/Texture nofog",
        "Babybus/Unlit/Transparent",
        "Babybus/Unlit/Transparent2",
        "Babybus/Unlit/Color Transparent",
        "Babybus/Unlit/Transparent nofog",
        "Babybus/Unlit/Transparent ZTest",
        "Babybus/Unlit/Unlit-Transparentt ZWrite On",
        "Babybus/Unlit/Rim Color Texture",
        "Babybus/Unlit/Rim Transparent",
        "Babybus/Unlit/Transparent Cutout",
        "Babybus/Unlit/Transparent Cutout",
        "Babybus/Unlit/Color Transparentt",
        "Babybus/Unlit/Unlit-Mask0",
        "Babybus/Unlit/Unlit-Shadows-Transparent",
        "Babybus/Unlit/Transparent transition",
        "Babybus/Gray/UI Gray",
        "Babybus/Gray/Texture Grey",
        "Babybus/Gray/Transparent Grey",
        "Babybus/Cutout/Color Soft Edge Unlit",
        "Babybus/Cutout/Soft Edge Unlit" };

    static public string[] ParticleshaderName = { "Babybus/Particles/EffectCartoonWaves",
        "Babybus/Particles/Additive Color(customDataUV)",
        "Babybus/Particles/Additive Color(FlowLight)",
        "Babybus/Particles/Additive Color" ,
        "Babybus/Particles/Additive Mask(customDataUV)",
        "Babybus/Particles/Additive Mask",
        "Babybus/Particles/Additive" ,
        "Babybus/Particles/Alpha Blended Color(customDataUV)" ,
        "Babybus/Particles/Alpha Blended Color" ,
        "Babybus/Particles/Alpha Blended Mask(customDataUV)" ,
        "Babybus/Particles/Alpha Blended Mask" ,
        "Babybus/Particles/Alpha Blended Mask2" ,
        "Babybus/Particles/Alpha Blended" ,
        "Babybus/Particles/Dissolution_Add" ,
        "Babybus/Particles/Dissolve Blend" ,
        "Babybus/Particles/Dissolve Blend2" ,
        "Babybus/Particles/Dissolve Blend3" ,
        "Babybus/Particles/Mask(customDataUV)" };

    static public string[] MobileshaderName = { "Babybus/Mobile/Color Diffuse",
        "Babybus/Mobile/Color",
        "Babybus/Mobile/Diffuse Double",
        "Babybus/Mobile/Diffuse",
        "Babybus/Mobile/VertexColor-Diffuse",
        "Babybus/Mobile/Transparent-VertexLit",
        "Babybus/Mobile/Transparentt-cutout-Diffuse" };

    static public string[] SpecialshaderName = { "Babybus/Special/TransparentBlend bar360",
        "Babybus/Special/LightMap-diagram transitions",
        "Babybus/Special/MobileLight-diagram transitions",
        "Babybus/Special/seaShader",
        "Babybus/Special/Unlit-diagram transitions",
        "Babybus/Special/Unlit-diagram transitionsUV",
        "Babybus/Special/Unlit-diagram UVGrey",
        "Babybus/Special/Unlitwater",
        "Babybus/Rim/vertex Rim outL3" };

    private Shader shader;

    [MenuItem("Tools/批量修改shader")]
    static void ShowWindow()
    {
        textAsset = AssetDatabase.LoadAssetAtPath("Assets/Tools/ChangerShader/shader.txt", typeof(TextAsset)) as TextAsset;
        lineArray = textAsset.text.Split("&"[0]);

        ChangerShader window = (ChangerShader)EditorWindow.GetWindowWithRect(typeof(ChangerShader), new Rect(0, 0, 460, 580), false, "批量修改shader");
        window.Show();
    }

    void OnGUI()
    {
        GUILayout.BeginArea(new Rect(10, 0, 450, 540));
        EditorGUILayout.Space();
        GUILayout.BeginHorizontal("box");
        GUILayout.FlexibleSpace();
        MenuToolbar = (int)GUILayout.Toolbar(MenuToolbar, MenuToolbarString, GUILayout.Width(390), GUILayout.Height(28));
        GUILayout.FlexibleSpace();

        GUILayout.EndHorizontal();

        switch (MenuToolbar)
        {
            case 0:
                //一键批处理转换shader
                Choose1();
                break;

            case 1:
                //批量选择修改shader
                Choose2();
                break;
        }
        GUILayout.EndArea();
    }

   
    void Choose1()
    {
        GUILayout.Space(5);
        //GUILayout.BeginHorizontal();
        //GUILayout.FlexibleSpace();
        if (GUILayout.Button("一键批处理转换shader", GUILayout.Height(60)))
        {
            BatChange();
        }
        EditorGUILayout.HelpBox("以下shader对应转换,shader必须包含Babybus Shader库", MessageType.Info);
        //EditorGUILayout.TextArea("Unlit/Texture =>  Babybus/Unlit/Texture"+"\r\n"+ "Unlit/Transparent => Babybus/Unlit/Transparent" + "\r\n" + "Mobile/Particles/Additive  =>  Babybus/Particles/Additive" + "\r\n" + "Mobile/Particles/AlphaBlended  =>  Babybus/Particles/AlphaBlended" + "\r\n" + "Mobile/Particles/Multiply  =>  Babybus/Particles/Multiply", GUILayout.Width(400));
        EditorGUILayout.HelpBox("Unlit/Texture                               =>  Babybus/Unlit/Texture"
            + "\r\n"
            + "\r\n" + "Unlit/Transparent                        =>  Babybus/Unlit/Transparent"
            + "\r\n"
            + "\r\n" + "Unlit/TransparentCutout             =>  Babybus/Unlit/TransparentCutout"
            + "\r\n"
            + "\r\n" + "Legacy Shaders/Transparent/Cutout/Soft Edge Unlit                  =>  Babybus/Cutout/ColorSoftEdgeUnlit"
            + "\r\n"
            + "\r\n" + "Mobile/Particles/Additive           =>  Babybus/Particles/Additive"
            + "\r\n"
            + "\r\n" + "Mobile/Particles/AlphaBlended  =>  Babybus/Particles/AlphaBlended"
            + "\r\n"
            + "\r\n" + "Legacy Shaders/Particles/Additive =>  Babybus / Particles / AdditiveColor"
            + "\r\n"
            + "\r\n" + "Legacy Shaders/Particles/AlphaBlended  =>  Babybus/Particles/AlphaBlendedColor",
            MessageType.Info);     
        // EditorGUILayout.EndHorizontal();


    }
    void Choose2()
    {
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        MenChoose = GUILayout.Toolbar(MenChoose, GUIMen, GUILayout.Width(290), GUILayout.Height(20));
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        switch (MenChoose)
        {
            case 0:
                GUILayout.Space(5);
                for (int i = 0; i < UnlitshaderName.Length; i++)
                {
                    string shaderName = UnlitshaderName[i].Trim();
                    if (GUILayout.Button(shaderName.Remove(0,8)))
                    {
                        Change(Shader.Find(shaderName));
                    }
                }
                break;
            case 1:
                GUILayout.Space(5);
                for (int i = 0; i < ParticleshaderName.Length; i++)
                {
                    string shaderName = ParticleshaderName[i].Trim();
                    if (GUILayout.Button(shaderName.Remove(0, 18)))
                    {
                        Change(Shader.Find(shaderName));
                    }
                }
                break;
            case 2:
                GUILayout.Space(5);
                for (int i = 0; i < MobileshaderName.Length; i++)
                {
                    string shaderName = MobileshaderName[i].Trim();
                    if (GUILayout.Button(shaderName.Remove(0,15)))
                    {
                        Change(Shader.Find(shaderName));
                    }
                }
                break;
            case 3:
                GUILayout.Space(5);
                for (int i = 0; i < SpecialshaderName.Length; i++)
                {
                    string shaderName = SpecialshaderName[i].Trim();
                    if (GUILayout.Button(shaderName.Remove(0,8)))
                    {
                        Change(Shader.Find(shaderName));
                    }
                }
                break;
            case 4:
                GUILayout.Space(5);

                for (int i = 0; i < lineArray.Length; i++)
                {
                    string shaderName = lineArray[i].Trim();
                    if (GUILayout.Button(shaderName))
                    {
                        Change(Shader.Find(shaderName));
                    }
                }
  
                break;
        }
    }
    void BatChange()
    {

        Object[] m_objects = Selection.GetFiltered(typeof(Material), SelectionMode.DeepAssets);//选择的所以对象

        if (Selection.activeGameObject != null || m_objects != null)
        {
            foreach (var item in m_objects)
            {
                if (item != null)
                {
                    string path = AssetDatabase.GetAssetPath(item);
                    Material m = AssetDatabase.LoadAssetAtPath(path, typeof(Material)) as Material;
                    if (m.shader == Shader.Find("Unlit/Texture"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Unlit/Texture");                        
                        m.renderQueue = RenderQueueint;
                    }
                    if (m.shader == Shader.Find("Unlit/Transparent"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Unlit/Transparent");
                        m.renderQueue = RenderQueueint;
                    }
                    if (m.shader == Shader.Find("Unlit/Transparent Cutout"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Unlit/TransparentCutout");
                        m.renderQueue = RenderQueueint;
                    }
                    if (m.shader == Shader.Find("Legacy Shaders/Transparent/Cutout/Soft Edge Unlit"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Cutout/Color Soft Edge Unlit");
                        m.renderQueue = RenderQueueint;
                    }
                    if (m.shader == Shader.Find("Mobile/Particles/Additive"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Particles/Additive");
                        m.renderQueue = RenderQueueint;
                    }
                    if (m.shader == Shader.Find("Mobile/Particles/Alpha Blended"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Particles/Alpha Blended");
                        m.renderQueue = RenderQueueint;
                    }
                    if (m.shader == Shader.Find("Legacy Shaders/Particles/Additive"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Particles/Additive Color");
                        m.renderQueue = RenderQueueint;
                    }
                    if (m.shader == Shader.Find("Legacy Shaders/Particles/Alpha Blended"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Particles/Alpha Blended Color");
                        m.renderQueue = RenderQueueint;
                    }
					if (m.shader == Shader.Find("Particles/Alpha Blended"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Particles/Alpha Blended Color");
                        m.renderQueue = RenderQueueint;
                    }
					if (m.shader == Shader.Find("Babybus/Particles/Alpha Blended"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Particles/Alpha Blended Color");
                        m.renderQueue = RenderQueueint;
                    }
					if (m.shader == Shader.Find("Particles/Additive"))
                    {
                        int RenderQueueint = m.renderQueue;
                        m.shader = Shader.Find("Babybus/Particles/Additive Color");
                        m.renderQueue = RenderQueueint;
                    }
                }
                   
            }
            foreach (GameObject g in Selection.gameObjects)
            {
                Renderer[] renders = g.GetComponentsInChildren<Renderer>();
                foreach (Renderer r in renders)
                {
                    if (r != null)
                    {
                        foreach (Object o in r.sharedMaterials)
                        {
                            string path = AssetDatabase.GetAssetPath(o);
                            Material m = AssetDatabase.LoadAssetAtPath(path, typeof(Material)) as Material;
                            if (m.shader == Shader.Find("Unlit/Texture"))
                            {
                                int RenderQueueint = m.renderQueue;
                                m.shader = Shader.Find("Babybus/Unlit/Texture");
                                m.renderQueue = RenderQueueint;
                            }
                            if (m.shader == Shader.Find("Unlit/Transparent"))
                            {
                                int RenderQueueint = m.renderQueue;
                                m.shader = Shader.Find("Babybus/Unlit/Transparent");
                                m.renderQueue = RenderQueueint;
                            }
                            if (m.shader == Shader.Find("Unlit/Transparent Cutout"))
                            {
                                int RenderQueueint = m.renderQueue;
                                m.shader = Shader.Find("Babybus/Unlit/TransparentCutout");
                                m.renderQueue = RenderQueueint;
                            }
                            if (m.shader == Shader.Find("Legacy Shaders/Transparent/Cutout/Soft Edge Unlit"))
                            {
                                int RenderQueueint = m.renderQueue;
                                m.shader = Shader.Find("Babybus/Cutout/Color Soft Edge Unlit");
                                m.renderQueue = RenderQueueint;
                            }
                            if (m.shader == Shader.Find("Mobile/Particles/Additive"))
                            {
                                int RenderQueueint = m.renderQueue;
                                m.shader = Shader.Find("Babybus/Particles/Additive");
                                m.renderQueue = RenderQueueint;
                            }
                            if (m.shader == Shader.Find("Mobile/Particles/Alpha Blended"))
                            {
                                int RenderQueueint = m.renderQueue;
                                m.shader = Shader.Find("Babybus/Particles/Alpha Blended");
                                m.renderQueue = RenderQueueint;
                            }
                            if (m.shader == Shader.Find("Legacy Shaders/Particles/Additive"))
                            {
                                int RenderQueueint = m.renderQueue;
                                m.shader = Shader.Find("Babybus/Particles/Additive Color");
                                m.renderQueue = RenderQueueint;
                            }
                            if (m.shader == Shader.Find("Legacy Shaders/Particles/Alpha Blended"))
                            {
                                int RenderQueueint = m.renderQueue;
                                m.shader = Shader.Find("Babybus/Particles/Alpha Blended Color");
                                m.renderQueue = RenderQueueint;
                            }
                        }
                    }
                }
            }
            this.ShowNotification(new GUIContent("选择的对象批量修改shader成功"));
        }
        else
        {
            this.ShowNotification(new GUIContent("没有选择对象"));
        }
    }


    void Change(Shader shader)
    {

        Object[] m_objects = Selection.GetFiltered(typeof(Material), SelectionMode.DeepAssets);//选择的所以对象

        if (Selection.activeGameObject != null || m_objects != null)
        {
            foreach (var item in m_objects)
            {
                if (item != null)
                {                  
                    string path = AssetDatabase.GetAssetPath(item);
                    Material m = AssetDatabase.LoadAssetAtPath(path, typeof(Material)) as Material;
                    m.shader = shader;
                }
            }
            foreach (GameObject g in Selection.gameObjects)
            {
                Renderer[] renders = g.GetComponentsInChildren<Renderer>();
                foreach (Renderer r in renders)
                {
                    if (r != null)
                    {
                        foreach (Object o in r.sharedMaterials)
                        {
                            string path = AssetDatabase.GetAssetPath(o);
                            Material m = AssetDatabase.LoadAssetAtPath(path, typeof(Material)) as Material;
                            m.shader = shader;
                        }
                    }
                }
            }
            this.ShowNotification(new GUIContent("选择的对象批量修改shader成功"));
        }
        else
        {
            this.ShowNotification(new GUIContent("没有选择对象"));
        }
    }
}
