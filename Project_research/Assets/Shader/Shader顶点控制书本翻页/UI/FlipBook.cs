using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class FlipBook : MonoBehaviour
{
    public GameObject LeftButton;
    public GameObject RightButton;
    public List<Texture2D> bookTex;
    public float speed = 10;
    private Material bookmaterial;
    private int page;
    private void Start()
    {
        bookmaterial = transform.GetComponent<Renderer>().material;
        page = 0;
        LeftButton.SetActive(false);
    }
    public void Leftflip()
    {
        bookmaterial.SetFloat("_PageAngle", 0f);
        bookmaterial.SetInt("_Direction", (int)1);
        bookmaterial.DisableKeyword("_DIRECTION_TURNLEFT");
        bookmaterial.EnableKeyword("_DIRECTION_TURNRIGHT");
        bookmaterial.DOFloat(1, "_PageAngle", speed).OnComplete(delegate ()
        {
            bookmaterial.SetTexture("_MainPage2", bookTex[page]);
        });
        
        page -= 1;
        if (page == 2)
        {
            LeftButton.SetActive(false);
        }
        Debug.Log(page);
    }

    public void Rightflip()
    {
        bookmaterial.SetFloat("_PageAngle", 0f);
        bookmaterial.SetInt("_Direction", (int)0);
        bookmaterial.EnableKeyword("_DIRECTION_TURNLEFT");
        bookmaterial.DisableKeyword("_DIRECTION_TURNRIGHT");      
        bookmaterial.DOFloat(1, "_PageAngle", speed).OnComplete(delegate()
        {
            bookmaterial.SetTexture("_MainPage1", bookTex[page]);
        }
        );
        page += 1;
        LeftButton.SetActive(true);
        if (page == 2)
        {
            RightButton.SetActive(false);
        }
        Debug.Log(page);
    }
    

}
