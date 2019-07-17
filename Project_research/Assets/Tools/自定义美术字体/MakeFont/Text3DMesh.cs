using UnityEngine;
using System.Collections.Generic;



[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class Text3DMesh : MonoBehaviour
{
    
    public Font font;
    public string Text = "";
    public float Interval = 0;
    private float XAdd;
    public float FontSize = 1;

    List<Vector3> verts = new List<Vector3>();
    List<Vector3> norms = new List<Vector3>();
    List<Vector2> uvs = new List<Vector2>();
    List<int> tris = new List<int>();


    public void CreateTextMesh()
    {

        //Debug.Log(Text.Length);
        for (int i = 0; i < Text.Length; i++)
        {
            int Num;
            int.TryParse(Text.Substring(i, 1), out Num);

            float minX = font.characterInfo[Num].minX * FontSize;
            float minY = Mathf.Abs(font.characterInfo[Num].minY) * FontSize;
            float maxX = font.characterInfo[Num].maxX * FontSize;
            float maxY = font.characterInfo[Num].maxY * FontSize;

            float uvminX = font.characterInfo[Num].uvBottomLeft[0];
            float uvmaxX = font.characterInfo[Num].uvBottomRight[0];

            float uvminY = font.characterInfo[Num].uvBottomLeft[1];
            float uvmaxY = font.characterInfo[Num].uvTopLeft[1];

            //Debug.Log(uvminY);
            //Debug.Log(uvmaxY);

            verts.Add(new Vector3(minX + XAdd, maxY, 0));
            verts.Add(new Vector3(maxX + XAdd, maxY, 0));
            verts.Add(new Vector3(minX + XAdd, minY, 0));
            verts.Add(new Vector3(maxX + XAdd, minY, 0));
            uvs.Add(new Vector2(uvminX, uvminY));
            uvs.Add(new Vector2(uvmaxX, uvminY));
            uvs.Add(new Vector2(uvminX, uvmaxY));
            uvs.Add(new Vector2(uvmaxX, uvmaxY));

            XAdd += maxX + Interval;
            //Debug.Log("XAdd"+XAdd);

            //每个顶点的法线方向
            for (int k = 0; k < 4; k++)
            {
                norms.Add(Vector3.up);
            }

        }

        //Debug.Log(verts.ToArray().Length);
        for (int x = 0; x < Text.Length; x++)
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
        XAdd = 0;

    }

}