using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameController : MonoBehaviour {
    [SerializeField]
    private GameObject m_player;
    [Tooltip("是否合并网格贴图")]
    public bool is_CombineMeshes=false;

    void Start () {

        if (!is_CombineMeshes)
        {         
            GameObject player = Instantiate(m_player);
            return;
        }

        GameObject playerClone = Instantiate(m_player);

        List<CombineInstance> combineInstances = new List<CombineInstance>();
        Material material = null;
        List<Transform> bones = new List<Transform>();
        List<Texture2D> textures = new List<Texture2D>();
        List<Vector2[]> uvList = new List<Vector2[]>();
        int uvCount = 0;

        SkinnedMeshRenderer[] skinnedMeshs = playerClone.GetComponentsInChildren<SkinnedMeshRenderer>();
        Transform[] transforms = playerClone.GetComponentsInChildren<Transform>();
       
        for(int num=0; num < skinnedMeshs.Length; num++)
        {
            SkinnedMeshRenderer temp = skinnedMeshs[num];
            if (material == null)
            {
                //返回分配给渲染器的第一个材质
                material = temp.sharedMaterial;
            }

            //合并网格
            CombineInstance ci = new CombineInstance();
            ci.mesh = temp.sharedMesh;
            //子网格索引
            //ci.subMeshIndex = num;
            //合并之前网格变换的矩阵
            ci.transform = temp.transform.localToWorldMatrix;
            //变换矩阵有问题（就用这句），要保持相对位置不变，要转换为父节点的本地坐标，
            //ci.transform = transform.worldToLocalMatrix * temp.transform.localToWorldMatrix;
            combineInstances.Add(ci);

            //取得temp相对应名称的骨骼列表 
            int startBoneIndex = bones.Count;
            foreach(Transform t in temp.bones) {
                foreach(Transform transform in transforms) {
                    if(transform.name != t.name)
                        continue;
                    bones.Add (transform);
                    break;
                }
            }

            //储存网格纹理坐标
            uvList.Add (temp.sharedMesh.uv);
            uvCount += temp.sharedMesh.uv.Length;

            //子网格
            int endBoneIndex = bones.Count;
            for(int i = 1; i < temp.sharedMesh.subMeshCount; ++i) {
                for(int jj = startBoneIndex; jj < endBoneIndex; ++jj) {
                    bones.Add (bones[jj]);
                }
            }

            //贴图记录
            if(temp.material.mainTexture != null) {
                textures.Add (temp.GetComponent<Renderer> ().material.mainTexture as Texture2D);
            }
            temp.gameObject.SetActive(false);
        }

        //贴图合并（注意合并最大尺寸）
        Texture2D skinnedMeshAtlas = new Texture2D (1024 , 1024);
        
        Rect[] packingResult = skinnedMeshAtlas.PackTextures (textures.ToArray () , 0);

        //网格纹理坐标合并
        Vector2[] atlasUVs = new Vector2[uvCount];
        int j = 0;
        for(int i = 0; i < uvList.Count; i++) {
            foreach(Vector2 uv in uvList[i]) {
                atlasUVs[j].x = Mathf.Lerp (packingResult[i].xMin , packingResult[i].xMax , uv.x);
                atlasUVs[j].y = Mathf.Lerp (packingResult[i].yMin , packingResult[i].yMax , uv.y);
                j++;
            }
        }

        //蒙皮网格渲染器
        SkinnedMeshRenderer r = playerClone.AddComponent<SkinnedMeshRenderer> ();
        r.sharedMesh = new Mesh ();
        //第二个参数是否合并成同一个材质 参数三为false，在CombineInstance结构变换矩阵将被忽略。 
        r.sharedMesh.CombineMeshes (combineInstances.ToArray () , true,false );  
        r.bones = bones.ToArray ();
        r.material = material;
        r.material.mainTexture = skinnedMeshAtlas;
        r.sharedMesh.uv = atlasUVs;
    }
	
}
