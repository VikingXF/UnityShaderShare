using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class dfgdg : MonoBehaviour
{
    void Start()
    {
        CombineToMesh(this.gameObject);
    }

    public void CombineToMesh(GameObject _go)
    {
        SkinnedMeshRenderer[] smr = _go.GetComponentsInChildren<SkinnedMeshRenderer>();
        List<CombineInstance> lcom = new List<CombineInstance>();

        List<Material> lmat = new List<Material>();
        List<Transform> ltra = new List<Transform>();

        for (int i = 0; i < smr.Length; i++)
        {
            lmat.AddRange(smr[i].materials);
            ltra.AddRange(smr[i].bones);
            for (int sub = 0; sub < smr[i].sharedMesh.subMeshCount; sub++)
            {
                CombineInstance ci = new CombineInstance();
                ci.mesh = smr[i].sharedMesh;
                ci.subMeshIndex = sub;
                lcom.Add(ci);
            }
            Destroy(smr[i].gameObject);
        }
        SkinnedMeshRenderer _r = _go.GetComponent<SkinnedMeshRenderer>();
        if (_r == null)
        {
            _r = _go.AddComponent<SkinnedMeshRenderer>();
        }
        _r.sharedMesh = new Mesh();
        _r.bones = ltra.ToArray();
        _r.materials = new Material[] { lmat[0] };
        _r.rootBone = _go.transform;
        _r.sharedMesh.CombineMeshes(lcom.ToArray(), false, false);
    }
}
