//=============================================
//作者:
//描述:
//创建时间:2020/06/11 16:37:53
//版本:v 1.0
//=============================================
using UnityEngine;

namespace Babybus.UtilityTools
{
    public sealed class Scale : AbstractInformation<Scale.Information>
    {
        public override void Save(int index)
        {
            _list[index].scale = transform.localScale;
        }

        public override void Switch(int index)
        {
            transform.localScale = _list[index].scale;
        }

        [System.Serializable]
        public sealed class Information : InformationBase
        {
            public Vector3 scale;
        }
    }
}
