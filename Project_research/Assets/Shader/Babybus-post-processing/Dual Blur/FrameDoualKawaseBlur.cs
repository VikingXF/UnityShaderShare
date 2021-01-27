//=============================================
//作者:
//描述:
//创建时间:2021/01/25 10:20:51
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.UI;
public class FrameDoualKawaseBlur : MonoBehaviour
{
    #region Variables
    private string ShaderName = "Babybus/ScreenEffects/MaskBlurEffect";
    private Shader BlurShader;
    //private Material BlurMaterial;
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

    //材质获取跟设置
    //Material material
    //{
    //    get
    //    {
    //        if (BlurMaterial == null)
    //        {
    //            BlurMaterial = new Material(BlurShader);
    //            BlurMaterial.hideFlags = HideFlags.HideAndDontSave;
    //        }
    //        return BlurMaterial;
    //    }
    //}
    private RenderTexture destRT;
    private RenderTexture sourceRT;
    public bool FrameBool = false;
    public Camera BlurCamera;

    #endregion

    void Start()
    {
        //找到当前的Shader文件
        BlurShader = Shader.Find(ShaderName);
        Debug.Log(BlurShader);
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
        destRT = new RenderTexture((int)Screen.width / DownSampleNum, (int)Screen.height / DownSampleNum, 24);
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


    //RT转Texture2D
    private Texture2D RenderTextureToTexture2D(RenderTexture texture)
    {
        RenderTexture RT = RenderTexture.active;
        RenderTexture.active = texture;
        Texture2D texture2D = new Texture2D(texture.width, texture.height);
        texture2D.ReadPixels(new Rect(0, 0, texture2D.width, texture2D.height), 0, 0);
        return texture2D;
    }

    //将RenderTexture保存成一张png图片  
    public bool SaveRenderTextureToPNG(RenderTexture rt, string contents, string pngName)
    {
        RenderTexture prev = RenderTexture.active;
        RenderTexture.active = rt;
        Texture2D png = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, false);
        png.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
        byte[] bytes = png.EncodeToPNG();
        if (!Directory.Exists(contents))
            Directory.CreateDirectory(contents);
        FileStream file = File.Open(contents + "/" + pngName + ".png", FileMode.Create);
        BinaryWriter writer = new BinaryWriter(file);
        writer.Write(bytes);
        file.Close();
        Texture2D.DestroyImmediate(png);
        png = null;
        RenderTexture.active = prev;
        return true;

    }
}
