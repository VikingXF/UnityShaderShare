//=======================================================
// 作者：xuefei
// 描述：1/记录模型光照图索引，2/更改烘焙的物体使用光照图shader，3/更改材质索引以及光照图
//=======================================================
using UnityEngine;
using System.Collections;

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


    }
}
