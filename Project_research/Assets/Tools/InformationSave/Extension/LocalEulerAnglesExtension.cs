using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class LocalEulerAnglesExtension
    {
        public static LocalEulerAngles.Information GetLocalEulerAnglesInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<LocalEulerAngles>()._list.Find(n => n.desc == desc);
        }
        public static Vector3 GetLocalEulerAngles(this Transform tf, string desc)
        {
            return GetLocalEulerAnglesInformation(tf, desc).localEulerAngles;
        }
        public static void SetLocalEulerAngles(this Transform tf, string desc)
        {
            tf.GetComponent<LocalEulerAngles>().Set(desc);
        }
    }
}
