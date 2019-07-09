#if UNITY_EDITOR
//=======================================================
// 作者：xuefei
// 描述：保存序列帧1.0版本
//=======================================================
using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;

namespace xfScreenshot
{
    public class RenderSequenceFrame : MonoBehaviour
    {

        private IDataDispose _dataDispose = new XMLDataDispose();
        private string listpath = "Tools/屏幕录屏/Data/AnimationData.xml";

        // 动画的帧数
        private int frameRate = 25;                  // 导出帧率，设置Time.captureFramerate会忽略真实时间，直接使用此帧率
        private float frameCount = 100;              // 导出帧的数目，100帧则相当于导出5秒钟的光效时间。由于导出每一帧的时间很长，所以导出时间会远远长于直观的光效播放时间      
        private int screenWidth = 960;
        private int screenHeight = 640;
        private int scale;
        public Camera tagerCamera;
        private string pngName;
        private string realFolder = ""; //渲染保存位置
        private float originaltimescaleTime; // 跟踪原始的时间尺度，这样我们就可以冻结帧与帧之间的动画
        private float currentTime = 0;
        private bool over = false;
        private int currentIndex = 0;
        private Camera exportCamera;    // 导出光效的摄像机，使用RenderTexture
        private GameObject go;
        public void Start()
        {


            AnimationData animationData = new AnimationData();
            animationData = _dataDispose.Read<AnimationData>(Application.dataPath + "/" + listpath);
            pngName = animationData.pngName;
           screenWidth = animationData.resWidth;
            screenHeight = animationData.resHeight;
            scale = animationData.scale;
            frameCount = animationData.frameCount;
            frameRate = animationData.frameRate;
            realFolder = animationData.path;
            //animationData.myCameraname;         
            Camera[] FindCamera = (Camera[])GameObject.FindObjectsOfType(typeof(Camera));
            foreach (var item in FindCamera)
            {
                item.transform.gameObject.SetActive(false);
                if (item.name == animationData.myCameraname)
                {
                    tagerCamera = item;
                    item.transform.gameObject.SetActive(true);
                }
              
            }
            Debug.Log(tagerCamera.name);          
            // set frame rate
            Time.captureFramerate = frameRate;
           


            originaltimescaleTime = Time.timeScale;

            GameObject goCamera = tagerCamera.gameObject;

            go = Instantiate(goCamera) as GameObject;          
            exportCamera = go.GetComponent<Camera>();
            exportCamera.transform.gameObject.SetActive(true);
          
            currentTime = 0;


        }

        void Update()
        {
            currentTime += Time.deltaTime;
            if (!over && currentIndex >= frameCount)
            {
                over = true;
                Cleanup();
                Debug.Log("Finish");
                return;
            }

            // 每帧截屏
            StartCoroutine(CaptureFrame());
        }

        void Cleanup()
        {
            DestroyImmediate(exportCamera);
            DestroyImmediate(gameObject);
            DestroyImmediate(go);
        }

        IEnumerator CaptureFrame()
        {
            // Stop time
            Time.timeScale = 0;
            // Yield to next frame and then start the rendering
            // this is important, otherwise will have error
            yield return new WaitForEndOfFrame();

            exportCamera.transform.position = tagerCamera.transform.position;
            exportCamera.transform.rotation = tagerCamera.transform.rotation;
            exportCamera.transform.localScale = tagerCamera.transform.localScale;
            if (exportCamera.orthographic == true)
            {
                exportCamera.orthographicSize = tagerCamera.orthographicSize;
            }
            else
            {
                exportCamera.fieldOfView = tagerCamera.fieldOfView;
            }

            string filename = String.Format("{0}/{1}{2:D04}.png", realFolder, pngName, ++currentIndex);
            Debug.Log(filename);

            //Initialize and render textures
            RenderTexture blackCamRenderTexture = new RenderTexture(screenWidth* scale, screenHeight* scale, 24, RenderTextureFormat.ARGB32);
            RenderTexture whiteCamRenderTexture = new RenderTexture(screenWidth* scale, screenHeight* scale, 24, RenderTextureFormat.ARGB32);

            exportCamera.targetTexture = blackCamRenderTexture;
            exportCamera.backgroundColor = Color.black;
            exportCamera.Render();
            RenderTexture.active = blackCamRenderTexture;
            Texture2D texb = GetTex2D();

            //Now do it for Alpha Camera
            exportCamera.targetTexture = whiteCamRenderTexture;
            exportCamera.backgroundColor = Color.white;
            exportCamera.Render();
            RenderTexture.active = whiteCamRenderTexture;
            Texture2D texw = GetTex2D();

            // If we have both textures then create final output texture
            if (texw && texb)
            {
                Texture2D outputtex = new Texture2D(screenWidth * scale, screenHeight * scale, TextureFormat.ARGB32, false);

                // we need to check alpha ourselves,because particle use additive shader
                // Create Alpha from the difference between black and white camera renders
                for (int y = 0; y < outputtex.height; ++y)
                { // each row
                    for (int x = 0; x < outputtex.width; ++x)
                    { // each column
                        float alpha;
                        alpha = texw.GetPixel(x, y).r - texb.GetPixel(x, y).r;
                        alpha = 1.0f - alpha;
                        Color color;
                        if (alpha == 0)
                        {
                            color = Color.clear;
                        }
                        else
                        {
                            color = texb.GetPixel(x, y);
                        }
                        color.a = alpha;
                        outputtex.SetPixel(x, y, color);
                    }
                }


                // Encode the resulting output texture to a byte array then write to the file
                byte[] pngShot = outputtex.EncodeToPNG();
                File.WriteAllBytes(filename, pngShot);

                // cleanup, otherwise will memory leak
                pngShot = null;
                RenderTexture.active = null;
               
                System.GC.Collect();

                // Reset the time scale, then move on to the next frame.
                Time.timeScale = originaltimescaleTime;
            }
        }

        // Get the texture from the screen, render all or only half of the camera
        private Texture2D GetTex2D()
        {

            Texture2D tex = new Texture2D(screenWidth * scale, screenHeight * scale, TextureFormat.ARGB32, false);
            // Read screen contents into the texture
            tex.ReadPixels(new Rect(0, 0, screenWidth * scale, screenHeight * scale), 0, 0);
            tex.Apply();
            return tex;
        }


    }
}
#endif