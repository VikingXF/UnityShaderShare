using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class AnchoredPositionExtension 
    {
        public static AnchoredPosition.Information GetAnchoredPositionInformation(this RectTransform tf, string desc)
        {
            return tf.GetComponent<AnchoredPosition>()._list.Find(n => n.desc == desc);
        }
        public static Vector3 GetAnchoredPosition(this RectTransform tf, string desc)
        {
            return GetAnchoredPositionInformation(tf, desc).anchoredPosition;
        }
        public static void SetAnchoredPosition(this RectTransform tf, string desc)
        {
            tf.GetComponent<AnchoredPosition>().Set(desc);
        }
    }
}
