using UnityEngine;



[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
[ExecuteInEditMode]

public class PrimitiveBase : MonoBehaviour
{

    /// <summary>
    /// 偏移
    /// </summary>

    public Vector3 offset;
    protected MeshFilter meshFilter;
    public Transform cacheTransform;

    void Awake()

    {
        Init();
        InitMesh();
    }

    protected void Init()

    {
        cacheTransform = transform;
        meshFilter = GetComponent<MeshFilter>();
        meshFilter.sharedMesh = new Mesh();
    }

    protected virtual void InitMesh()

    {

    }

    protected Vector3[] vertices;
    protected int[] triangles;
    protected Vector2[] uvs;
    protected Vector3[] normals;

    protected void UpdateMesh()

    {

        if (meshFilter.sharedMesh == null)
        {
            meshFilter.sharedMesh = new Mesh();

        }
        meshFilter.sharedMesh.vertices = vertices;
        meshFilter.sharedMesh.triangles = triangles;
        meshFilter.sharedMesh.uv = uvs;
        meshFilter.sharedMesh.normals = normals;

    }

    protected virtual void UpdateShape()
    {

    }

    void OnValidate()
    {
        InitMesh();
    }

}