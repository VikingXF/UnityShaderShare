//=============================================
//作者:XF
//描述:创建正交投影矩阵，为shader提供正交投影矩阵做UV定位
//创建时间:2021/02/21 11:18:00
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BoxProjector : MonoBehaviour
{
    private Matrix4x4 m_worldToProjector;
    public bool InEditMode = true;
    public List<Material> Projectormaterials;

    private void Start()
    {
        if (!InEditMode)
        {
            DeleteCollider();
            SetProjector();
        }
    }
    private void Update()
    {
        if (InEditMode)
        {
            AddCollider();
            SetProjector();
        }
        else
        {
            DeleteCollider();
        }
    }

    //添加BoxCollider
    private void AddCollider()
    {
        if (this.GetComponent<Collider>() == null)
        {
            this.gameObject.AddComponent<BoxCollider>();
        }
    }

    //移除BoxCollider
    private void DeleteCollider()
    {
        if (this.GetComponent<BoxCollider>() != null)
        {
            Destroy(this.GetComponent<BoxCollider>());
        }
    }

    //创建正交投影矩阵，并设置需要使用正交投影矩阵的材质
    private void SetProjector()
    {      
        Matrix4x4 projector = default(Matrix4x4);     
        projector = Matrix4x4.Ortho(-1.5f, 0.5f, -1.5f, 0.5f, 0.5f, -0.5f);
        m_worldToProjector = projector * this.transform.worldToLocalMatrix;

        foreach (Material Projectormaterial in Projectormaterials)
        {
            Projectormaterial.SetMatrix("_WorldToProjector", m_worldToProjector);
        }
    }


}
