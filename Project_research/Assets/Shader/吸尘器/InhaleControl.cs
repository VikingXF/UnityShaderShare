//=============================================
//作者:xf
//描述:吸尘器吸尘效果
//创建时间:2021/03/29 11:05:23
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class InhaleControl : MonoBehaviour
{
    public Material InhaleMaterial;
    public GameObject InhaleGO;
    public float InhaleDist = 2;
    private float Control;
    public float speed = 1;
    private void Start()
    {
        Control = InhaleMaterial.GetFloat("_Control");
    }
    void Update()
    {
        InhaleMaterial.SetVector("_InhalePos", this.transform.position);
        if (Vector3.Distance(InhaleGO.transform.position, this.transform.position)<InhaleDist)
        {
            Tween tween = DOTween.To(() => Control, x => Control = x, 2, speed);

            InhaleMaterial.SetFloat("_Control", Control);
        }
       
       
    }
}
