//=======================================================
// 作者：刘洋
// 描述：一些工具类
//=======================================================

using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;



public class Utility : MonoBehaviour
{
    #region 换装

    // 换装拼接
    /// <summary>
    /// 换装模型拼接，奇奇换装调用此接口后需要根据配置手动设置身体、头、尾巴、耳朵等节点的值
    /// </summary>
    /// <param name="target"></param>
    /// <param name="source"></param>
    /// <param name="isAddCollider"></param>
    public static void AddSkinnedMeshFromModle(Transform target, Transform source, bool isAddCollider = false)
    {
        if (target == null || source == null)
            return;

        SkinnedMeshRenderer[] parts = source.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        if (parts.Length == 0)
            return;

        Transform[] hips = target.GetComponentsInChildren<Transform>();

        List<CombineInstance> combineInstances = new List<CombineInstance>();
        List<Material> materials = new List<Material>();
        List<Transform> bones = new List<Transform>();

        for (int i = 0; i < parts.Length; ++i)
        {
            SkinnedMeshRenderer smr = parts[i];

            CombineInstance ci = new CombineInstance();
            ci.mesh = smr.sharedMesh;
            combineInstances.Add(ci);

            materials.AddRange(smr.sharedMaterials);

            for (int j = 0; j < smr.bones.Length; ++j)
            {
                for (int k = 0; k < hips.Length; ++k)
                {
                    if (smr.bones[j].name != hips[k].name)
                        continue;
                    Debug.Log(hips[k]);

                    bones.Add(hips[k]);
                    break;
                }
            }
        }

        SkinnedMeshRenderer targetSmr = target.GetComponent<SkinnedMeshRenderer>();

        if (targetSmr == null)
            targetSmr = target.gameObject.AddComponent<SkinnedMeshRenderer>();

        targetSmr.sharedMesh = new Mesh();
        targetSmr.sharedMesh.CombineMeshes(combineInstances.ToArray(), false, false);
        targetSmr.sharedMesh.name = source.name;
        targetSmr.bones = bones.ToArray();
        targetSmr.materials = materials.ToArray();

        if (isAddCollider)
        {
            MeshCollider collider = target.gameObject.GetComponent<MeshCollider>();
            if (collider == null)
                collider = target.gameObject.AddComponent<MeshCollider>();
            collider.sharedMesh = new Mesh();
            collider.sharedMesh.name = source.name;
            targetSmr.BakeMesh(collider.sharedMesh);
        }

        Resources.UnloadUnusedAssets();
    }

    /// <summary>
    /// 多个换装模型拼接，奇奇换装调用此接口后需要根据配置手动设置身体、头、尾巴、耳朵等节点的值
    /// </summary>
    /// <param name="target"></param>
    /// <param name="source"></param>
    /// <param name="isAddCollider"></param>
    public static void AddSkinnedMeshFromModle(Transform target, Transform[] source, bool isAddCollider = false)
    {
        if (target == null || source == null)
            return;

        int meshCount = 0;
        for (int i = 0; i < source.Length; i++)
        {
            SkinnedMeshRenderer[] temp = source[i].GetComponentsInChildren<SkinnedMeshRenderer>(true);
            if (temp == null)
                continue;
            meshCount += temp.Length;
        }

        if (meshCount == 0)
            return;
        SkinnedMeshRenderer[] parts = new SkinnedMeshRenderer[meshCount];
        string meshName = "";

        int addCount = 0;
        for (int i = 0; i < source.Length; i++)
        {
            SkinnedMeshRenderer[] temp = source[i].GetComponentsInChildren<SkinnedMeshRenderer>(true);
            if (temp == null)
                continue;
            for (int n = 0; n < temp.Length; n++)
            {
                parts[addCount] = temp[n];
                addCount++;
            }

            meshName += "-" + source[i].name;
        }

        if (parts.Length == 0)
            return;

        Transform[] hips = target.GetComponentsInChildren<Transform>();

        List<CombineInstance> combineInstances = new List<CombineInstance>();
        List<Material> materials = new List<Material>();
        List<Transform> bones = new List<Transform>();

        for (int i = 0; i < parts.Length; ++i)
        {
            SkinnedMeshRenderer smr = parts[i];
            CombineInstance ci = new CombineInstance();
            ci.mesh = smr.sharedMesh;
            combineInstances.Add(ci);

            materials.AddRange(smr.sharedMaterials);

            for (int j = 0; j < smr.bones.Length; ++j)
            {
                for (int k = 0; k < hips.Length; ++k)
                {
                    if (smr.bones[j].name != hips[k].name)
                        continue;
                    Debug.Log(hips[k]);
                    bones.Add(hips[k]);
                    break;
                }
            }
        }

        SkinnedMeshRenderer targetSmr = target.GetComponent<SkinnedMeshRenderer>();

        if (targetSmr == null)
            targetSmr = target.gameObject.AddComponent<SkinnedMeshRenderer>();

        targetSmr.sharedMesh = new Mesh();
        targetSmr.sharedMesh.CombineMeshes(combineInstances.ToArray(), false, false);
        targetSmr.sharedMesh.name = meshName;
        targetSmr.bones = bones.ToArray();
        targetSmr.materials = materials.ToArray();

        if (isAddCollider)
        {
            MeshCollider collider = target.gameObject.GetComponent<MeshCollider>();
            if (collider == null)
                collider = target.gameObject.AddComponent<MeshCollider>();
            collider.sharedMesh = new Mesh();
            collider.sharedMesh.name = meshName;
            targetSmr.BakeMesh(collider.sharedMesh);
        }

        Resources.UnloadUnusedAssets();
    }

    #endregion
}