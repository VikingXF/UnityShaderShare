#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class WindowUVPreview : EditorWindow {

    protected static WindowUVPreview uvPreviewWindow;

    private int ySpace = 75;
    private int sideSpace = 5;
    private Rect uvPreviewRect;
    private GameObject selectedObject = null;
    private Mesh m = null;
    private List<Material> Mat;
    private int selectedUV = 0;
    private string[] selectedUVStrings = new string[]{ "UV1", "UV2", "UV3", "UV4" };
    public enum BackgroundTextureMode
    {
        BaseMap,
        VertexColor,
        LightMap
       
    }
    BackgroundTextureMode BackgroundTexture = BackgroundTextureMode.BaseMap;
    private int Textureindex;
    private Texture2D BaseTexture ;
    private List<Texture2D> Background_Textures;

    private bool canDrawView;

    [MenuItem("Tools/UV Preview")]
    protected static void Start()
    {
        uvPreviewWindow = (WindowUVPreview)EditorWindow.GetWindow(typeof(WindowUVPreview));
        uvPreviewWindow.titleContent = new GUIContent("UV预览");
        uvPreviewWindow.autoRepaintOnSceneChange = true;
        uvPreviewWindow.minSize = new Vector2(256, 330);
    }
    

    private void OnGUI()
    {
        //Event e = Event.current;
        selectedObject = Selection.activeGameObject;

        if (selectedObject == null)
        {
            GUI.color = Color.gray;
            EditorGUILayout.HelpBox("Select the object...",MessageType.Warning);
            canDrawView = false;
        }
        else
        {
            if (selectedObject.GetComponent<MeshFilter>() != null | selectedObject.GetComponent<SkinnedMeshRenderer>() !=null)
            {
                GUI.color = Color.green;
                EditorGUILayout.HelpBox("Selected object: " + selectedObject.name, MessageType.None);
                GUI.color = Color.white;
                canDrawView = true;
                if (selectedObject.GetComponent<SkinnedMeshRenderer>() == null)
                {                  
                    m = selectedObject.GetComponent<MeshFilter>().sharedMesh;
                    //foreach (var item in selectedObject.GetComponent<MeshRenderer>().sharedMaterials)
                    //{
                    //    Mat.Add(item);
                    //}
                   
                }
                else
                {
                    m = selectedObject.GetComponent<SkinnedMeshRenderer>().sharedMesh;
                    //foreach (var item in selectedObject.GetComponent<SkinnedMeshRenderer>().sharedMaterials)
                    //{
                    //    Mat.Add(item);
                    //}
                }
                if (m != null)
                {
                    GUILayout.BeginHorizontal();
                    selectedUV = GUILayout.Toolbar(selectedUV, selectedUVStrings);

                    BackgroundTexture = (BackgroundTextureMode)EditorGUILayout.EnumPopup(BackgroundTexture, GUILayout.Width(85));
                    GUILayout.EndHorizontal();
                    switch (selectedUV)
                    {
                        case 0:
                            if (m.uv.Length > 0)
                            {
                                GUILayout.BeginHorizontal();
                                EditorGUILayout.HelpBox("Mesh UV 1 缩略图", MessageType.None);
                                //if (Mat.Count > 0)
                                //{

                                //    List<string> matsName = null;
                                //    int[] matsInt = new int[Mat.Count];
                                //    foreach (var item in Mat)
                                //    {
                                //        matsName.Add(item.name);
                                //    }
                                //    Textureindex = EditorGUILayout.IntPopup(Textureindex, matsName.ToArray(), matsInt);
                                //}
                                GUILayout.EndHorizontal();
                            }
                            else
                            {
                                EditorGUILayout.HelpBox("Mesh无UV 1", MessageType.None);
                            }                         
                            break;
                        case 1:
                            GUILayout.BeginHorizontal();
                            if (m.uv2.Length > 0)
                            {
                                EditorGUILayout.HelpBox("Mesh UV2 缩略图", MessageType.None);
                            }
                            else
                            {
                                EditorGUILayout.HelpBox("Mesh没有UV2. 点击Generate UV2生成", MessageType.None);
                                if (GUILayout.Button("Generate UV2"))
                                {
                                    Unwrapping.GenerateSecondaryUVSet(m);
                                    EditorApplication.Beep();
                                    EditorUtility.DisplayDialog("Done", "Process is done!", "OK");
                                }
                            }
                            GUILayout.EndHorizontal();

                            break;
                        case 2:
                            if (m.uv3.Length > 0)
                            {
                                EditorGUILayout.HelpBox("Mesh UV3 缩略图", MessageType.None);
                            }
                            else
                            {
                                EditorGUILayout.HelpBox("Mesh 无 UV3", MessageType.None);
                            }
                            break;
                        case 3:
                            if (m.uv4.Length > 0)
                            {
                                EditorGUILayout.HelpBox("Mesh UV4 缩略图", MessageType.None);
                            }
                            else
                            {
                                EditorGUILayout.HelpBox("Mesh 无 UV4", MessageType.None);
                            }
                            break;

                    }


                   
                }

            }
            else
            {
                GUI.color = Color.gray;
                EditorGUILayout.HelpBox("Object must have a Mesh Filter or Skinned Mesh Renderer", MessageType.Warning);
                canDrawView = false;
            }
        }
        BaseTexture = (Texture2D)selectedObject.GetComponent<MeshRenderer>().sharedMaterial.mainTexture;
        //BaseTexture = CreateFillTexture(1, 1, new Color(1, 1, 1, 1f));
        //uvPreviewRect = new Rect(new Rect(sideSpace, ySpace + sideSpace, uvPreviewWindow.position.width - (sideSpace * 2), uvPreviewWindow.position.height - ySpace - (sideSpace * 2)));
        uvPreviewRect = new Rect(new Rect(sideSpace, ySpace, uvPreviewWindow.position.width- 10, uvPreviewWindow.position.width- 10));
        //GUI.DrawTexture(new Rect(0, 0, uvPreviewWindow.position.width, ySpace), BaseTexture);

        if (canDrawView)
        {
           
            GUI.DrawTexture(uvPreviewRect, BaseTexture);
           

            //GUILayout.Box(BaseTexture, GUILayout.Width(200), GUILayout.Height(200));
            //GUI.DrawTexture(new Rect(0,0,uvPreviewWindow.position.width, ySpace), BaseTexture);
        }


    }

    private Texture2D CreateFillTexture(int width, int height, Color fillColor)
    {

        Texture2D texture = new Texture2D(width, height);
        Color[] pixels = new Color[width * height];

        for (int i = 0; i < pixels.Length; i++)
        {
            pixels[i] = fillColor;
        }

        texture.SetPixels(pixels);
        texture.Apply();

        return texture;
    }

    void Update () {
      
    }
}
#endif