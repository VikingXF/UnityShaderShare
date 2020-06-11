using UnityEngine;

namespace Babybus.UtilityTools
{
    public static class LocalTransformInfoExtension
    {
        public static LocalTransformInfo.Information GetLocalTransformInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<LocalTransformInfo>()._list.Find(n => n.desc == desc);
        }

        public static void SetLocalTransformInfo(this Transform tf, string desc)
        {
            tf.GetComponent<LocalTransformInfo>().Set(desc);
        }
    }
}
