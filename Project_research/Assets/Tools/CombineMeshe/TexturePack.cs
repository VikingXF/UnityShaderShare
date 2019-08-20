using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TexturePack : MonoBehaviour
{
    public Texture2D one;
    public Texture2D two;
    public Texture2D dg;

    // Start is called before the first frame update
    void Start()
    {
        List<Texture2D> textures = new List<Texture2D>();
        textures.Add(one);
        textures.Add(two);
        textures.Add(dg);

        Texture2D skinnedMeshAtlas = new Texture2D(1024, 512);
        skinnedMeshAtlas.PackTextures(textures.ToArray(), 0);
        this.gameObject.GetComponent<MeshRenderer>().material.mainTexture = skinnedMeshAtlas;
    }

    
}
