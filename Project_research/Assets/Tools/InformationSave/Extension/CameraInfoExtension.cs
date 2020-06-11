using UnityEngine;

namespace Babybus.UtilityTools
{
    public static class CameraInfoExtension
    {
        public static CameraInfo.Information GetCameraInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<CameraInfo>()._list.Find(n => n.desc == desc);
        }

        public static void SetCameraInfo(this Transform tf, string desc)
        {
            tf.GetComponent<CameraInfo>().Set(desc);
        }
    }
}