//=============================================
//作者:
//描述:
//创建时间:2021/01/18 10:16:42
//版本:v 1.0
//=============================================
using UnityEngine;
using System.Collections;

public class InsHyp : MonoBehaviour
{
    float timer;
    public GameObject hypTarget;
    // Use this for initialization
    void Start()
    {

    }
    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        if (timer >= 2)
        {
            timer = 0;
            GameObject.Instantiate(hypTarget);
        }
        Destroy(hypTarget, 10);
    }
}