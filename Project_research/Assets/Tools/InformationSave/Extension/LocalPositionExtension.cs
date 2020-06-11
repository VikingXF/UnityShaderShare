using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class LocalPositionExtension
    {
        public static LocalPosition.Information GetLocalPositionInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<LocalPosition>()._list.Find(n => n.desc == desc);
        }
        public static Vector3 GetLocalPosition(this Transform tf, string desc)
        {
            return GetLocalPositionInformation(tf, desc).localPosition;
        }
        public static void SetLocalPosition(this Transform tf, string desc)
        {
            tf.GetComponent<LocalPosition>().Set(desc);
        }
    }
}
