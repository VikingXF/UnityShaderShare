
#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SpriteToMeshRender))]
public class SpriteToMeshRenderEditor : Editor
{

    private SpriteToMeshRender spriteToMeshRender;
    public override void OnInspectorGUI()
    {
        spriteToMeshRender = target as SpriteToMeshRender;

        EditorGUILayout.Space();
        if (GUILayout.Button("UI转MeshRenderer", GUILayout.MinHeight(60)))
        {

            spriteToMeshRender.StartSpriteToMeshRender();
        }
    }
}
#endif