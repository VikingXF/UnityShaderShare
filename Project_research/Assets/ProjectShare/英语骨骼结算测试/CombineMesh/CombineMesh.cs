using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombineMesh : MonoBehaviour
{
    public Transform Target;
    // Start is called before the first frame update
    void Start()
    {
        //AddSkinnedMeshFromModle(Target, transform);
        CombineCustomMesh();

    }

    //Mesh Renderer 合并
    void CombineCustomMesh()
    {

        MeshFilter[] mfChildren = GetComponentsInChildren<MeshFilter>();
       // CombineInstance[] combine = new CombineInstance[mfChildren.Length];
        List<CombineInstance> combine = new List<CombineInstance>();

        MeshRenderer[] mrChildren = GetComponentsInChildren<MeshRenderer>();
        //Material[] materials = new Material[];
        List<Material> materials = new List<Material>();

        MeshRenderer mrSelf = gameObject.AddComponent<MeshRenderer>();
        MeshFilter mfSelf = gameObject.AddComponent<MeshFilter>();


        //Texture2D[] textures = new Texture2D[mrChildren.Length];
        List<Texture2D> textures = new List<Texture2D>();

        for (int i = 0; i < mrChildren.Length; i++)
        {

            for (int j = 0; j < mrChildren[i].materials.Length; j++)
            {
               
                materials.Add(mrChildren[i].sharedMaterials[j]);
                Texture2D tx = mrChildren[i].sharedMaterials[j].GetTexture("_MainTex") as Texture2D;
                Texture2D tx2D = new Texture2D(tx.width, tx.height, TextureFormat.ARGB32, false);
                tx2D.SetPixels(tx.GetPixels(0, 0, tx.width, tx.height));
                tx2D.Apply();
                //textures[i] = tx2D;
                textures.Add(tx2D);
            }
           
        
        }


        Material materialNew = new Material(materials[0].shader);
        materialNew.CopyPropertiesFromMaterial(materials[0]);
        mrSelf.sharedMaterial = materialNew;


        Texture2D texture = new Texture2D(1024, 1024);
        materialNew.SetTexture("_MainTex", texture);
        Rect[] rects = texture.PackTextures(textures.ToArray(), 10, 1024);


        for (int i = 0; i < mfChildren.Length; i++)
        {

            for (int sub = 0; sub < mfChildren[i].sharedMesh.subMeshCount; sub++)
            {
                CombineInstance ci = new CombineInstance();
                Rect rect = rects[i];
                Mesh meshCombine = mfChildren[i].sharedMesh;
               // Vector2[] uvs = new Vector2[meshCombine.uv.Length];

                //把网格的uv根据贴图的rect刷一遍
                //for (int j = 0; j < uvs.Length; j++)
                //{
                //    uvs[j].x = rect.x + meshCombine.uv[j].x * rect.width;
                //    uvs[j].y = rect.y + meshCombine.uv[j].y * rect.height;
                //}
                //meshCombine.uv = uvs;

                ci.mesh = meshCombine;
                ci.subMeshIndex = sub;
                combine.Add(ci);
                combine.ToArray()[i].transform = mfChildren[i].transform.localToWorldMatrix;
            }
           
            mfChildren[i].gameObject.SetActive(false);
        }


        Mesh newMesh = new Mesh();
        newMesh.CombineMeshes(combine.ToArray(), false, true);//合并网格
        mfSelf.mesh = newMesh;
    }


    // 换装拼接
    /// <summary>
    /// 将skinnedmeshrenderer合并在一起，共享一个骨架。
    /// 合并材质会减少drawcall，但是会增加内存的大小。
    /// </summary>
    /// <param name="target">目标合并的物体</param>
    /// <param name="source">源合并的物体</param>
    /// <param name=""></param>
    public static void AddSkinnedMeshFromModle(Transform target, Transform source)
    {
        if (target == null || source == null)
            return;

        SkinnedMeshRenderer[] sourceSkinnedMesh = source.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        if (sourceSkinnedMesh.Length == 0)
            return;

        List<CombineInstance> combineInstances = new List<CombineInstance>();
        List<Material> materials = new List<Material>();
        List<Transform> bones = new List<Transform>();

        for (int i = 0; i < sourceSkinnedMesh.Length; i++)
        {
            Debug.Log(sourceSkinnedMesh[i].name);

            SkinnedMeshRenderer smr = sourceSkinnedMesh[i];

            materials.AddRange(smr.sharedMaterials);
          
            //CombineInstance ci = new CombineInstance();
            //ci.mesh = smr.sharedMesh;
            //combineInstances.Add(ci);


            //materials.AddRange(smr.sharedMaterials);

            //for (int j = 0; j < smr.bones.Length; ++j)
            //{


            //    //for (int k = 0; k < hips.Length; ++k)
            //    //{
            //    //    if (smr.bones[j].name != hips[k].name)
            //    //        continue;
            //    //    Debug.Log(hips[k]);

            //    //    bones.Add(hips[k]);
            //    //    break;
            //    //}
            //}
        }

        foreach (var material in materials)
        {
            Debug.Log(material.name);
        }
       

    }

    //   /// <summary>
    //   /// 将skinnedmeshrenderer合并在一起，共享一个骨架。.
    //   /// 合并材质会减少drawcall，但是会增加内存的大小。
    //   /// </summary>
    //   /// <param name="skeleton">将网格合并到这个骨架(gameobject)</param>
    //   /// <param name="meshes">网格需要合并</param>
    //   /// <param name="combine">是否合并材质</param>
    //public void CombineObject(GameObject skeleton, SkinnedMeshRenderer[] meshes, bool combine = false)
    //   {

    //       // skeleton  遍历所有骨骼并存放
    //       List<Transform> transforms = new List<Transform>();
    //       transforms.AddRange(skeleton.GetComponentsInChildren<Transform>(true));

    //       List<Material> materials = new List<Material>();//materials  List 
    //       List<CombineInstance> combineInstances = new List<CombineInstance>();//meshes  List
    //       List<Transform> bones = new List<Transform>();//bones  List

    //       // 下面的信息只用于合并materilas(bool combine = true)
    //       List<Vector2[]> oldUV = null;
    //       Material newMaterial = null;
    //       Texture2D newDiffuseTex = null;

    //       //从meshes中收集信息
    //       for (int i = 0; i < meshes.Length; i++)
    //       {
    //           SkinnedMeshRenderer smr = meshes[i];
    //           materials.AddRange(smr.materials); // Collect materials
    //                                              // Collect meshes
    //           for (int sub = 0; sub < smr.sharedMesh.subMeshCount; sub++)
    //           {
    //               CombineInstance ci = new CombineInstance();
    //               ci.mesh = smr.sharedMesh;
    //               ci.subMeshIndex = sub;
    //               combineInstances.Add(ci);
    //           }
    //           // Collect bones
    //           for (int j = 0; j < smr.bones.Length; j++)
    //           {
    //               int tBase = 0;
    //               for (tBase = 0; tBase < transforms.Count; tBase++)
    //               {
    //                   if (smr.bones[j].name.Equals(transforms[tBase].name))
    //                   {
    //                       bones.Add(transforms[tBase]);
    //                       break;
    //                   }
    //               }
    //           }
    //       }

    //       // merge materials
    //       if (combine)
    //       {
    //           newMaterial = new Material(Shader.Find("Mobile/Diffuse"));
    //           oldUV = new List<Vector2[]>();
    //           // merge the texture
    //           List<Texture2D> Textures = new List<Texture2D>();
    //           for (int i = 0; i < materials.Count; i++)
    //           {
    //               Textures.Add(materials[i].GetTexture(COMBINE_DIFFUSE_TEXTURE) as Texture2D);
    //           }

    //           newDiffuseTex = new Texture2D(COMBINE_TEXTURE_MAX, COMBINE_TEXTURE_MAX, TextureFormat.RGBA32, true);
    //           Rect[] uvs = newDiffuseTex.PackTextures(Textures.ToArray(), 0);
    //           newMaterial.mainTexture = newDiffuseTex;

    //           // reset uv
    //           Vector2[] uva, uvb;
    //           for (int j = 0; j < combineInstances.Count; j++)
    //           {
    //               uva = (Vector2[])(combineInstances[j].mesh.uv);
    //               uvb = new Vector2[uva.Length];
    //               for (int k = 0; k < uva.Length; k++)
    //               {
    //                   uvb[k] = new Vector2((uva[k].x * uvs[j].width) + uvs[j].x, (uva[k].y * uvs[j].height) + uvs[j].y);
    //               }
    //               oldUV.Add(combineInstances[j].mesh.uv);
    //               combineInstances[j].mesh.uv = uvb;
    //           }
    //       }


    //   }
}
