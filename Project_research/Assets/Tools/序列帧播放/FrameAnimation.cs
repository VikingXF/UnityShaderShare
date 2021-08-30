using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FrameAnimation : MonoBehaviour
{

    public enum ReplayModeEnum
    {
        Again,
        Continuous
       
    }
    public enum ModeEnum
    {
        Sprites,
        Grid
    }

    public ReplayModeEnum ReplayMode;
    public ModeEnum Mode;

    public List<Texture2D> Sprites;

    public Vector2 Tiles;
    
    public enum TimeEnum
    {
        single,
        Looping
    }
    public TimeEnum TimeMode;
    public float Fps = 10f;

    public int StartFarme;
   // public int EndFarme;
    private Material Farmemat;
    private bool LoopingBool = true;
    private int length;
    private int currentIndex = 0;
    private float time = 0;
    private float Singletime = 0;
    private float GridIndexX = 0;
    private float GridIndexY = 0;
    private void OnEnable()
    {


        Farmemat = this.gameObject.GetComponent<MeshRenderer>().material;
        length = Sprites.Count;
        LoopingBool = true;
        time = 0;
        if (Mode == ModeEnum.Sprites)
        {
            if (ReplayMode == ReplayModeEnum.Again)
            {
                currentIndex = StartFarme;
                Farmemat.mainTexture = Sprites[currentIndex]; 
            }

            if (ReplayMode == ReplayModeEnum.Continuous)
            {
                if (Singletime == 0)
                {
                    currentIndex = StartFarme;
                }
                //Farmemat.mainTexture = Sprites[currentIndex]; 
            }
        }
        if (Mode == ModeEnum.Grid)
        {
            if (ReplayMode == ReplayModeEnum.Again)
            {
                float a = StartFarme % Tiles.x;
                int b = (int)Math.Floor(StartFarme/Tiles.y);
                GridIndexX = 1/Tiles.x*a;
                GridIndexY = 1 - 1 / Tiles.y*(b+1);
                Farmemat.SetTextureScale("_MainTex",new Vector2(1/Tiles.x,1/Tiles.y));
                Farmemat.SetTextureOffset("_MainTex",new Vector2(GridIndexX,GridIndexY));
            }

            if (ReplayMode == ReplayModeEnum.Continuous)
            {
                if (Singletime == 0)
                { 
                    float a = StartFarme % Tiles.x;
                    int b = (int)Math.Floor(StartFarme/Tiles.y);
                    GridIndexX = 1/Tiles.x*a;
                    GridIndexY = 1 - 1 / Tiles.y*(b+1);
                    Farmemat.SetTextureScale("_MainTex",new Vector2(1/Tiles.x,1/Tiles.y));
                    Farmemat.SetTextureOffset("_MainTex",new Vector2(GridIndexX,GridIndexY));
                    
                }

            }
          
        }

        Singletime = 0;   
    }

    private void Update()
    {
        if (Mode == ModeEnum.Sprites)
        {
            SpritesAnimation();
        }
        
        if (Mode == ModeEnum.Grid)
        {
            GridAnimation();
        }
    }
    //网格序列播放
    void GridAnimation()
    {
        if ( LoopingBool == true)
        {
            time += Time.deltaTime;
            Singletime+= Time.deltaTime;
            if (time >= 1.0f / Fps)
            {
                //Debug.Log("GridIndexX====="+GridIndexX+"GridIndexY====="+GridIndexY);
                time = 0;
                GridIndexX+= 1/Tiles.x;

                if (GridIndexX < 1)
                {
                    Farmemat.SetTextureOffset("_MainTex",new Vector2(GridIndexX,GridIndexY));
                }
                else
                {
                    GridIndexX = 0;
                    if (GridIndexY >0.1 )
                    {
                        GridIndexY -= 1/Tiles.y;
                        Farmemat.SetTextureOffset("_MainTex",new Vector2(GridIndexX,GridIndexY));
                    }
                    else
                    {
                        GridIndexY = 1 - 1 / Tiles.y;
                        Farmemat.SetTextureOffset("_MainTex",new Vector2(GridIndexX,GridIndexY));
                    }
          
                }
                //Debug.Log("Singletime"+Singletime);
                //播放一遍,回到第一张图
                if (Singletime > (1.0f / Fps )* (Tiles.x*Tiles.y))
                {
                    if (TimeMode == TimeEnum.single)
                    {
                        LoopingBool = false;
                    }
                }
                
            }
        }
    }

    //图片序列播放
    void SpritesAnimation()
    {
        if ( LoopingBool == true)
        {
            time += Time.deltaTime;
            Singletime+= Time.deltaTime;
            if (time >= 1.0f / Fps)
            {
                Debug.Log("currentIndex"+currentIndex);
                currentIndex++;
                //循环播放
                if (currentIndex > length - 1)
                {
                    currentIndex = 0;
                }
                
                Farmemat.mainTexture = Sprites[currentIndex];
                time = 0;

                //播放一遍,回到第一张图
                if (Singletime > (1.0f / Fps )* (length))
                {
                    if (TimeMode == TimeEnum.single)
                    {
                        LoopingBool = false;
                    }
                }
                

            }
        }
    }
}
