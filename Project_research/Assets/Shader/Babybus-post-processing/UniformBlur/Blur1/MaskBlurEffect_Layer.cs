//=======================================================
// 作者：xuefei
// 描述：选择Layer层进行模糊，模糊层可以使用Mask贴图控制模糊区域
//=======================================================

using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
//[AddComponentMenu("Screen Effects/MaskBlurEffect_Layer")]
public class MaskBlurEffect_Layer : MonoBehaviour
{
    #region Variables
    private string ShaderName = "Babybus/Screen Effects/MaskBlurEffect3";
    public Shader BlurShader;
    private Material BlurMaterial;

    public static int ChangeValue;
    public static float ChangeValue2;
    public static int ChangeValue3;

    public LayerMask selectiveRenderLayer = -1;

    //降采样次数
    [Range(0, 6), Tooltip("[降采样次数]向下采样的次数。此值越大,则采样间隔越大,需要处理的像素点越少,运行速度越快。")]
    public int DownSampleNum = 1;
    //模糊扩散度
    [Range(0.0f, 20.0f), Tooltip("[模糊扩散度]进行高斯模糊时，相邻像素点的间隔。此值越大相邻像素间隔越远，图像越模糊。但过大的值会导致失真。")]
    public float BlurSpreadSize = 1.0f;
    //迭代次数
    [Range(0, 8), Tooltip("[迭代次数]此值越大,则模糊操作的迭代次数越多，模糊效果越好，但消耗越大。")]
    public int BlurIterations = 1;

    public bool isMask = false;

    //迭代次数
    [Tooltip("[Mask贴图控制模糊区域，贴图为黑白纹理，黑色像素为模糊区域，白色为不模糊区域。")]
    public Texture2D MaskTex;

    //材质获取跟设置
    Material material
    {
        get
        {
            if (BlurMaterial == null)
            {
                BlurMaterial = new Material(BlurShader);
                BlurMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return BlurMaterial;
        }
    }

    #endregion


    void Start()
    {
        //依次赋值
        ChangeValue = DownSampleNum;
        ChangeValue2 = BlurSpreadSize;
        ChangeValue3 = BlurIterations;

        //找到当前的Shader文件
        BlurShader = Shader.Find(ShaderName);

        //判断当前设备是否支持屏幕特效
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
    }
    void Update()
    {
        //若程序在运行，进行赋值
        if (Application.isPlaying)
        {
            //赋值
            DownSampleNum = ChangeValue;
            BlurSpreadSize = ChangeValue2;
            BlurIterations = ChangeValue3;
        }
        //若程序没有在运行，去寻找对应的Shader文件
#if UNITY_EDITOR
        if (Application.isPlaying != true)
        {
            BlurShader = Shader.Find(ShaderName);
        }
#endif

    }
    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (BlurShader !=null)
        {
            int rtW = sourceTexture.width >> DownSampleNum;
            int rtH = sourceTexture.height >> DownSampleNum;

            RenderTexture renderBuffer = RenderTexture.GetTemporary(rtW, rtH, 0, sourceTexture.format);
            renderBuffer.filterMode = FilterMode.Bilinear;

            Graphics.Blit(sourceTexture, renderBuffer);
            for (int i = 0; i < BlurIterations; i++)
            {
                //根据向下采样的次数确定宽度系数。用于控制降采样后相邻像素的间隔
                float widthMod = 1.0f / (1.0f * (1 << DownSampleNum));

                material.SetFloat("_BlurSize", i + BlurSpreadSize* widthMod);
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

            if (isMask)
            {
                material.SetTexture("_MaskTex", MaskTex);
                material.SetTexture("_BlurTex", renderBuffer);
                Graphics.Blit(sourceTexture, destTexture, material, 2);
            }
            else
            {
                Graphics.Blit(renderBuffer, destTexture);
            }
                
           
            //清空renderBuffer
            RenderTexture.ReleaseTemporary(renderBuffer);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }


    void OnValidate()
    {
        //将编辑器中的值赋值回来，确保在编辑器中值的改变立刻让结果生效
        ChangeValue = DownSampleNum;
        ChangeValue2 = BlurSpreadSize;
        ChangeValue3 = BlurIterations;
    }

    void OnDisable()
    {
        if (BlurMaterial)
        {
            //立即销毁材质实例
            DestroyImmediate(BlurMaterial);
        }

    }

}