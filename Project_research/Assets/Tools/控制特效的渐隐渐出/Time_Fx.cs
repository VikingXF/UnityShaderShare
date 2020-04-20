using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
[ExecuteInEditMode]
public class Time_Fx : MonoBehaviour
{
    public List<Time_all> TimeGameObj = new List<Time_all>();
    private float[] time00 = null;
    private float[] TimeSin = null;
    private float[] Timestart = null;
    private float m_time;

    private void OnEnable()
    {
        TimeSin = new float[TimeGameObj.Count];
        time00 = new float[TimeGameObj.Count];
        Timestart = new float[TimeGameObj.Count];
        //在OnEnable里面记录Time.time 因为它只运行一次 所以可以记录下来开始运行的时间
        m_time = Time.time;


    }

    void Update()
    {
        for (int i = 0; i < TimeGameObj.Count; i++)
        {
            Timestart[i] = m_time;

            if (Time.time - Timestart[i] < TimeGameObj[i].Start)
            {
                TimeSin[i] = 0;
            }
            else
            {


                if (time00[i] < 1)
                {
                    time00[i] = (Time.time - m_time - TimeGameObj[i].Start) / (TimeGameObj[i].Starting + 0.01f);
                    TimeSin[i] = time00[i];
                }

                else if (time00[i] >= 1 && time00[i] < 2)
                {
                    TimeSin[i] = 1;
                    time00[i] = 1 + (Time.time - m_time - TimeGameObj[i].Start - TimeGameObj[i].Starting) / (TimeGameObj[i].Miding + 0.01f);


                }

                else if (time00[i] >= 2 && time00[i] < 3)
                {
                    time00[i] = 2 + (Time.time - m_time - TimeGameObj[i].Start - TimeGameObj[i].Starting - TimeGameObj[i].Miding) / (TimeGameObj[i].Ending + 0.01f);
                    if (TimeSin[i] >= 0)
                    {

                        TimeSin[i] = 1 - (Time.time - m_time - TimeGameObj[i].Start - TimeGameObj[i].Starting - TimeGameObj[i].Miding) / (TimeGameObj[i].Ending + 0.01f);

                        if (TimeSin[i] < 0)
                        {
                            TimeSin[i] = 0;
                        }
                    }
                }
            }

            TimeGameObj[i].gameObj.GetComponent<MeshRenderer>().sharedMaterial.SetFloat("_TimeSin", TimeSin[i]);
        }
    }
}





[Serializable]
public class Time_all
{
    [SerializeField]
    public GameObject gameObj;

    [SerializeField]
    public float Start;

    [SerializeField]
    public float Starting;



    [SerializeField]
    public float Miding;

    [SerializeField]
    public float Ending;
}
