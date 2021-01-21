//=============================================
//作者:
//描述:
//创建时间:2021/01/20 10:59:43
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class padaomove : MonoBehaviour
{
    public float speed = 1f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Translate(Vector3.forward * speed * Time.deltaTime, Space.World);
    }
}
