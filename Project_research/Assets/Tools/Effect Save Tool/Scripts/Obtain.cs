using System.Collections.Generic;
using UnityEngine;

namespace Babybus.Engineer.Obtain
{
    [System.Serializable]
    public class TransformInformation
    {
        public string _desc = "特效名称";
        public Vector3 _localPosition;
        public Quaternion _localRotation;
        public Vector3 _scale;
        public GameObject _EffectObject;
        public GameObject _parentObject;
        public string _parentName;
    }

    public class Obtain : MonoBehaviour
    {

        public List<TransformInformation> _list = new List<TransformInformation>();
        /// <summary>
        /// 获取信息
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="desc"></param>
        /// <returns></returns>
        public TransformInformation GetInformation(string desc)
        {
            for (int j = 0; j < _list.Count; j++)
            {
                if (_list[j]._desc == desc) return _list[j];
            }
            return null;
        }

    }


   
}
