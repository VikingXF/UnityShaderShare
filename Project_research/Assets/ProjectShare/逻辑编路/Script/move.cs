//=============================================
//作者:
//描述:
//创建时间:2021/01/15 14:49:42
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class move : MonoBehaviour
{
    private NavMeshAgent man;
    public Transform target;

    GameObject[] hypPathPoints;
    int hypNextPathPointsIndex = 1;

    private Transform Manpos;
    public GameObject BeforeGO;
    public GameObject AfterGO;
    public GameObject LeftGO;
    public GameObject RightGO;
    // Start is called before the first frame update
    void Start()
    {
        man = gameObject.GetComponent<NavMeshAgent>();

    }

    // Update is called once per frame
    void Update()
    {
        Manpos = gameObject.GetComponent<Transform>();
        //Debug.Log(Manpos.eulerAngles);
        //if (-45 < Manpos.localEulerAngles.y && Manpos.localEulerAngles.y <45)
        //{

        //    BeforeGO.SetActive(true);
        //    AfterGO.SetActive(false);
        //    LeftGO.SetActive(false);
        //    RightGO.SetActive(false);
 
        //}
        //if (  45 < Manpos.localEulerAngles.y && Manpos.localEulerAngles.y < 135 )
        //{

        //    BeforeGO.SetActive(false);
        //    AfterGO.SetActive(false);
        //    LeftGO.SetActive(true);
        //    RightGO.SetActive(false);

        //}
        //if (-135<Manpos.localEulerAngles.y && Manpos.localEulerAngles.y  < -45)
        //{

        //       BeforeGO.SetActive(false);
        //       AfterGO.SetActive(false);
        //       LeftGO.SetActive(false);
        //       RightGO.SetActive(true);
        //}   
        man.SetDestination(target.position);
        //Manpos.localEulerAngles = new Vector3(0, 0, 0);
    }
}

