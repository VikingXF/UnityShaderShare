//=======================================================
// 作者：xuefei
// 描述：UI转MeshRenderer
//=======================================================


using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class SpriteToMeshRender : MonoBehaviour
{

    // Start is called before the first frame update
    public void StartSpriteToMeshRender()
    {
       
        //SpriteRenderer
        SpriteRenderer[] SRChildrens = GetComponentsInChildren<SpriteRenderer>();
        foreach (var SRChildren in SRChildrens)
        {

            ConverSpriteRenderToMeshRender(SRChildren);
        }

        //Image
        Image[] ImChildrens = GetComponentsInChildren<Image>();
        foreach (var ImChildren in ImChildrens)
        {

            ConverImageToMeshRender(ImChildren);
        }
        
       
    }

    //Image转MeshRender
    public static MeshRenderer ConverImageToMeshRender(Image image)
    {
        Shader shader = UnityEngine.Shader.Find("Unlit/Transparent");
        if (image.sprite == null)
        {
            Debug.LogError(message: "物体名字" + image.gameObject.name + "没有发现");
            return null;
        }
        GameObject go = image.gameObject;
        Sprite sprite = image.sprite;
        Material material = new Material(shader);
        
        Texture texture = image.sprite.texture;
        material.name = image.sprite.texture.name;
        float scaleX =  image.rectTransform.sizeDelta.x / texture.width * 100;
        float scaleY =  image.rectTransform.sizeDelta.y / texture.height * 100;
       

        GameObject.DestroyImmediate(image);
        GameObject.DestroyImmediate(image.canvasRenderer);
        UnityEngine.Mesh mesh = new UnityEngine.Mesh();
        
        mesh.name = sprite.name + "_Mesh";
        mesh.vertices = sprite.vertices.Select(x => (Vector3)x).ToArray();
        mesh.uv = sprite.uv;
        mesh.triangles = sprite.triangles.Select(x => (int)x).ToArray();

        //重新优化排序mesh
        MeshUtility.Optimize(mesh);
        mesh.RecalculateBounds();
        mesh.RecalculateNormals();
        mesh.RecalculateTangents();

        MeshFilter meshFilter = go.AddComponent<MeshFilter>();
        MeshRenderer meshRenderer = go.AddComponent<MeshRenderer>();
        meshFilter.sharedMesh = mesh;
        meshRenderer.sharedMaterial = material;
        meshRenderer.sharedMaterial.mainTexture = texture;
        Unwrapping.GenerateSecondaryUVSet(mesh);
        float localScaleX = go.transform.localScale.x;
        float localScaleY = go.transform.localScale.y;
        go.transform.localScale = new Vector3(localScaleX*scaleX, localScaleY*scaleY, 1);       

        return meshRenderer;
    }

    //SpriteRender转MeshRender
    public static MeshRenderer ConverSpriteRenderToMeshRender(SpriteRenderer spriteRenderer)
    {
        Shader shader = UnityEngine.Shader.Find("Unlit/Transparent");
        if (spriteRenderer.sprite == null)
        {
            Debug.LogError(message: "物体名字" + spriteRenderer.gameObject.name + "没有发现");
            return null;
        }
        GameObject go = spriteRenderer.gameObject;
        Sprite sprite = spriteRenderer.sprite;
        //Material material = spriteRenderer.sharedMaterial;
        Material material = new Material(shader);
        Texture texture = spriteRenderer.sprite.texture;
        material.name = spriteRenderer.sprite.texture.name;
        UnityEngine.Rendering.ShadowCastingMode shadowCastingMode = spriteRenderer.shadowCastingMode;
        bool isReceiveShadw = spriteRenderer.receiveShadows;
        GameObject.DestroyImmediate(spriteRenderer);
        UnityEngine.Mesh mesh = new UnityEngine.Mesh();
        mesh.name = sprite.name + "_Mesh";
        mesh.vertices = sprite.vertices.Select(x => (Vector3)x).ToArray();
        mesh.uv = sprite.uv;
        mesh.triangles = sprite.triangles.Select(x => (int)x).ToArray();
        MeshUtility.Optimize(mesh);
        mesh.RecalculateBounds();
        mesh.RecalculateNormals();
        mesh.RecalculateTangents();
        MeshFilter meshFilter = go.AddComponent<MeshFilter>();
        MeshRenderer meshRenderer = go.AddComponent<MeshRenderer>();
        meshRenderer.shadowCastingMode = shadowCastingMode;
        meshRenderer.receiveShadows = isReceiveShadw;
        meshFilter.sharedMesh = mesh;
        meshRenderer.sharedMaterial = material;
        meshRenderer.sharedMaterial.mainTexture = texture;
        Unwrapping.GenerateSecondaryUVSet(mesh);

        return meshRenderer;
    }

}
