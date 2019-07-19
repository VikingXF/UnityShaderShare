//=======================================================
// 作者：刘洋
// 描述：
//=======================================================

using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
 
public class Equipmentizer : MonoBehaviour
{
    public Transform RootBones;
    private List<Transform> bones;
    Dictionary<string, Transform> boneMap = new Dictionary<string, Transform>();
    public bool IsStart;
    private void Start()
    {
        if (IsStart)
        {
            SetRootBone(RootBones);
        }
    }

    public void SetRootBone(Transform rootBone)
    {
        RootBones = rootBone;
        SkinnedMeshRenderer myRenderer = gameObject.GetComponent<SkinnedMeshRenderer>();
        bones = RootBones.GetComponentsInChildren<Transform>().ToList();
        foreach (Transform bone in bones)
        {
            boneMap.Add(bone.gameObject.name,bone);
        }

        for (int i = 0; i < myRenderer.bones.Length; i++)
        {
            if (!boneMap.Keys.Contains(myRenderer.bones[i].name))
            {
                CreateBoneParent(myRenderer.bones[i]);
            }
        }
        Transform[] newBones = new Transform[myRenderer.bones.Length];
        for (int i = 0; i < myRenderer.bones.Length; ++i)
        {
            GameObject bone = myRenderer.bones[i].gameObject;
            if (!boneMap.TryGetValue(bone.name, out newBones[i]))
            {
                Debug.Log("Unable to map bone \"" + bone.name + "\" to target skeleton.");
                break;
            }
        }
        myRenderer.bones = newBones;
 
    }

    public Transform CreateBoneParent(Transform bone)
    {
        Transform parent = null;
        Transform boneParent = bone.parent;
        if (!boneMap.TryGetValue(boneParent.name, out parent))
        {
            parent = CreateBoneParent(boneParent);
        }

        GameObject boneObj = bone.gameObject;//new GameObject();
        //boneObj.name = bone.name;
        boneObj.transform.SetParent(parent);
//        boneObj.transform.position = bone.position;
//        boneObj.transform.rotation = bone.rotation;
//        boneObj.transform.localScale = bone.localScale;
        boneMap.Add(boneObj.transform.name, boneObj.transform);
        return boneObj.transform;
    }
}