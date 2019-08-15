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
            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();

            List<Material> mats = new List<Material>();
            List<CombineInstance> combine = new List<CombineInstance>();
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
            foreach (var item in mats)
            {
                Debug.Log(item.name);
            }
           
            Debug.Log("==================================");
            for (int t = 0; t < meshFilters.Length; t++)
            {

                for (int k = 0; k < meshFilters[t].sharedMesh.subMeshCount; k++)
                {
                    Debug.Log(meshFilters[t].sharedMesh.subMeshCount);
                }

            }



            //获取MeshRender;
            //MeshRenderer[] meshRenders = GetComponentsInChildren<MeshRenderer>();

            ////材质;
            //Material[] mats = new Material[meshRenders.Length];

            //for (int i = 0; i < meshRenders.Length; i++)
            //{

            //     mats[i] = meshRenders[i].sharedMaterial;


            //}

            ////合并Mesh;
            //MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();

            //CombineInstance[] combine = new CombineInstance[meshFilters.Length];

            //for (int i = 0; i < meshFilters.Length; i++)
            //{
            //    combine[i].mesh = meshFilters[i].sharedMesh;
            //    combine[i].transform = meshFilters[i].transform.localToWorldMatrix;
            //    meshFilters[i].gameObject.SetActive(false);
            //}

            //MeshRenderer mr = gameObject.AddComponent<MeshRenderer>();
            //MeshFilter mf = gameObject.AddComponent<MeshFilter>();
            //mf.mesh = new Mesh();
            //mf.mesh.CombineMeshes(combine, false);
            //gameObject.SetActive(true);
            //mr.sharedMaterials = mats;
        }
    }
}
