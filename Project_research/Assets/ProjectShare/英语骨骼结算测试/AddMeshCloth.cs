//=======================================================
// 作者：刘洋
// 描述：
//=======================================================

using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace Babybus.Aircraft
{
    public class AddMeshCloth : MonoBehaviour
    {
        public List<GameObject> ClothMeshs;
        public Transform RootBone;
        private void Start()
        {
            for (int i = 0; i < ClothMeshs.Count; i++)
            {
                GameObject cloth = Instantiate(ClothMeshs[i], transform);
                cloth.GetComponent<Cloth>().SetRootBone(RootBone);
            }
        }
    }
}
