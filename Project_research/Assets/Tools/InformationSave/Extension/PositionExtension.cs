using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class PositionExtension
    {
        public static Position.Information GetPositionInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<Position>()._list.Find(n => n.desc == desc);
        }
        public static Vector3 GetPosition(this Transform tf, string desc)
        {
            return GetPositionInformation(tf, desc).position;
        }
        public static void SetPosition(this Transform tf, string desc)
        {
            tf.GetComponent<Position>().Set(desc);
        }
    }
}
