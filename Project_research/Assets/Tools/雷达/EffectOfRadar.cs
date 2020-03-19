using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class EffectOfRadar : MonoBehaviour
{
    List<Vector3> verts = new List<Vector3>();
    List<Vector3> norms = new List<Vector3>();
    List<Vector2> uvs = new List<Vector2>();
    List<int> tris = new List<int>();

    public void CreateTextMesh()
    {
        //Debug.Log(Text.Length);
        for (int i = 0; i < 3; i++)
        {
            verts.Add(new Vector3(0, 0, 0));
            uvs.Add(new Vector2(0, 0));
            //每个顶点的法线方向
            for (int k = 0; k < 4; k++)
            {
                norms.Add(Vector3.up);
            }
        }

        //Debug.Log(verts.ToArray().Length);
        for (int x = 0; x < 3; x++)
        {

            // 第一个三角形.  
            tris.Add(0 + 4 * x);
            tris.Add(2 + 4 * x);
            tris.Add(1 + 4 * x);

            //第二个三角形.
            tris.Add(1 + 4 * x);
            tris.Add(2 + 4 * x);
            tris.Add(3 + 4 * x);

        }

        //Debug.Log(tris.ToArray().Length);

        Mesh m = new Mesh();
        m.vertices = verts.ToArray();
        m.triangles = tris.ToArray();
        m.normals = norms.ToArray();
        m.uv = uvs.ToArray();
        GetComponent<MeshFilter>().mesh = m;
        verts.Clear();
        tris.Clear();
        norms.Clear();
        uvs.Clear();


    }
}
