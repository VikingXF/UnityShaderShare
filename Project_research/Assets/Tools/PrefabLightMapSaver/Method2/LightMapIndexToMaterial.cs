//=======================================================
// ���ߣ�xuefei
// ������1/��¼ģ�͹���ͼ������2/���ĺ決������ʹ�ù���ͼshader��3/���Ĳ��������Լ�����ͼ
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
