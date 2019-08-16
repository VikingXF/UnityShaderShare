//=======================================================
// 作者：xuefei
// 描述：Mesh 合并
// 1.实现多个Mesh合并为一个Mesh的多维材质 ==》CombineBasicMesh()
// 2.实现多个Mesh合并，贴图合并，材质合并为一个
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

            CombineBasicMesh();

        }

        //合并共享材质
        void CombineBasicMesh()
        {
            MeshRenderer[] meshRenders = GetComponentsInChildren<MeshRenderer>();
            List<Material> mats = new List<Material>();
            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
            List<CombineInstance> combine = new List<CombineInstance>();
            GameObject go = new GameObject();

            for (int i = 0; i < meshRenders.Length; i++)
            {
                for (int j = 0; j < meshRenders[i].sharedMaterials.Length; j++)
                {
                    CombineInstance com = new CombineInstance();
                    com.mesh = meshFilters[i].mesh;
                    com.subMeshIndex = j;
                    com.transform = meshFilters[i].transform.localToWorldMatrix;

                    //判断相同材质公用
                    if (mats.Contains(meshRenders[i].sharedMaterials[j]))
                    {
                        var t = mats.IndexOf(meshRenders[i].sharedMaterials[j]);

                        CombineInstance[] comM = new CombineInstance[2] { combine.ToArray()[t], com };
                        Mesh mm = new Mesh();
                        mm.CombineMeshes(comM, true);

                        CombineInstance comcom = new CombineInstance();
                        comcom.mesh = mm;                        
                        comcom.transform = go.transform.localToWorldMatrix;
                        combine[t] = comcom;

                        continue;
                    }

                    combine.Add(com);
                    mats.Add(meshRenders[i].sharedMaterials[j]);
                }
                meshFilters[i].gameObject.SetActive(false);
            }

            MeshRenderer mr = gameObject.AddComponent<MeshRenderer>();
            MeshFilter mf = gameObject.AddComponent<MeshFilter>();
            mf.mesh = new Mesh();
            mf.mesh.CombineMeshes(combine.ToArray(), false);
            gameObject.SetActive(true);
            mr.sharedMaterials = mats.ToArray();
            Destroy(go);
        }
    }
}
