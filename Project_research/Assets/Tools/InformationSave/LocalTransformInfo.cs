//=============================================
//作者:
//描述:
//创建时间:2020/06/11 16:37:53
//版本:v 1.0
//=============================================
using UnityEngine;
namespace Babybus.UtilityTools
{
    public class LocalTransformInfo : AbstractInformation<LocalTransformInfo.Information>
    {
        public override void Save(int index)
        {
            var tf = transform;
            _list[index].localPosition = tf.localPosition;
            _list[index].localEulerAngles = tf.localEulerAngles;
            _list[index].localScale = tf.localScale;
        }
        public override void Switch(int index)
        {
            var tf = transform;
            tf.localPosition = _list[index].localPosition;
            tf.localEulerAngles = _list[index].localEulerAngles;
            tf.localScale = _list[index].localScale;
        }
        [System.Serializable]
        public sealed class Information : InformationBase
        {
            public Vector3 localPosition;
            public Vector3 localEulerAngles;
            public Vector3 localScale;
        }
    }
}

