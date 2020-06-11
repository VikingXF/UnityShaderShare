using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class JBoxColliderExtension
    {
        public static JBoxCollider.Information GetBoxColliderInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<JBoxCollider>()._list.Find(n => n.desc == desc);
        }
        public static void SetBoxCollider(this Transform tf, string desc)
        {
            tf.GetComponent<JBoxCollider>().Set(desc);
        }
    }
}
