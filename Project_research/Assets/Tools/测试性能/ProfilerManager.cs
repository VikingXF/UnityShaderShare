#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using System.Collections;
using UnityEngine.Profiling;
namespace Babybus.WZKTools
{
    public class ProfilerManager : MonoBehaviour
    {
        private string sUserMemory = "";
        Rect window0 = new Rect(200, 0, 160, 60);
        Rect _rect = new Rect(0, 0, 160, 60);
        public float frequency = 0.5F; // The update frequency of the fps
        public int nbDecimal = 1; // How many decimal do you want to display
        private float accum = 0f; // FPS accumulated over the interval
        private int frames = 0; // Frames drawn over the interval
        private string sFPS = ""; // The fps formatted into a string.
        private static ProfilerManager Instance = null;
        public static void Show()
        {
#if UNITY_EDITOR
            bool isDebugBuild = EditorUserBuildSettings.development;
#else
    bool isDebugBuild = Debug.isDebugBuild;
#endif
            if (Instance == null && isDebugBuild)
            {
                GameObject obj = new GameObject("ProfilerManager");
                obj.AddComponent<ProfilerManager>();
                DontDestroyOnLoad(obj);
            }
        }
        private void Start()
        {
            Instance = this;
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
                yield return new WaitForSeconds(frequency);
            }
        }
        private void OnGUI()
        {
            GUI.skin.label.fontSize = 15;
            GUI.skin.label.normal.textColor = Color.white;
            GUI.skin.label.alignment = TextAnchor.UpperCenter;
            sUserMemory = "";
            sUserMemory += "AllMemory:" + Profiler.GetTotalAllocatedMemoryLong() / 1000000 + "M" + "\n";
            sUserMemory += "MonoUsed:" + Profiler.GetMonoUsedSizeLong() / 1000000 + "M" + "\n";
            sUserMemory += "FPS:" + sFPS + "\n";
#if UNITY_EDITOR
            sUserMemory += "DrawCall:" + UnityStats.drawCalls + "\n";
            sUserMemory += "Batch:" + UnityStats.batches + "\n";
            sUserMemory += "Static Batch DC: " + UnityStats.staticBatchedDrawCalls + "\n"; ;
            sUserMemory += "Static Batch: " + UnityStats.staticBatches + "\n";
            sUserMemory += "DynamicBatch DC: " + UnityStats.dynamicBatchedDrawCalls + "\n";
            sUserMemory += "DynamicBatch: " + UnityStats.dynamicBatches + "\n";
            sUserMemory += "Tri:" + UnityStats.triangles + "\n";
            sUserMemory += "Ver:" + UnityStats.vertices;
#endif
            window0 = GUI.Window(0, window0, Setwindow, "");
        }
        void Setwindow(int windowID)
        {
            GUI.DragWindow();
            GUI.Label(_rect, sUserMemory);
        }
    }
}
