//=============================================
//作者:
//描述:
//创建时间:2020/06/11 16:37:53
//版本:v 1.0
//=============================================
using UnityEngine;

namespace Babybus.UtilityTools
{
    public class CameraInfo : AbstractInformation<CameraInfo.Information>
    {
        public override void Save(int index)
        {
            var c = GetComponent<Camera>();
            var tf = transform;
            _list[index].localPosition = tf.localPosition;
            _list[index].localEulerAngles = tf.localEulerAngles;
            _list[index].orthographic = c.orthographic;
            _list[index].orthographicSize = c.orthographicSize;
            _list[index].fieldofView = c.fieldOfView;
        }

        public override void Switch(int index)
        {
            var c = GetComponent<Camera>();
            var tf = transform;
            tf.localPosition = _list[index].localPosition;
            tf.localEulerAngles = _list[index].localEulerAngles;
            c.orthographic = _list[index].orthographic;
            c.orthographicSize = _list[index].orthographicSize;
            c.fieldOfView = _list[index].fieldofView;
        }

        [System.Serializable]
        public sealed class Information : InformationBase
        {
            public Vector3 localPosition;
            public Vector3 localEulerAngles;
            public bool orthographic;
            public float orthographicSize;
            public float fieldofView;
        }
    }
}