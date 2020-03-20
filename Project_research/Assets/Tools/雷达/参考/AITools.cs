using UnityEngine;
namespace Babybus.WZKTools
{
    public static class AITools
    {
        public static RaycastHit IsHit(this Transform tf, Quaternion eulerAnger, float length, int layer, float from, Color color)
        {
            RaycastHit hit = default(RaycastHit);
            Vector3 normalized = eulerAnger * tf.forward.normalized;
#if UNITY_EDITOR
            Debug.DrawRay(tf.position + normalized * from, normalized*length, color);
#endif
            Physics.Raycast(tf.position + normalized * from, normalized, out hit, length,layer);
            return hit;
        }
    }
    //一条向前的射线
    // transform.IsHit(Quaternion.identity, Length, -1, From, Color.green);

    //多一个精确度就多两条对称的射线,每条射线夹角是总角度除与精度
    //float subAngle = (Angle / 2) / Accurate;
    //for (int i = 0; i < Accurate; i++)
    //{
    //    transform.IsHit(Quaternion.Euler(0, -1 * subAngle * (i + 1), 0), Length, -1, From, Color.green);
    //    transform.IsHit(Quaternion.Euler(0, subAngle * (i + 1), 0), Length, -1, From, Color.green);
    //}
}

