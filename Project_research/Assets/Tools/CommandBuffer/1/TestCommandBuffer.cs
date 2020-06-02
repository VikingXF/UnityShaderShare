//=============================================
//作者:
//描述:
//创建时间:2020/05/08 15:41:42
//版本:v 1.0
//=============================================
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class TestCommandBuffer : MonoBehaviour
{
    //public Shader shader;
    public Material material;
    private void OnEnable()
    {
        CommandBuffer buf = new CommandBuffer();
        //设置自己的渲染。
        //buf.DrawRenderer(GetComponent<Renderer>(), new Material(shader));
        buf.DrawRenderer(GetComponent<Renderer>(), material);
        //不透明物体渲染完后执行
        Camera.main.AddCommandBuffer(CameraEvent.AfterForwardOpaque, buf);
    }
}

