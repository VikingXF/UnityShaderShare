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
    public int EdgeCount
    {
        get
        {
            if (m_Weights == null)
                return 0;
            return m_Weights.Count;
        }
    }
    public List<float> Weights
    {
        get { return m_Weights; }
    }
    [SerializeField] public List<float> m_Weights;

    private Vector3 translation;
    private Vector3 scale = new Vector3(1, 1, 1);

    public Color Maincolor = new Color(0.5f, 0.5f, 0.5f,0.5f);
    public Color Outlincolor = new Color(1f, 1f, 1f, 0.8f);
    public float outline = 1.1f;
    private Shader CurShader;
    //指定Shader名称
    private string ShaderName = "Babybus/Special/OutLineColor";
    private Material CurMaterial;
    
    //Material material
    //{
    //    get
    //    {
    //        if (CurMaterial == null)
    //        {
    //            CurMaterial = new Material(CurShader);
    //            CurMaterial.hideFlags = HideFlags.HideAndDontSave;
    //        }
    //        return CurMaterial;
    //    }
    //}

    private void Start()
    {
        CreateMesh();      
        CurShader = Shader.Find(ShaderName);
        if (CurMaterial == null)
        {
            CurMaterial = new Material(CurShader);         
        }
        this.GetComponent<Renderer>().material = CurMaterial;
        Setcolor();
    }
    public void Setcolor()
    {
        CurMaterial.SetFloat("_Outline",outline);       
        CurMaterial.SetColor("_Color", Maincolor);
        CurMaterial.SetColor("_OutlineColor", Outlincolor);
    }


    public void CreateMesh()
    {
        verts.Add(new Vector3(0, 0, 0));
        verts.Add(new Vector3(0, m_Weights[0], 0));
        Vector3 v = new Vector3(0, 1, 0);
        float subAngle = 360/EdgeCount;

        

        for (int i = 1; i < EdgeCount; i++)
        {
            Quaternion rotation = Quaternion.Euler(0, 0, subAngle*i);
            Matrix4x4 ma = Matrix4x4.TRS(translation, rotation, scale);
            verts.Add(ma.MultiplyPoint(v * Weights[i]));
           
        }
        for (int j = 0; j <= EdgeCount; j++)
        {
            uvs.Add(verts[j]);
        }
        for (int k = 0; k <= EdgeCount; k++)
        {
            norms.Add(Vector3.up);
        }

        //foreach (var vert in verts)
        //{
        //    Debug.Log(vert);
        //}
        //Debug.Log(verts.Count);

        for (int x = 0; x < EdgeCount-1; x++)
        { 
            tris.Add(0);
            tris.Add(2 + x);
            tris.Add(1 + x);
        }
        //最后一个三角形.
        tris.Add(0);
        tris.Add(1);
        tris.Add(EdgeCount);

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
