//=============================================
//作者:
//描述:
//创建时间:2020/07/01 17:23:53
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class ButtonChange : MonoBehaviour
{
    public float myValue = -1f;
    public GameObject gg;
    bool g = false;
    public void buttonchage()
    {
        g = true;
        DOTween.To(()=>myValue, x=>myValue = x, 2f, 5);
        
       
    }
    private void Update()
    {
        if (g)
        {
            gg.GetComponent<MeshRenderer>().sharedMaterial.SetFloat("_BlendRange", myValue);
        }
      
    }
}
