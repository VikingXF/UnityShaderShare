using UnityEngine;

[ExecuteInEditMode]
public class GLLines : MonoBehaviour
{
    public Material lineMaterial;

    private Mesh m_mesh;
    private Vector3[] m_vertices;
    private int[] m_triangles;
    private Transform m_transform;

    void Awake()
    {
        m_mesh = this.GetComponent<MeshFilter>().sharedMesh;
        m_vertices = m_mesh.vertices;
        m_triangles = m_mesh.triangles;
        m_transform = transform;
    }

    public void OnRenderObject()
    {
        lineMaterial.SetPass(0);

        GL.PushMatrix();
        GL.MultMatrix(m_transform.localToWorldMatrix);

        GL.Begin(GL.LINES);

        for (int cnt = 0; cnt < m_triangles.Length; cnt += 3)
        {
            GL.Vertex(m_vertices[m_triangles[cnt]]);
            GL.Vertex(m_vertices[m_triangles[cnt + 1]]);
            GL.Vertex(m_vertices[m_triangles[cnt + 1]]);
            GL.Vertex(m_vertices[m_triangles[cnt + 2]]);
            GL.Vertex(m_vertices[m_triangles[cnt + 2]]);
            GL.Vertex(m_vertices[m_triangles[cnt]]);
        }

        GL.End();
        GL.PopMatrix();
    }
}