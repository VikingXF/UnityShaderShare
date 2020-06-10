//=============================================
//作者:
//描述:创建depth相机
//创建时间:2020/06/03 17:13:09
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraDepthTexture : MonoBehaviour
{
    Camera _camera;

    RenderTexture _rt;

    // 光照的角度
    public Transform lightTrans;

    Matrix4x4 bias = new Matrix4x4();

    [Range(0, 0.1f)]
    public float ShadowBias = 0.005f;

    [Range(1, 2000)]
    public int UVLightSize = 500;

    [Range(1, 10)]
    public float OrthographicSize = 10;


    void Start()
    {

        _camera = new GameObject().AddComponent<Camera>();
        _camera.name = "DepthCamera";
        _camera.depth = 2;
        _camera.clearFlags = CameraClearFlags.SolidColor;
        _camera.backgroundColor = Color.white;
        _camera.nearClipPlane = -100;
        _camera.farClipPlane = 100;

        _camera.cullingMask = LayerMask.GetMask("Water");
        _camera.aspect = 1;
        _camera.transform.position = this.transform.position;
        _camera.transform.rotation = this.transform.rotation;
        _camera.transform.parent = this.transform;

        _camera.orthographic = true;
        _camera.orthographicSize = OrthographicSize;


        // 0.5 * x + 0.5  [-1, 1] => [0, 1]
        bias.SetRow(0, new Vector4(0.5f, 0, 0, 0.5f));
        bias.SetRow(1, new Vector4(0, 0.5f, 0, 0.5f));
        bias.SetRow(2, new Vector4(0, 0, 0.5f, 0.5f));
        bias.SetRow(3, new Vector4(0, 0, 0, 1));


        _rt = new RenderTexture(1024, 1024, 0);
        _rt.filterMode = FilterMode.Point;
        _camera.targetTexture = _rt;
        _camera.SetReplacementShader(Shader.Find("Shadow/DeapthTexture"), "RenderType");
    }

    void Update()
    {
        _camera.orthographicSize = OrthographicSize;
        this.transform.eulerAngles = lightTrans.eulerAngles;
        _camera.Render();

        Matrix4x4 project = _camera.projectionMatrix;
        Matrix4x4 worldToView = _camera.worldToCameraMatrix;
        Matrix4x4 mtx = project * worldToView;

        mtx = bias * mtx;

        Shader.SetGlobalMatrix("_ProjectionMatrix", mtx);
        Shader.SetGlobalMatrix("_WorldToViewMatrix", worldToView);
        Shader.SetGlobalTexture("_DepthTexture", _rt);
        Shader.SetGlobalFloat("_ShadowBias", ShadowBias);
        Shader.SetGlobalFloat("UVLightSize", UVLightSize);
        Shader.SetGlobalVector("_EyePos", new Vector4(
            _camera.transform.position.x,
            _camera.transform.position.y,
            _camera.transform.position.z, 0));
    }
}
