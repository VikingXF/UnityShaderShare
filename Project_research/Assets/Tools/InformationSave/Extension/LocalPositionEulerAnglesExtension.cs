using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class LocalPositionEulerAnglesExtension
    {
        public static LocalPositionEulerAngles.Information GetLocalPositionEulerAnglesInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<LocalPositionEulerAngles>()._list.Find(n => n.desc == desc);
        }

        public static void SetLocalPositionEulerAngles(this Transform tf, string desc)
        {
            tf.GetComponent<LocalPositionEulerAngles>().Set(desc);
        }
    }
}
