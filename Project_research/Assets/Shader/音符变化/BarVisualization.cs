//=======================================================
// 作者：xuefei
// 描述：
//=======================================================
using UnityEngine;
using System.Collections;
using UnityEngine.UI;

[RequireComponent(typeof(AudioSource))]
public class BarVisualization : MonoBehaviour
{
    public float speed = 0.2f;
    public AudioClip[] clips;
    //public SpriteRenderer[] barsSprites;
    public Material[] materials;
    public Slider musicSlider;
    [Range(0, 1)]
    public float colorMultiplter = 1;
    [Range(0, 1)]
    public float s = 1;
    [Range(0, 1)]
    public float v = 1;
    private int index = 0;
    private float musicLength;
    private AudioSource audio;
    private float k = 0;
    private void Start()
    {
        audio = GetComponent<AudioSource>();
    }
    private void Update()
    {

        if (k >= speed)
        {
            Visulization();
            k = 0;
        }
        k += Time.deltaTime;

        if (Input.GetMouseButtonDown(0))
        {
            ChangeSound();
        }
        MusicSlider();
    }
    void Visulization()
    {
        float[] musicData = new float[64];
        audio.GetSpectrumData(musicData, 0, FFTWindow.Triangle);
        //float[] musicData = audio.GetSpectrumData(64, 0, FFTWindow.Triangle);
        int i = 0;
        //while (i < barsSprites.Length)
        //{
        //    barsSprites[i].transform.localScale = new Vector3(musicData[i]*20f, 0.2f, 7);
        //    barsSprites[i].color = HSVtoRGB(musicData[i] * colorMultiplter, s, v, 1);
        //    i++;
        //}

        //Debug.Log(musicData[i]);

        while (i < materials.Length)
        {
            //if (musicData[i] * 10f < 0.5f)
            //{
            //    materials[i].SetFloat("_Amount", 0f);
            //}
            //if (musicData[i] * 10f >= 0.5f && musicData[i] * 10f < 0.15f)
            //{
            //    materials[i].SetFloat("_Amount", 0.11f);
            //}
            //if (musicData[i] * 10f>=0.15f && musicData[i] * 10f < 0.25f)
            //{
            //    materials[i].SetFloat("_Amount", 0.22f);
            //}
            //if (musicData[i] * 10f >= 0.25f && musicData[i] * 10f < 0.35f)
            //{
            //    materials[i].SetFloat("_Amount", 0.33f);
            //}
            //if (musicData[i] * 10f >= 0.35f && musicData[i] * 10f < 0.45f)
            //{
            //    materials[i].SetFloat("_Amount", 0.44f);
            //}
            //if (musicData[i] * 10f >= 0.45f && musicData[i] * 10f < 0.55f)
            //{
            //    materials[i].SetFloat("_Amount", 0.55f);
            //}
            //if (musicData[i] * 10f >= 0.55f && musicData[i] * 10f < 0.65f)
            //{
            //    materials[i].SetFloat("_Amount", 0.66f);
            //}
            //if (musicData[i] * 10f >= 0.65f && musicData[i] * 10f < 0.75f)
            //{
            //    materials[i].SetFloat("_Amount", 0.77f);
            //}
            //if (musicData[i] * 10f >= 0.75f && musicData[i] * 10f < 0.85f)
            //{
            //    materials[i].SetFloat("_Amount", 0.88f);
            //}
            //if (musicData[i] * 10f >= 0.85f )
            //{
            //    materials[i].SetFloat("_Amount", 0.99f);
            //}

            materials[i].SetFloat("_Amount", musicData[i] * 10f);
            i++;
        }

    }
    void ChangeSound()
    {
        index++;
        if (index > clips.Length - 1)
        {
            index = 0;
        }
        print(index);
        audio.clip = clips[index];
        audio.Play();
        
    }
    void MusicSlider()
    {
        musicLength = audio.time;
        //Debug.Log(musicLength);
        musicSlider.value = musicLength / audio.clip.length;
    }
    public static Color HSVtoRGB(float hue, float saturation, float value, float alpha)
    {
        while (hue >1f)
        {
            hue -= 1f;
        }
        while (hue < 0f)
        {
            hue += 1f;
        }
        while (saturation > 1f)
        {
            saturation -= 1f;
        }
        while (saturation < 0f)
        {
            saturation += 1f;
        }
        while (value > 1f)
        {
            value -= 1f;
        }
        while (value < 0f)
        {
            value += 1f;
        }
        if (hue > 0.999f)
        {
            hue = 0.999f;
        }
        if (hue<0.001f)
        {
            hue = 0.001f;
        }
        if (saturation > 0.999f)
        {
            saturation = 0.999f;
        }
        if (saturation < 0.001f)
        {
            return new Color(value * 255f, value * 255f, value * 255f);
        }
        if (value > 0.999f)
        {
            value = 0.999f;
        }
        if (value < 0.001f)
        {
            value = 0.001f;
        }
        float h6 = hue * 6f;
        if (h6 ==6f)
        {
            h6 = 0f;
        }
        int ihue = (int)h6;
        float p = value * (1f - saturation);
        float q = value * (1f - (saturation * (h6 - (float)ihue)));
        float t = value * (1f - (saturation * (1f-(h6 - (float)ihue))));
        switch (ihue)
        {
            case 0:
                return new Color(value,t,p,alpha);
            case 1:
                return new Color(q, value, p, alpha);
            case 2:
                return new Color(p, value, t,  alpha);
            case 3:
                return new Color(p, q, value, alpha);
            case 4:
                return new Color(t, p, value, alpha);

            default:
                return new Color(value, p, q, alpha);
        }
    }
}
