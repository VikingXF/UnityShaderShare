//=======================================================
// 作者：xuefei
// 描述：
//=======================================================
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace CombineMeshSpace
{
    public class CombineMesh : MonoBehaviour
    {
        void Start()
        {
            MeshRenderer[] meshRenders = GetComponentsInChildren<MeshRenderer>();
            List<Material> mats = new List<Material>();
          
            for (int i = 0; i < meshRenders.Length; i++)
            {

                for (int j = 0; j < meshRenders[i].sharedMaterials.Length; j++)
                {
                    if (mats.Contains(meshRenders[i].sharedMaterials[j]))
                    {
                        continue;
                    }
                    mats.Add(meshRenders[i].sharedMaterials[j]);                                     
                   
                }

            }

            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
            List<CombineInstance> combine = new List<CombineInstance>();


            //合并Mesh;
            //MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();

            //CombineInstance[] combine = new CombineInstance[meshFilters.Length];

            //for (int k = 0; k < meshFilters.Length; k++)
            //{
            //    combine[k].mesh = meshFilters[k].sharedMesh;
            //    combine[k].transform = meshFilters[k].transform.localToWorldMatrix;
            //    meshFilters[k].gameObject.SetActive(false);
            //}

            //MeshRenderer mr = gameObject.AddComponent<MeshRenderer>();
            //MeshFilter mf = gameObject.AddComponent<MeshFilter>();
            //mf.mesh = new Mesh();
            //mf.mesh.CombineMeshes(combine.ToArray(), false);
            //gameObject.SetActive(true);
            //mr.sharedMaterials = mats.ToArray();
        }
    }
}
