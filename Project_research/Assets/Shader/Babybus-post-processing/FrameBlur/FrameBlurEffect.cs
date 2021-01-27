//=============================================
//作者:XF
//描述:保存单帧进行模糊，并赋予UI背景上
//创建时间:2021/01/25 13:57:30
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.UI;

public class FrameBlurEffect : MonoBehaviour
{
    #region Variables
    private string ShaderName = "Babybus/ScreenEffects/MaskBlurEffect";
    private Shader BlurShader;
    private Material material;

    //降采样次数
    [Range(1, 6), Tooltip("[降采样次数]向下采样的次数。此值越大,则采样间隔越大,需要处理的像素点越少,运行速度越快。")]
    public int DownSampleNum = 2;
    //模糊扩散度
    [Range(0.0f, 20.0f), Tooltip("[模糊扩散度]进行高斯模糊时，相邻像素点的间隔。此值越大相邻像素间隔越远，图像越模糊。但过大的值会导致失真。")]
    public float BlurSpreadSize = 3.0f;
    //迭代次数
    [Range(1, 8), Tooltip("[迭代次数]此值越大,则模糊操作的迭代次数越多，模糊效果越好，但消耗越大。")]
    public int BlurIterations = 1;

    private RenderTexture destRT;
    private RenderTexture sourceRT;
    public bool FrameBool = false;
    public Camera BlurCamera;

    #endregion

    void Start()
    {
        //找到当前的Shader文件
        BlurShader = Shader.Find(ShaderName);
        material = new Material(BlurShader);

    }
    void Update()
    {
        if (FrameBool == true)
        {
            SetRenderTextureBlur();
            FrameBool = false;
        }
    }

    public void SetRenderTextureBlur()
    {
        sourceRT = new RenderTexture((int)Screen.width, (int)Screen.height, 24);
        destRT = new RenderTexture((int)Screen.width/ DownSampleNum, (int)Screen.height/ DownSampleNum, 16);
        // 临时设置相关相机的targetTexture为rt, 并手动渲染相关相机
        BlurCamera.targetTexture = sourceRT;
        BlurCamera.Render();

        //RT模糊
        OnRenderTexBlur(sourceRT);
        this.GetComponent<Image>().material.mainTexture = destRT;

        BlurCamera.targetTexture = null;
        BlurCamera.gameObject.SetActive(false);
    }

    //对RT进行模糊
    public RenderTexture OnRenderTexBlur(RenderTexture sourceRT)
    {
        if (material != null)
        {
            int rtW = sourceRT.width >> DownSampleNum;
            int rtH = sourceRT.height >> DownSampleNum;

            RenderTexture renderBuffer = RenderTexture.GetTemporary(rtW, rtH, 0, sourceRT.format);
            renderBuffer.filterMode = FilterMode.Bilinear;

            Graphics.Blit(sourceRT, renderBuffer);
            for (int i = 0; i < BlurIterations; i++)
            {
                //根据向下采样的次数确定宽度系数。用于控制降采样后相邻像素的间隔
                float widthMod = 1.0f / (1.0f * (1 << DownSampleNum));

                material.SetFloat("_BlurSize", i + BlurSpreadSize * widthMod);
                RenderTexture tempBuffer = RenderTexture.GetTemporary(rtW, rtH, 0);

                //垂直方向模糊
                Graphics.Blit(renderBuffer, tempBuffer, material, 0);
                RenderTexture.ReleaseTemporary(renderBuffer);
                renderBuffer = tempBuffer;
                tempBuffer = RenderTexture.GetTemporary(rtW, rtH, 0);

                //水平方向模糊
                Graphics.Blit(renderBuffer, tempBuffer, material, 1);
                RenderTexture.ReleaseTemporary(renderBuffer);
                renderBuffer = tempBuffer;
            }
            Graphics.Blit(renderBuffer, destRT);

            //清空renderBuffer
            RenderTexture.ReleaseTemporary(renderBuffer);

        }
        return destRT;
    }

   
}
