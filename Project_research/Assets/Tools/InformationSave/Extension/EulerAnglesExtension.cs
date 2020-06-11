using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class EulerAnglesExtension
    {
        public static EulerAngles.Information GetEulerAnglesInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<EulerAngles>()._list.Find(n => n.desc == desc);
        }
        public static Vector3 GetEulerAngles(this Transform tf, string desc)
        {
            return GetEulerAnglesInformation(tf, desc).eulerAngles;
        }
        public static void SetEulerAngles(this Transform tf, string desc)
        {
            tf.GetComponent<EulerAngles>().Set(desc);
        }
    }
}
