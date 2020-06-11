//=============================================
//作者:
//描述:
//创建时间:2020/06/10 16:41:19
//版本:v 1.0
//=============================================
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using System.Collections;
using System.Text;
using UnityEngine.Profiling;

namespace Babybus.UtilityTools
{
    public class ProfilerManager : MonoBehaviour
    {
        Rect window0 = new Rect(200, 0, 160, 60);
        Rect _rect = new Rect(0, 0, 160, 60);
        private int nbDecimal = 1; // How many decimal do you want to display
        private float accum = 0f; // FPS accumulated over the interval
        private int frames = 0; // Frames drawn over the interval
        private string sFPS = ""; // The fps formatted into a string.
        private static ProfilerManager _instance = null;

        public static void Show()
        {
            if (_instance == null && Utility.IsDebugBuild)
            {
                GameObject obj = new GameObject("[ProfilerManager]");
                obj.AddComponent<ProfilerManager>();
                DontDestroyOnLoad(obj);
            }
        }

        private void Awake()
        {
            _instance = this;
        }

        private void Start()
        {
#if UNITY_EDITOR
            window0.height = 180;
            _rect.height = 180;
#endif
            StartCoroutine(FPS());
        }

        void Update()
        {
            accum += Time.timeScale / Time.deltaTime;
            ++frames;
        }

        IEnumerator FPS()
        {
            while (true)
            {
                float fps = accum / frames;
                sFPS = fps.ToString("f" + Mathf.Clamp(nbDecimal, 0, 10));
                accum = 0.0F;
                frames = 0;
                yield return Yielders.GetWaitForSeconds(0.2f);
            }
        }

        private readonly StringBuilder _sUserMemory = new StringBuilder();

        private void OnGUI()
        {
            _sUserMemory.Remove(0,_sUserMemory.Length);//清空
            _sUserMemory.Append("AllMemory:" + Profiler.GetTotalAllocatedMemoryLong() / 1000000 + "M" + "\n");
            _sUserMemory.Append("MonoUsed:" + Profiler.GetMonoUsedSizeLong() / 1000000 + "M" + "\n");
            _sUserMemory.Append("FPS:" + sFPS + "\n");
#if UNITY_EDITOR
            _sUserMemory.Append("DrawCall:" + UnityStats.drawCalls + "\n");
            _sUserMemory.Append("Batch:" + UnityStats.batches + "\n");
            _sUserMemory.Append("Static Batch DC: " + UnityStats.staticBatchedDrawCalls + "\n");
            _sUserMemory.Append("Static Batch: " + UnityStats.staticBatches + "\n");
            _sUserMemory.Append("DynamicBatch DC: " + UnityStats.dynamicBatchedDrawCalls + "\n");
            _sUserMemory.Append("DynamicBatch: " + UnityStats.dynamicBatches + "\n");
            _sUserMemory.Append("Tri:" + UnityStats.triangles + "\n");
            _sUserMemory.Append("Ver:" + UnityStats.vertices);
#endif
            window0 = GUI.Window(0, window0, Setwindow, "");
        }

        void Setwindow(int windowID)
        {
            GUI.skin.label.fontSize = 15;
            GUI.skin.label.normal.textColor = Color.white;
            GUI.skin.label.alignment = TextAnchor.UpperCenter;
            GUI.DragWindow();
            GUI.Label(_rect, _sUserMemory.ToString());
        }
    }
}
