﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class FlipBook : MonoBehaviour
{
    public GameObject LeftButton;
    public GameObject RightButton;
    public List<Texture2D> bookTex;
    public float speed = 1f;
    private Material bookmaterial;
    private int page = 0;
    private void Start()
    {
        bookmaterial = transform.GetComponent<Renderer>().material;
        if (page == 0)
        {
            LeftButton.SetActive(false);
        }
        if (page == bookTex.Count-1)
        {
            RightButton.SetActive(false);
        }
        bookmaterial.SetTexture("_MainPage1", bookTex[page]);
        bookmaterial.SetTexture("_MainPage2", bookTex[page]);
        bookmaterial.SetFloat("_PageAngle", 1f);

    }
    public void LButton()
    {
        if (bookmaterial.GetFloat("_PageAngle")==1f)
        {
            Leftflip();
        }
       
    }
    public void RButton()
    {
        if (bookmaterial.GetFloat("_PageAngle") == 1f)
        {
            Rightflip();
        }

    }

    public void Leftflip()
    {
        bookmaterial.SetFloat("_PageAngle", 0f);
        bookmaterial.SetTexture("_MainPage1", bookTex[page-1]);
        bookmaterial.SetTexture("_MainPage2", bookTex[page]);
        bookmaterial.SetInt("_Direction", (int)1);
        bookmaterial.DisableKeyword("_DIRECTION_TURNLEFT");
        bookmaterial.EnableKeyword("_DIRECTION_TURNRIGHT");
        bookmaterial.DOFloat(1, "_PageAngle", speed).OnComplete(delegate ()
        {           
            
        });
        page -= 1;
        if (page < bookTex.Count)
        {
            RightButton.SetActive(true);
        }
       
        if (page == 0)
        {
            LeftButton.SetActive(false);
        }
        Debug.Log(page);
    }

    public void Rightflip()
    {
        bookmaterial.SetFloat("_PageAngle", 0f);
        bookmaterial.SetTexture("_MainPage1", bookTex[page]);
        bookmaterial.SetTexture("_MainPage2", bookTex[page+1]);
        bookmaterial.SetInt("_Direction", (int)0);
        bookmaterial.EnableKeyword("_DIRECTION_TURNLEFT");
        bookmaterial.DisableKeyword("_DIRECTION_TURNRIGHT");      
        bookmaterial.DOFloat(1, "_PageAngle", speed).OnComplete(delegate()
        {            
           
        }
        );
        page += 1;
        if (page !=0)
        {
            LeftButton.SetActive(true);
        }
       
        if (page == bookTex.Count - 1)
        {
            RightButton.SetActive(false);
        }
        Debug.Log(page);
    }
    

}
