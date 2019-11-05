using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SequenceFrame : MonoBehaviour
{
    public float _Speed;
    public float _CellAmount;

    private void Start()
    {
        this.GetComponent<MeshRenderer>().material.SetFloat("_Speed", _Speed);
        this.GetComponent<MeshRenderer>().material.SetFloat("_CellAmount", _CellAmount);
    }
    private void FixedUpdate()
    {
        
        float timeValX = Mathf.Ceil(Time.time*_Speed % _CellAmount)-1;
        float timeValY = Mathf.Ceil(Time.time * _Speed/4 % _CellAmount);
        this.GetComponent<MeshRenderer>().material.SetFloat("_timeValX", timeValX);
        this.GetComponent<MeshRenderer>().material.SetFloat("_timeValY", timeValY);
        

       // Debug.Log("timeValX:"+ timeValX);
        //Debug.Log("timeValY:" + timeValY);
    }
}
