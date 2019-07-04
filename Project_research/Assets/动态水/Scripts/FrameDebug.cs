using UnityEngine;
using System.Collections;

public class FrameDebug : MonoBehaviour
{
    // 将它附加到任何对象上，以生成帧/秒查看器.
    //
    // 它在每个updateInterval上计算帧/秒,
    // 所以显示不会保持大的变化.
    //
    // 它在非常低的FPS计数(<10)下也相当准确.
    // 我们不是通过简单地计算每个间隔的帧数来做到这一点，而是
    // 通过为每帧累积FPS。这样我们就得到了
    // corstartRect整体FPS，即使间隔呈现类似的内容
    // 5.5帧.

    public Rect startRect = new Rect(25 + 85, 25, 85, 40); // FPS窗口的初始显示位置.
    public bool updateColor = true; // 但FPS降低时候判断是否颜色变化
    public bool allowDrag = false; // 是否允许拖动FPS窗口
    public float frequency = 0.5F; // FPS更新频率
    public int nbDecimal = 1; // FPS显示小数位数

    private float accum; // FPS 在此期间不断累积
    private int frames; // Frames 在此期间绘制
    private Color color = Color.white; // GUI的颜色，取决于FPS ( R < 10, Y < 30, G >= 30 )
    private string sFPS = ""; // 格式化为字符串的fps。.
    private GUIStyle style; // 文本样式.基于defaultSkin.label.
    private Rect realRect;

    private void Start()
    {
        StartCoroutine(FPS());
    }

    private void Update()
    {
        realRect = startRect;
        realRect.x = Screen.width - startRect.x;

        accum += Time.timeScale / Time.deltaTime;
        ++frames;
    }

    private IEnumerator FPS()
    {      
        // 无限循环在所有 "frenquency"时间
        while (true)
        {
            // Update the FPS
            float fps = accum / frames;
            sFPS = fps.ToString("f" + Mathf.Clamp(nbDecimal, 0, 10));

            //Update the color
            color = (fps >= 30) ? Color.green : ((fps > 10) ? Color.red : Color.yellow);

            accum = 0.0F;
            frames = 0;

            yield return new WaitForSeconds(frequency);
        }
    }

    private void OnGUI()
    {
        // Copy the default label skin, change the color and the alignement
        if (style == null)
        {
            style = new GUIStyle(GUI.skin.label);
            style.normal.textColor = Color.white;
            style.alignment = TextAnchor.MiddleCenter;
        }

        GUI.color = updateColor ? color : Color.white;
        realRect = GUI.Window(0, realRect, DoMyWindow, "");
    }

    private void DoMyWindow(int windowID)
    {
        GUI.Label(new Rect(0, 0, realRect.width, realRect.height), sFPS + " FPS", style);
        if (allowDrag)
        {
            GUI.DragWindow(new Rect(0, 0, Screen.width, Screen.height));
        }
    }
}
