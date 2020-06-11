//=============================================
//作者:
//描述:
//创建时间:2020/06/11 16:37:53
//版本:v 1.0
//=============================================
using UnityEngine;
namespace Babybus.UtilityTools
{
    public sealed class AnchoredPosition : AbstractInformation<AnchoredPosition.Information>
    {
        public override void Save(int index)
        {
            _list[index].anchoredPosition = GetComponent<RectTransform>().anchoredPosition;
        }
        public override void Switch(int index)
        {
            GetComponent<RectTransform>().anchoredPosition = _list[index].anchoredPosition;
        }
        [System.Serializable]
        public sealed class Information : InformationBase
        {
            public Vector3 anchoredPosition;
        }
    }
}
