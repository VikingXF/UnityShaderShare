//=============================================
//作者:
//描述:径向模糊效果
//创建时间:2020/10/27 11:14:11
//版本:v 1.0
//=============================================

using UnityEngine;
public class RadialBlurEffect : PostEffectBase
{
    //模糊程度，不能过高
    [Range(0, 0.1f)]
    public float blurFactor = 0.03f;
    //清晰图像与原图插值
    [Range(0.0f, 2.0f)]
    public float lerpFactor = 1.5f;
    //迭代次数
    [Range(1, 8)]
    public int iteration = 3;
    //降低分辨率
    [Range(0, 8)]
    public int downSampleFactor = 2;
    //模糊中心（0-1）屏幕空间，默认为中心点
    public Vector2 blurCenter = new Vector2(0.5f, 0.5f);
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_Material)
        {
            //申请两块降低了分辨率的RT
            RenderTexture rt1 = RenderTexture.GetTemporary(source.width >> downSampleFactor, source.height >> downSampleFactor, 0, source.format);
            RenderTexture rt2 = RenderTexture.GetTemporary(source.width >> downSampleFactor, source.height >> downSampleFactor, 0, source.format);
            Graphics.Blit(source, rt1);
            //使用降低分辨率的rt进行模糊:pass0
            _Material.SetFloat("_BlurIteration", iteration);
            _Material.SetFloat("_BlurFactor", blurFactor);
            _Material.SetVector("_BlurCenter", blurCenter);
            Graphics.Blit(rt1, rt2, _Material, 0);
            //使用rt2和原始图像lerp:pass1
            _Material.SetTexture("_BlurTex", rt2);
            _Material.SetFloat("_LerpFactor", lerpFactor);
            Graphics.Blit(source, destination, _Material, 1);
            //释放RT
            RenderTexture.ReleaseTemporary(rt1);
            RenderTexture.ReleaseTemporary(rt2);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}