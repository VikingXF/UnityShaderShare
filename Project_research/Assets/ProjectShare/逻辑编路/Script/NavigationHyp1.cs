//=============================================
//作者:
//描述:
//创建时间:2021/01/18 10:15:29
//版本:v 1.0
//=============================================
using UnityEngine;
using System.Collections;
using System;

public class NavigationHyp1 : MonoBehaviour
{
    GameObject[] hypPathPoints;
    int hypNextPathPointsIndex = 1;
    public float speed = 1f;
    public GameObject BeforeGO;
    public GameObject AfterGO;
    public GameObject LeftGO;
    public GameObject RightGO;
    // Use this for initialization
    void Start()
    {
        hypPathPoints = GameObject.FindGameObjectsWithTag("HypPath");
        //得到的数组是反序的，下面对数组排序，两种方法：
        //Array.Reveres(hypPathPoints);
        Array.Sort(hypPathPoints, (x, y) => { return x.gameObject.name.CompareTo(y.gameObject.name); });
        //先到达第一个点的位置  
        transform.position = hypPathPoints[0].transform.position;
        //方向 
        transform.forward = hypPathPoints[hypNextPathPointsIndex].transform.position - transform.position;
    }
    // Update is called once per frame
    void Update()
    {
       
        if (Vector3.Distance(hypPathPoints[hypNextPathPointsIndex].transform.position, transform.position) < 0.1f)
        {       //判断的是物体是否到达最后一个点
            if (hypNextPathPointsIndex != hypPathPoints.Length - 1)
            {
                hypNextPathPointsIndex++;
            }
            //物体到达最后一个点后停在 最后一个点的位置
            if (Vector3.Distance(hypPathPoints[hypPathPoints.Length - 1].transform.position, transform.position) < 0.1f)
            {
                transform.position = hypPathPoints[hypPathPoints.Length - 1].transform.position;
                return;
            }
            //方向的改变
            transform.forward = hypPathPoints[hypNextPathPointsIndex].transform.position - transform.position;
            if (Convert.ToInt32(transform.forward.z) == 1)
            {

                BeforeGO.SetActive(true);
                AfterGO.SetActive(false);
                LeftGO.SetActive(false);
                RightGO.SetActive(false);

            }
            if (Convert.ToInt32(transform.forward.x) == -1)
            {

                BeforeGO.SetActive(false);
                AfterGO.SetActive(false);
                LeftGO.SetActive(true);
                RightGO.SetActive(false);

            }
            if (Convert.ToInt32(transform.forward.x )== 1 )
            {

                BeforeGO.SetActive(false);
                AfterGO.SetActive(false);
                LeftGO.SetActive(false);
                RightGO.SetActive(true);
            }
            if (Convert.ToInt32(transform.forward.z) == -1)
            {

                BeforeGO.SetActive(false);
                AfterGO.SetActive(true);
                LeftGO.SetActive(false);
                RightGO.SetActive(false);

            }
            
            Debug.Log(transform.forward);
        }
        transform.Translate(Vector3.forward * speed * Time.deltaTime, Space.Self);
      
    }
}