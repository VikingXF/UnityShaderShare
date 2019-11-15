//=======================================================
// 作者：xuefei
// 描述：描边
//=======================================================
using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class OutlineSYS : MonoBehaviour
{
    [Header("Outline设置")]
    [Tooltip("轮廓为实边或者淡出")]
    public bool solidOutline = false;

    [Tooltip("选择layer层显示描边")]
    public LayerMask outlineLayer;

    public Camera mainCamera;

    public Material blurMaterial;
    public Material outlineMaterial;

    [Tooltip("描边颜色")]
    public Color outlineColor;

    [Tooltip("叠加覆盖倍数")]
    [Range(0, 10)]
    public float outlineStrength = 1f;

    [Tooltip("降采样次数")]
    [Range(0, 4)]
    public int downsampleAmount = 2;

    [Tooltip("描边大小")]
    [Range(0.0f, 10.0f)]
    public float outlineSize = 1.5f;

    [Tooltip("模糊执行次数")]
    [Range(1, 10)]
    public int outlineIterations = 1;


    [Tooltip("描边贴图Upscaling")]
    [Range(0.1f, 5)]
    public float outlineUpscale = 1f;

    [Space(10)]
    [Header("Component References - Do not change")]
    private RenderTexture renTexInput;
    private RenderTexture renTexRecolor;
    private RenderTexture renTexDownsample;
    private RenderTexture renTexBlur;
    private RenderTexture renTexOut;

    //用于检查屏幕大小是否更改
    private Vector2 prevSize;

    void Awake()
    {
        if (mainCamera == null)
        {
            mainCamera = Camera.main;
        }
        UpdateRenderTextureSizes();
    }

    void UpdateRenderTextureSizes()
    {
        Vector2 screenDims = ScreenDimension();
        int x = Mathf.FloorToInt(Mathf.FloorToInt(screenDims.x) * outlineUpscale);
        int y = Mathf.FloorToInt(Mathf.FloorToInt(screenDims.y) * outlineUpscale);
        renTexInput = new RenderTexture(x, y, 1);
        renTexDownsample = new RenderTexture(x, y, 1);
        renTexRecolor = new RenderTexture(x, y, 1);
        renTexOut = new RenderTexture(x, y, 1);
        renTexBlur = new RenderTexture(x, y, 1);
    }

    public Vector2 ScreenDimension()
    {
        Vector2 size = Vector2.one;
        size = new Vector2(Screen.width, Screen.height);
        return size;
    }

    //void RunCalcs()
    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {

        outlineMaterial.SetColor("_OutlineCol", outlineColor);
        outlineMaterial.SetFloat("_GradientStrengthModifier", outlineStrength);

        RenderTexture prevRenTex = mainCamera.targetTexture;
        int prevCullGroup = mainCamera.cullingMask;
        CameraClearFlags prevClearFlags = mainCamera.clearFlags;
        Color prevColor = mainCamera.backgroundColor;

        mainCamera.cullingMask = outlineLayer.value;
        mainCamera.targetTexture = renTexInput;
        mainCamera.clearFlags = CameraClearFlags.SolidColor;
        mainCamera.backgroundColor = new Color(1f, 0f, 1f, 1f);

        mainCamera.Render();

        mainCamera.backgroundColor = prevColor;
        mainCamera.clearFlags = prevClearFlags;
        mainCamera.targetTexture = prevRenTex;
        mainCamera.cullingMask = prevCullGroup;


        float widthMod = 1.0f / (1.0f * (1 << downsampleAmount));
        blurMaterial.SetVector("_Parameter", new Vector4(outlineSize * widthMod, -outlineSize * widthMod, 0.0f, 0.0f));

        Graphics.Blit(sourceTexture, renTexInput);
        Graphics.Blit(renTexInput, renTexRecolor, outlineMaterial, 0);
        Graphics.Blit(renTexRecolor, renTexDownsample, blurMaterial, 0);

        for (int i = 0; i < outlineIterations; i++)
        {
            float iterationOffs = (i * 1.0f);
            blurMaterial.SetVector("_Parameter", new Vector4(outlineSize * widthMod + iterationOffs, -outlineSize * widthMod - iterationOffs, 0.0f, 0.0f));

            Graphics.Blit(renTexDownsample, renTexBlur, blurMaterial, 1);
            Graphics.Blit(renTexBlur, renTexDownsample, blurMaterial, 2);
        }
        outlineMaterial.SetFloat("_Solid", solidOutline ? 1f : 0f);
        outlineMaterial.SetTexture("_BlurTex", renTexDownsample);        
        Graphics.Blit(renTexRecolor, destTexture, outlineMaterial, 1);
        //Graphics.Blit(renTexRecolor, renTexOut, outlineMaterial, 1);
    }

    void LateUpdate()
    {
        Vector2 currentSize = new Vector2(Screen.width, Screen.height);
        if (prevSize != currentSize)
        {
            UpdateRenderTextureSizes();
        }
        prevSize = currentSize;
       // RunCalcs();
    }
}

