//=======================================================
// 作者：xuefei
// 描述：1/记录模型光照图索引，2/更改烘焙的物体使用光照图shader，3/更改材质索引以及光照图
//=======================================================
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace LightMap2
{
    public class LightMapIndexToMaterial : MonoBehaviour
    {
        [System.Serializable]
        struct RendererInfo
        {
            public Renderer renderer;
            public int lightmapIndex;
            public Vector4 lightmapOffsetScale;
        }

        [SerializeField] RendererInfo[] m_RendererInfo;
        [SerializeField] Texture2D[] m_Lightmaps;
        public void GenerateLightmapInfo()
        {
            if (UnityEditor.Lightmapping.giWorkflowMode != UnityEditor.Lightmapping.GIWorkflowMode.OnDemand)
            {
                Debug.LogError(
                    "ExtractLightmapData requires that you have baked you lightmaps and Auto mode is disabled.");
                return;
            }

            LightMapIndexToMaterial[] LightMapObject = FindObjectsOfType<LightMapIndexToMaterial>();

            foreach (var instance in LightMapObject)
            {
                var gameObject = instance.gameObject;
                var rendererInfos = new List<RendererInfo>();
                var lightmaps = new List<Texture2D>();

                GenerateLightmapInfo(gameObject, rendererInfos, lightmaps);

                instance.m_RendererInfo = rendererInfos.ToArray();
                instance.m_Lightmaps = lightmaps.ToArray();
                SetMaterial();
            }

        }

        void SetMaterial()
        {
            foreach (var item in m_RendererInfo)
            {
                foreach (var Mater in item.renderer.sharedMaterials)
                {
                    Mater.shader = Shader.Find("Babybus/Mobile/LightMapIndex_Color");
                    Mater.SetTexture("_LightMap", m_Lightmaps[item.lightmapIndex]);
                    //Mater.SetVector("_LightmapST", item.lightmapOffsetScale);
                    ////Mater.SetTextureOffset("_LightMap",new Vector2(item.lightmapOffsetScale.z, item.lightmapOffsetScale.w));
                    ////Mater.SetTextureScale("_LightMap", new Vector2(item.lightmapOffsetScale.x, item.lightmapOffsetScale.w));
                }


            }

        }


        static void GenerateLightmapInfo(GameObject root, List<RendererInfo> rendererInfos,
            List<Texture2D> lightmaps)
        {
            var renderers = root.GetComponentsInChildren<MeshRenderer>();
            foreach (MeshRenderer renderer in renderers)
            {
                if (renderer.lightmapIndex != -1)
                {
                    RendererInfo info = new RendererInfo();
                    info.renderer = renderer;
                    info.lightmapOffsetScale = renderer.lightmapScaleOffset;

                    Texture2D lightmap = LightmapSettings.lightmaps[renderer.lightmapIndex].lightmapColor;

                    info.lightmapIndex = lightmaps.IndexOf(lightmap);
                    if (info.lightmapIndex == -1)
                    {
                        info.lightmapIndex = lightmaps.Count;
                        lightmaps.Add(lightmap);
                    }

                    rendererInfos.Add(info);
                }
            }
        }

    }
}
