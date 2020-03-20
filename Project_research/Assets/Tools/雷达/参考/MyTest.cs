using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Babybus.WZKTools;
public class MyTest : MonoBehaviour
{
    private Transform _transform;
    public float Angle;
    public float Accurate;
    public float Length;
    public float From;
    private Quaternion _quaternion;
    private void Change()
    {
        //Look();
    }
    private void Update()
    {
        //transform.position += transform.forward * 0.1f;
        //_transform.rotation = Quaternion.Slerp(_transform.rotation, _quaternion,Time.deltaTime);
        Look();
    }
    //放射线检测
    private void Look()
    {
        //一条向前的射线
        RaycastHit hit = transform.IsHit(Quaternion.identity, Length, -1, From, Color.green);
        if (hit.transform != null) Debug.Log(hit.transform);
        //多一个精确度就多两条对称的射线,每条射线夹角是总角度除与精度
        float subAngle = (Angle / 2) / Accurate;
        for (int i = 0; i < Accurate; i++)
        {
            transform.IsHit(Quaternion.Euler(0, -1 * subAngle * (i + 1), 0), Length, -1, From, Color.green);
            transform.IsHit(Quaternion.Euler(0, subAngle * (i + 1), 0), Length, -1, From, Color.green);
        }
    }
}
