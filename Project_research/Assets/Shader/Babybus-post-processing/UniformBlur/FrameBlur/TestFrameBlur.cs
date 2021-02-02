using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BabybusPostProcessing;
using UnityEngine.UI;

public class TestFrameBlur : MonoBehaviour
{
    // Start is called before the first frame update
    public void EnblFrameblur()
    {
        this.GetComponent<BabybusPostProcessing.FrameBlurEffect>().enabled = true;
        //this.GetComponent<Image>().enabled = true;
    }

    
}
