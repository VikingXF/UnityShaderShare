//=======================================================
// 作者：xuefei
// 描述：控制材质球UV
//=======================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UV_Animation2 : MonoBehaviour {

    public string TexName = "_MainTex";
    public bool UAnimation = true;
    public float USpeed = 0;
    public bool VAnimation = true;
    public float VSpeed = 0;
    Vector2 m_offset = new Vector2();
    Vector2 n_offset = new Vector2();

    public string TexName2 = "_Mask";
    public bool UAnimation2 = true;
    public float USpeed2 = 0;
    public bool VAnimation2 = true;
    public float VSpeed2 = 0;
    Vector2 m_offset2 = new Vector2();
    Vector2 n_offset2 = new Vector2();

    public Material m_Material;

    private void Start()
    {
        n_offset.x = USpeed;
        n_offset.y = VSpeed;

        n_offset2.x = USpeed2;
        n_offset2.y = VSpeed2;

    }

    void Update () {

        if (USpeed != 0 || VSpeed != 0)
        {
            if (UAnimation == true)
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
            }
            if (UAnimation == false && n_offset.x != USpeed)
            {
                m_offset.x = USpeed;
                n_offset.x = USpeed;
            }

            if (VAnimation == true)
            {
                m_offset.y += VSpeed * Time.deltaTime;
                if (m_offset.y > 1)
                {
                    m_offset.y -= 1;
                }
                else if (m_offset.y < -1)
                {
                    m_offset.y += 1;
                }
            }
            if (VAnimation == false && n_offset.y != VSpeed)
            {
               
                m_offset.y = VSpeed;
                n_offset.y = VSpeed;
              
            }

            //m_Material.mainTextureOffset = m_offset;
            m_Material.SetTextureOffset(TexName, m_offset);
        }

        if (USpeed2 != 0 || VSpeed2 != 0)
        {
            if (UAnimation2 == true)
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
            }
            if (UAnimation2 == false && n_offset2.x != USpeed2)
            {
                m_offset2.x = USpeed2;
                n_offset2.x = USpeed2;
            }

            if (VAnimation2 == true)
            {
                m_offset2.y += VSpeed2 * Time.deltaTime;
                if (m_offset2.y > 1)
                {
                    m_offset2.y -= 1;
                }
                else if (m_offset2.y < -1)
                {
                    m_offset2.y += 1;
                }              
            }
            if (VAnimation2 == false && n_offset2.y != VSpeed2)
            {

                m_offset2.y = VSpeed2;
                n_offset2.y = VSpeed2;

            }
            m_Material.SetTextureOffset(TexName2, m_offset2);
        }
    }
}
