using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProceduralTexture : MonoBehaviour
{
    #region Public Variables
    public int widthHeight = 512;
    public Texture2D generatedTexture;
    #endregion

    #region private Variables
    private Material currentmaterial;
    private Vector2 centerPosition;
    #endregion
    void Start()
    {
        if (!currentmaterial)
        {
            currentmaterial = this.GetComponent<MeshRenderer>().sharedMaterial;
            if (!currentmaterial)
            {
                Debug.LogWarning("Cannot find a material on :" + this.gameObject.name);
            }
        }

        if (currentmaterial)
        {
            centerPosition = new Vector2(0.5f, 0.5f);
            generatedTexture = GenerateParabola();
            currentmaterial.SetTexture("_MainTex", generatedTexture);
        }
    }

    private Texture2D GenerateParabola()
    {

        return generatedTexture;
    }

    void Update()
    {
        
    }
}
