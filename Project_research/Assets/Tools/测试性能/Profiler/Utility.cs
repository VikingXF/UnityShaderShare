using UnityEngine;
using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine.EventSystems;
#if UNITY_EDITOR
using UnityEditor;
#endif
#pragma warning disable 618
namespace Babybus.UtilityTools
{
    public static class Utility
    {
        public static bool IsDebugBuild
        {
            get
            {
                bool isDebugBuild;
#if UNITY_EDITOR
                isDebugBuild = EditorUserBuildSettings.development;
#else
                isDebugBuild = Debug.isDebugBuild;
#endif
                return isDebugBuild;
            }
        }

        /// <summary>
        /// 设置光照图
        /// </summary>
        /// <param name="texture2D"></param>
        public static void SetLightMap(Texture2D texture2D)
        {
            var lightmapData = LightmapSettings.lightmaps;
            LightmapData lightmap;
            for (var i = 0; i < lightmapData.Length; i++)
            {
                lightmap = new LightmapData();
                lightmap.lightmapColor = texture2D;
                lightmapData[i] = lightmap;
            }

            LightmapSettings.lightmaps = lightmapData;
        }

        /// <summary>
        /// 返回随机枚举
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="start">开始</param>
        /// <param name="end">从后第几开始</param>
        /// <returns></returns>
        public static T RandomEnum<T>(int start = 0, int end = 0)
        {
            T[] enums = Enum.GetValues(typeof(T)) as T[];
            var random = new System.Random();
            var en = enums[random.Next(start, enums.Length - end)];
            return en;
        }

        /// <summary>
        /// 根据屏幕坐标设置UI坐标
        /// </summary>
        /// <param name="screenPosition">世界坐标转屏幕坐标或者鼠标坐标</param>
        /// <param name="rectTransform"></param>
        /// <param name="uiCamera"></param>
        public static void SetUIPosition(Vector2 screenPosition, RectTransform rectTransform, Camera uiCamera)
        {
            rectTransform.position = GetUIPosition(screenPosition, rectTransform, uiCamera);
        }

        /// <summary>
        /// UI根据屏幕坐标获取对应位置
        /// </summary>
        /// <param name="screenPosition">屏幕坐标</param>
        /// <param name="rectTransform"></param>
        /// <param name="uiCamera"></param>
        /// <returns></returns>
        public static Vector3 GetUIPosition(Vector2 screenPosition, RectTransform rectTransform, Camera uiCamera)
        {
            Vector3 followPosition;
            RectTransformUtility.ScreenPointToWorldPointInRectangle(rectTransform, screenPosition, uiCamera,
                out followPosition);
            return followPosition;
        }

        /// <summary>
        /// 获取UI位置-用于3D物体飞UI位置
        /// </summary>
        /// <param name="worldCamera">世界相机</param>
        /// <param name="worldObject">世界物体</param>
        /// <param name="uiCamera">UI相机</param>
        /// <param name="uiObject">UI物体</param>
        /// <returns></returns>
        public static Vector3 GetFlyToUIPosition(Camera worldCamera, GameObject worldObject, Camera uiCamera,
            GameObject uiObject)
        {
            Vector3 worldObjectScreenPosition = worldCamera.WorldToScreenPoint(worldObject.transform.position);
            Vector3 uiObjectScreenPosition = uiCamera.WorldToScreenPoint(uiObject.transform.position);
            uiObjectScreenPosition.z = worldObjectScreenPosition.z;
            return worldCamera.ScreenToWorldPoint(uiObjectScreenPosition);
        }

        /// <summary>
        /// 权重随机
        /// </summary>
        /// <param name="weights"></param>
        /// <returns>索引</returns>
        public static int RandomByWeight(int[] weights)
        {
            var sum = weights.Sum();
            var numberRand = UnityEngine.Random.Range(1, sum + 1);
            var sumTemp = 0;
            for (var i = 0; i < weights.Length; i++)
            {
                sumTemp += weights[i];
                if (numberRand <= sumTemp)
                {
                    return i;
                }
            }

            //全是0则随机返回一个
            return UnityEngine.Random.Range(0, weights.Length);
        }

        /// <summary>
        /// 权重随机
        /// </summary>
        /// <param name="weights"></param>
        /// <returns>索引</returns>
        public static int RandomByWeight(List<int> weights)
        {
            int[] w = weights.ToArray();
            return RandomByWeight(w);
        }
        
        /// <summary>
        /// 相机中是否可见
        /// </summary>
        /// <param name="bounds">获取GetComponent-Renderer-().bounds</param>
        /// <param name="camera"></param>
        /// <returns></returns>
        public static bool IsVisible(Bounds bounds, Camera camera)
        {
            Plane[] planes = GeometryUtility.CalculateFrustumPlanes(camera);
            return GeometryUtility.TestPlanesAABB(planes, bounds);
        }

        /// <summary>
        /// 去除指定项随机
        /// </summary>
        /// <param name="list"></param>
        /// <param name="exclude"></param>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static T Range<T>(T[] list, params T[] exclude)
        {
            T result = default(T);

            if (exclude != null)
            {
                list = list.Except(new List<T>(exclude)).ToArray();
            }

            result = list[UnityEngine.Random.Range(0, list.Length)];

            return result;
        }

        public static T Range<T>(List<T> list, params T[] exclude)
        {
            T result = default(T);

            if (exclude != null)
            {
                list = list.Except(new List<T>(exclude)).ToList();
            }

            result = list[UnityEngine.Random.Range(0, list.Count)];

            return result;
        }


        /// <summary>
        /// 随机从枚举中取出指定数量
        /// </summary>
        /// <param name="list"></param>
        /// <param name="count"></param>
        /// <param name="exclude"></param>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static T[] MultiRange<T>(T[] list, int count, params T[] exclude)
        {
            List<T> values = new List<T>(list);
            if (exclude != null)
            {
                values = values.Except(exclude.ToList()).ToList();
            }

            if (values.Count <= count)
                return values.ToArray();

            List<T> result = new List<T>();

            for (int i = 0; i < count; i++)
            {
                T value = values[UnityEngine.Random.Range(0, values.Count)];
                result.Add(value);
                values.Remove(value);
            }

            return result.ToArray();
        }

        public static int Range(int min, int max, params int[] exclude)
        {
            int result = 0;

            while (true)
            {
                bool valid = true;

                result = UnityEngine.Random.Range(min, max + 1);
                for (int i = 0; i < exclude.Length; i++)
                {
                    if (result == exclude[i])
                    {
                        valid = false;
                        break;
                    }
                }

                if (valid || min == max)
                    break;
            }

            return result;
        }

        public static T[] MultiRange<T>(List<T> list, int count, params T[] exclude)
        {
            List<T> values = new List<T>(list);
            if (exclude != null)
            {
                values = values.Except(exclude.ToList()).ToList();
            }

            if (values.Count <= count)
                return values.ToArray();

            List<T> result = new List<T>();

            for (int i = 0; i < count; i++)
            {
                T value = values[UnityEngine.Random.Range(0, values.Count)];
                result.Add(value);
                values.Remove(value);
            }

            return result.ToArray();
        }

        public static T Max<T>(T x, T y)
        {
            return (Comparer<T>.Default.Compare(x, y) > 0) ? x : y;
        }

        public static T Max<T>(params T[] values)
        {
            T result = values[0];
            for (int i = 0; i < values.Length; i++)
            {
                result = Max(result, values[i]);
            }

            return result;
        }

        /// <summary>
        /// 乱序
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        public static void OutOfOrder<T>(List<T> list)
        {
            if (list == null)
                return;

            for (int i = 0; i < list.Count; i++)
            {
                int value = UnityEngine.Random.Range(0, i + 1);
                T t = list[i];
                list[i] = list[value];
                list[value] = t;
            }
        }

        /// <summary>
        /// 偏移设置
        /// </summary>
        /// <param name="rectTransform"></param>
        /// <param name="left"></param>
        /// <param name="top"></param>
        /// <param name="right"></param>
        /// <param name="bottom"></param>
        public static void SetOffset(this RectTransform rectTransform, float left = 0, float top = 0, float right = 0,
            float bottom = 0)
        {
            rectTransform.offsetMin = new Vector2(left, bottom);
            rectTransform.offsetMax = new Vector2(right, top);
        }

        /// <summary>
        /// 是否点到了UI
        /// </summary>
        /// <returns></returns>
        public static bool IsPointerOverUIObject()
        {
            PointerEventData eventDataCurrentPosition = new PointerEventData(EventSystem.current)
                {position = Input.mousePosition};
            List<RaycastResult> results = new List<RaycastResult>();
            EventSystem.current.RaycastAll(eventDataCurrentPosition, results);
            return results.Count > 0;
        }

        /// <summary>
        /// 调整音频源文件音量
        /// </summary>
        /// <param name="audioSamples"></param>
        /// <param name="volume"></param>
        /// <returns></returns>
        public static byte[] AdjustVolume(byte[] audioSamples, float volume)
        {
            byte[] array = new byte[audioSamples.Length];
            short maxvolume = 0;
            for (int i = 0; i < array.Length; i += 2)
            {
                // convert byte pair to int
                short buf1 = audioSamples[i + 1];
                short buf2 = audioSamples[i];

                buf1 = (short) ((buf1 & 0xff) << 8);
                buf2 = (short) (buf2 & 0xff);

                short res = (short) (buf1 | buf2);
                if (Mathf.Abs(res) > Mathf.Abs(maxvolume))
                {
                    maxvolume = res;
                }

                if (i > 43)
                    res = (short) (res * volume);

                // convert back
                array[i] = (byte) res;
                array[i + 1] = (byte) (res >> 8);
            }
            return array;
        }
    }
}
