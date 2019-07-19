//=======================================================
// 作者：刘洋
// 描述：
//=======================================================
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace Babybus.Aircraft
{
    public class Cloth : MonoBehaviour
    {
        //public Transform RootBone;
        public List<Equipmentizer> ClothMeshs;

        public void SetRootBone(Transform rootBone)
        {
            for (int i = 0; i < ClothMeshs.Count; i++)
            {
                ClothMeshs[i].transform.SetParent(transform.parent);
                ClothMeshs[i].SetRootBone(rootBone);
            }
            Destroy(gameObject);
            //gameObject.SetActive(false);
        }
    }
}
