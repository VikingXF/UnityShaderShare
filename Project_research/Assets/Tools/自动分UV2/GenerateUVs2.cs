#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class GenerateUVs2 : EditorWindow
{
    protected static GenerateUVs2 generateuvuv;
    private Mesh m = null;
    private GameObject selectedObject = null;
    private float HardAngle = 88f;
    private float PackMargin = 4f;
    private float AngleError = 8f;
    private float AreaError = 15;
   // private UnwrapParam SetUVs;
    [MenuItem("Tools/GenerateUV2")]
    protected static void Start()
    {
        generateuvuv = (GenerateUVs2)EditorWindow.GetWindow(typeof(GenerateUVs2));
        generateuvuv.titleContent = new GUIContent("自动分UV2");
        generateuvuv.autoRepaintOnSceneChange = true;
        generateuvuv.minSize = new Vector2(350, 150);
    }
    private void OnGUI()
    {
        selectedObject = Selection.activeGameObject;
        if (selectedObject == null)
        {
            GUI.color = Color.gray;
            EditorGUILayout.HelpBox("Select the object...", MessageType.Warning);

        }
        else
        {
            if (selectedObject.GetComponent<MeshFilter>() != null | selectedObject.GetComponent<SkinnedMeshRenderer>() != null)
            {
                GUI.color = Color.green;
                EditorGUILayout.HelpBox("Selected object: " + selectedObject.name, MessageType.None);
                GUI.color = Color.white;
                if (selectedObject.GetComponent<SkinnedMeshRenderer>() == null)
                {
                    m = selectedObject.GetComponent<MeshFilter>().sharedMesh;
                }
                else
                {
                    m = selectedObject.GetComponent<SkinnedMeshRenderer>().sharedMesh;
                }
                GUILayout.Label("Lightmap Lightmap UVs");
                HardAngle = (int)EditorGUILayout.Slider("Hard Angle", HardAngle, 0, 180);
                PackMargin = (int)EditorGUILayout.Slider("Pack Margin", PackMargin, 1, 64);
                AngleError = (int)EditorGUILayout.Slider("Angle Error", AngleError, 1, 75);
                AreaError = (int)EditorGUILayout.Slider("Area Error", AreaError, 1, 75);
                
                if (GUILayout.Button("Generate UV2"))
                {
                    UnwrapParam SetUVs = new UnwrapParam();
                    UnwrapParam.SetDefaults(out SetUVs);
                    SetUVs.hardAngle = HardAngle;
                    SetUVs.packMargin = PackMargin / 1000;
                    SetUVs.angleError = AngleError / 100;
                    SetUVs.areaError = AreaError / 100;

                    //Debug.Log(SetUVs.hardAngle);
                    //Debug.Log(SetUVs.packMargin);
                    //Debug.Log(SetUVs.angleError);
                    //Debug.Log(SetUVs.areaError);

                    Unwrapping.GenerateSecondaryUVSet(m, SetUVs);
                    EditorApplication.Beep();
                    EditorUtility.DisplayDialog("Done", "Process is done!", "OK");
                }

            }
            else
            {
                GUI.color = Color.gray;
                EditorGUILayout.HelpBox("Object must have a Mesh Filter or Skinned Mesh Renderer", MessageType.Warning);
               
            }

        }
        
    }

}
#endif