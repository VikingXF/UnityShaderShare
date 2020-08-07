//=============================================
//作者:
//描述:
//创建时间:2020/08/07 18:58:22
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThreeDimensionalOrigami : MonoBehaviour
{
    public Transform aroundPoint;//围绕的物体
    public float angularSpeed;//角速度
    public float aroundRadius;//半径

    private float angled;
    void Start()
    {
        //Debug.Log(transform.GetComponent<MeshFilter>().mesh.vertices);
        foreach (var item in transform.GetComponent<MeshFilter>().mesh.vertices)
        {
            Debug.Log(item);
        }


        Vector3 p = aroundPoint.rotation * Vector3.forward * aroundRadius;
        transform.GetComponent<MeshFilter>().mesh.vertices[0] = new Vector3(p.x, aroundPoint.position.y, p.z);
        //transform.position = new Vector3(p.x, aroundPoint.position.y, p.z);
    }

   
    void Update()
    {
        angled += (angularSpeed * Time.deltaTime) % 360;//累加已经转过的角度
        float posX = aroundRadius * Mathf.Sin(angled * Mathf.Deg2Rad);//计算x位置
        float posZ = aroundRadius * Mathf.Cos(angled * Mathf.Deg2Rad);//计算y位置
        transform.GetComponent<MeshFilter>().mesh.vertices[0]=new Vector3(posX, 0, posZ) + aroundPoint.position;//更新位置
       // transform.position = new Vector3(posX, 0, posZ) + aroundPoint.position;//更新位置
    }
}
