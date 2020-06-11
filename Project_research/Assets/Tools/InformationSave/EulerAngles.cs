//=============================================
//作者:
//描述:
//创建时间:2020/06/11 16:37:53
//版本:v 1.0
//=============================================
using UnityEngine;
namespace Babybus.UtilityTools
{
    public sealed class EulerAngles : AbstractInformation<EulerAngles.Information>
    {
        public override void Save(int index)
        {
            _list[index].eulerAngles = transform.eulerAngles;
        }
        public override void Switch(int index)
        {
            transform.eulerAngles = _list[index].eulerAngles;
        }
        [System.Serializable]
        public sealed class Information : InformationBase
        {
            public Vector3 eulerAngles;
        }
    }
}
