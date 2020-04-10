
using UnityEngine;
using UnityEditor;

namespace LightMap2
{
    #if UNITY_EDITOR
    [CustomEditor(typeof(LightMapIndexToMaterial))]
    public class LightMapIndexToMaterialInspector : Editor
    {
        public override void OnInspectorGUI()
        {

            DrawDefaultInspector();

            LightMapIndexToMaterial LightMapScript = (LightMapIndexToMaterial)target;
            if (GUILayout.Button("记录光照图信息"))
            {
                LightMapScript.GenerateLightmapInfo();

            }
            //if (GUILayout.Button("设置"))
            //{
            //    LightMapScript.GenerateLightmapInfo();

            //}
        }
    }
    #endif
}
