using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class ScaleExtension
    {
        public static Scale.Information GetScaleInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<Scale>()._list.Find(n => n.desc == desc);
        }
        public static Vector3 GetScale(this Transform tf, string desc)
        {
            return GetScaleInformation(tf, desc).scale;
        }
        public static void SetScale(this Transform tf, string desc)
        {
            tf.GetComponent<Scale>().Set(desc);
        }
    }
}
