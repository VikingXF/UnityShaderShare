//=============================================
//作者:
//描述:
//创建时间:2020/06/10 16:44:13
//版本:v 1.0
//=============================================
#if UNITY_EDITOR
using UnityEngine;
using UnityEngine.UI;
namespace Babybus.UtilityTools
{
    public class DebugUILine : MonoBehaviour
    {
        static Vector3[] fourCorners = new Vector3[4];
        void OnDrawGizmos()
        {
            foreach (MaskableGraphic g in FindObjectsOfType<MaskableGraphic>())
            {
                if (g.raycastTarget)
                {
                    RectTransform rectTransform = g.transform as RectTransform;
                    rectTransform.GetWorldCorners(fourCorners);
                    Gizmos.color = Color.blue;
                    for (int i = 0; i < 4; i++)
                        Gizmos.DrawLine(fourCorners[i], fourCorners[(i + 1) % 4]);
                }
            }
        }
    }
}
#endif
