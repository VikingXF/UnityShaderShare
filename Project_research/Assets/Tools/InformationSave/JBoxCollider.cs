//=============================================
//作者:
//描述:
//创建时间:2020/06/11 16:37:52
//版本:v 1.0
//=============================================
using UnityEngine;
namespace Babybus.UtilityTools
{
    public class JBoxCollider : AbstractInformation<JBoxCollider.Information>
    {
        public override void Save(int index)
        {
            BoxCollider boxCollider = transform.GetComponent<BoxCollider>();
            _list[index].center = boxCollider.center;
            _list[index].size = boxCollider.size;
        }
        public override void Switch(int index)
        {
            BoxCollider boxCollider = transform.GetComponent<BoxCollider>();
            boxCollider.center = _list[index].center;
            boxCollider.size = _list[index].size;
        }
        [System.Serializable]
        public sealed class Information : InformationBase
        {
            public Vector3 center;
            public Vector3 size;
        }
    }
}
