//=======================================================
// 作者：薛飞  2021/4/2 11:41:10
// 描述：
//=======================================================

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace EffectTools
{
    public class EffectMove : MonoBehaviour
    {
        
        public List<effectmov> effectlist = new List<effectmov>();
        //public string ElvesName;
        //public string ElvesNodeName;
        //public GameObject EffectPrefab;
        //public Transform EffectPrefabTransform;

        public GameObject PlaceGo;

    }
    [System.Serializable]
    public class effectmov
    {
        public string ElfName = "精灵";
        public string NodeName = "mouth";
        public GameObject EffectGo;
        public Vector3 _localPosition;
        public Vector3 _position;
        public Quaternion _rotation;
        public Quaternion _localRotation;
        public Vector3 _localScale;

        //public Transform Effecttra;
       
    }
}
