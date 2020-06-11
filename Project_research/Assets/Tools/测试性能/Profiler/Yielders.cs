//=======================================================
// 作者：王则昆
// 描述：减少GC
//=======================================================
using System.Collections.Generic;
using UnityEngine;
namespace Babybus.UtilityTools
{
    public static class Yielders
    {
        public static readonly WaitForEndOfFrame EndOfFrame = new WaitForEndOfFrame();
        public static readonly WaitForFixedUpdate FixedUpdate = new WaitForFixedUpdate();

        private static readonly Dictionary<float, WaitForSeconds> _waitForSecondsYielders = new Dictionary<float, WaitForSeconds>();

        public static WaitForSeconds GetWaitForSeconds(float seconds)
        {
            WaitForSeconds wfs;
            if (!_waitForSecondsYielders.TryGetValue(seconds, out wfs))
                _waitForSecondsYielders.Add(seconds, wfs = new WaitForSeconds(seconds));
            return wfs;
        }

        public static void ClearWaitForSeconds()
        {
            _waitForSecondsYielders.Clear();
        }
    }
}
