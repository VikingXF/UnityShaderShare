//=======================================================
// 作者：薛飞  2021/4/2 17:32:22
// 描述：
//=======================================================

using System.Collections.Generic;
using UnityEngine;

namespace EffectTools
{
    //[System.Serializable]
    [SerializeField]
    public class EffectMoveScriptableobject : ScriptableObject
    {
        public List<effectmov> _positionList = new List<effectmov>();
    }
}
