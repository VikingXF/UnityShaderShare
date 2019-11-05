//=======================================================
// 作者：xuefei
// 描述：控制材质球UV
//=======================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UV_Animation2 : MonoBehaviour {

    public string TexName = "_MainTex";
    public float USpeed = 0;
    public float VSpeed = 0;
    Vector2 m_offset = new Vector2();

    public string TexName2 = "_Mask";
    public float USpeed2 = 0;
    public float VSpeed2 = 0;
    Vector2 m_offset2 = new Vector2();

    public Material m_Material;

    void Update () {

        if (USpeed != 0 || VSpeed != 0)
        {
            m_offset.x += USpeed * Time.deltaTime;
            if (m_offset.x > 1)
            {
                m_offset.x -= 1;
            }
            else if (m_offset.x < -1)
            {
                m_offset.x += 1;
            }
            m_offset.y += VSpeed * Time.deltaTime;
            if (m_offset.y > 1)
            {
                m_offset.y -= 1;
            }
            else if (m_offset.y < -1)
            {
                m_offset.y += 1;
            }
            //m_Material.mainTextureOffset = m_offset;
            m_Material.SetTextureOffset(TexName, m_offset);
        }

        if (USpeed2 != 0 || VSpeed2 != 0)
        {
            m_offset2.x += USpeed2 * Time.deltaTime;
            if (m_offset2.x > 1)
            {
                m_offset2.x -= 1;
            }
            else if (m_offset2.x < -1)
            {
                m_offset2.x += 1;
            }
            m_offset2.y += VSpeed2 * Time.deltaTime;
            if (m_offset2.y > 1)
            {
                m_offset2.y -= 1;
            }
            else if (m_offset2.y < -1)
            {
                m_offset2.y += 1;
            }
            m_Material.SetTextureOffset(TexName2, m_offset2);
        }
    }
}
