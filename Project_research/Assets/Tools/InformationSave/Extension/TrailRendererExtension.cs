using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class TrailRendererExtension
    {
        public static TrailRendererInfo.Information GetTrailRendererInformation(this Transform tf, string desc)
        {
            return tf.GetComponent<TrailRendererInfo>()._list.Find(n => n.desc == desc);
        }
    }
}