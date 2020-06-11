//=============================================
//作者:
//描述:
//创建时间:2020/06/11 16:37:53
//版本:v 1.0
//=============================================
using UnityEngine;
namespace Babybus.UtilityTools
{
    public class TrailRendererInfo:AbstractInformation<TrailRendererInfo.Information>
    {
        public override void Save(int index)
        {
            TrailRenderer tr = transform.GetComponent<TrailRenderer>();
            _list[index].time = tr.time;
        }

        public override void Switch(int index)
        {
            TrailRenderer tr = transform.GetComponent<TrailRenderer>();
            tr.time = _list[index].time;
        }
        
        [System.Serializable]
        public sealed class Information : InformationBase
        {
            public float time;
        }
    }
}