//=============================================
//作者:
//描述:
//创建时间:2020/04/29 17:10:54
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pef : MonoBehaviour
{
    public AnimationCurve anim;
    public Material go;
    public float gotime;
    private bool gobool = false;
    //private void Start()
    //{
    //    go.SetTextureOffset("_MainTex", new Vector2(0, anim.Evaluate(Time.time)));
    //}
    private void OnEnable()
    {
        gobool = true;
       
    }

    private void OnDisable()
    {
        gobool = false;
    }
    private void Update()
    {
        if (gobool == true)
        {
            Debug.Log(anim.Evaluate(Time.time));
        }
        //go.SetTextureOffset("_MainTex", new Vector2(0, anim.Evaluate(Time.time)));
       
    }
}
