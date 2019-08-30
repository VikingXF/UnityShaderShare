//=======================================================
// 作者：xuefei
// 描述：Mesh 合并
// 1.实现多个Mesh合并为一个Mesh的多维材质 ==》CombineBasicMesh()
// 2.实现多个Mesh合并，贴图合并，材质合并为一个  ==》CombineMeshTexture()
// 3.实现多个SkinnedMesh合并为一个SkinnedMesh的多维材质  ==》CombineBasicSkinnedMesh()
//=======================================================
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;

namespace CombineMeshSpace
{
    public class CombineMesh : MonoBehaviour
    {
        public string CombineName = "CombineName";
        // Saving options
        public bool savePrefabs = true;
        public bool saveMesh = true;
       // public bool saveMeshFbx = true;
        public bool saveMaterials = true;
        public bool saveTextures = true;
        public string folder = "Assets/Tools/CombineMesh/";

        //1.实现多个Mesh合并为一个Mesh的多维材质
        public void CombineBasicMesh()
        {
            MeshRenderer[] meshRenders = GetComponentsInChildren<MeshRenderer>();
            List<Material> mats = new List<Material>();
            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
            List<CombineInstance> combine = new List<CombineInstance>();
            GameObject go = new GameObject();
            go.name = CombineName;

            for (int i = 0; i < meshRenders.Length; i++)
            {
                for (int j = 0; j < meshRenders[i].sharedMaterials.Length; j++)
                {
                    CombineInstance com = new CombineInstance();
                    com.mesh = meshFilters[i].sharedMesh;
                    com.subMeshIndex = j;
                    com.transform = meshFilters[i].transform.localToWorldMatrix;

                    //判断相同材质公用
                    if (mats.Contains(meshRenders[i].sharedMaterials[j]))
                    {
                        var t = mats.IndexOf(meshRenders[i].sharedMaterials[j]);

                        CombineInstance[] comM = new CombineInstance[2] { combine.ToArray()[t], com };
                        Mesh mm = new Mesh();
                        mm.CombineMeshes(comM, true);

                        CombineInstance comcom = new CombineInstance();
                        comcom.mesh = mm;                        
                        comcom.transform = go.transform.localToWorldMatrix;
                        combine[t] = comcom;

                        continue;
                    }

                    combine.Add(com);
                    mats.Add(meshRenders[i].sharedMaterials[j]);
                }
                meshFilters[i].gameObject.SetActive(false);
            }

            MeshRenderer mr = go.AddComponent<MeshRenderer>();
            MeshFilter mf = go.AddComponent<MeshFilter>();
            mf.sharedMesh = new Mesh();
            mf.sharedMesh.name = CombineName;
            mf.sharedMesh.CombineMeshes(combine.ToArray(), false);
            gameObject.SetActive(true);
            mr.sharedMaterials = mats.ToArray();
            go.transform.parent = gameObject.transform;

            savePrefabs = true;
            saveMesh = true;
            saveMaterials = false;
            saveTextures = false;
            Save(go);
            //Destroy(go);
        }

        //2.实现多个Mesh合并，贴图合并，材质合并为一个
        public void CombineMeshTexture()
        {
            MeshRenderer[] meshRenders = GetComponentsInChildren<MeshRenderer>();
            List<Material> mats = new List<Material>();
            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
            List<CombineInstance> combine = new List<CombineInstance>();
            GameObject go = new GameObject();
            go.name = CombineName;
            List<Shader> shaders = new List<Shader>();
            List<Texture2D> textures = new List<Texture2D>();
            List<Vector2[]> uvList = new List<Vector2[]>();
            int uvCount = 0;
            int width = 0;
            int height = 0;


            for (int i = 0; i < meshRenders.Length; i++)
            {
                for (int j = 0; j < meshRenders[i].sharedMaterials.Length; j++)
                {
                    CombineInstance com = new CombineInstance();
                    com.mesh = meshFilters[i].sharedMesh;
                    //com.mesh.triangles = meshFilters[i].mesh.GetTriangles(j);                    
                    com.subMeshIndex = j;

                    com.transform = meshFilters[i].transform.localToWorldMatrix;

                    //判断相同材质公用
                    if (mats.Contains(meshRenders[i].sharedMaterials[j]))
                    {
                        var t = mats.IndexOf(meshRenders[i].sharedMaterials[j]);

                        CombineInstance[] comM = new CombineInstance[2] { combine.ToArray()[t], com };
                        Mesh mm = new Mesh();
                        mm.CombineMeshes(comM, true);

                        CombineInstance comcom = new CombineInstance();
                        comcom.mesh = mm;
                        comcom.transform = go.transform.localToWorldMatrix;
                        combine[t] = comcom;

                        continue;
                    }

                    //贴图记录
                    if (meshRenders[i].sharedMaterials[j].mainTexture != null)
                    {
                        textures.Add(meshRenders[i].sharedMaterials[j].mainTexture as Texture2D);
                        width += meshRenders[i].sharedMaterials[j].mainTexture.width;
                        height += meshRenders[i].sharedMaterials[j].mainTexture.height;
                    }

                    combine.Add(com);
                    mats.Add(meshRenders[i].sharedMaterials[j]);

                }
                meshFilters[i].gameObject.SetActive(false);
            }
            for (int i = 0; i < mats.Count; i++)
            {

                shaders.Add(mats[i].shader);

            }

            //去除重复的mesh
            for (int i = 0; i < combine.Count; i++)
            {

                CombineInstance[] CIM = new CombineInstance[] { combine[i] };
                Mesh CombineIm = new Mesh();
                CombineIm.CombineMeshes(CIM);

                CombineInstance comcom2 = new CombineInstance();
                comcom2.mesh = CombineIm;
                comcom2.transform = go.transform.localToWorldMatrix;
                combine[i] = comcom2;
            }

            //储存网格纹理坐标
            for (int i = 0; i < combine.Count; i++)
            {
                uvList.Add(combine[i].mesh.uv);
                uvCount += combine[i].mesh.uv.Length;
            }

            //贴图合并
            Texture2D TextureAtlas = new Texture2D(width, height);

            Rect[] packingResult = TextureAtlas.PackTextures(textures.ToArray(), 0);

            //网格纹理坐标合并
            Vector2[] atlasUVs = new Vector2[uvCount];
            int li = 0;

            for (int k = 0; k < uvList.Count; k++)
            {

                foreach (Vector2 uv in uvList[k])
                {
                    atlasUVs[li].x = Mathf.Lerp(packingResult[k].xMin, packingResult[k].xMax, uv.x);
                    atlasUVs[li].y = Mathf.Lerp(packingResult[k].yMin, packingResult[k].yMax, uv.y);
                    li++;
                }

            }

            MeshRenderer mr = go.AddComponent<MeshRenderer>();
            MeshFilter mf = go.AddComponent<MeshFilter>();
            mf.sharedMesh = new Mesh();
            mf.sharedMesh.name = CombineName;
            mf.sharedMesh.CombineMeshes(combine.ToArray(), true);
            mf.sharedMesh.uv = atlasUVs;

            Material material = new Material(shaders[0]);
            material.name = CombineName;
            TextureAtlas.name = CombineName;
            material.mainTexture = TextureAtlas;
            mr.sharedMaterial = material;

            gameObject.SetActive(true);
            // Destroy(go);
            go.transform.parent = gameObject.transform;

            savePrefabs = true;
            saveMesh = true;
            saveMaterials = true;
            saveTextures = true;

            Save(go);
        }

        //3.实现多个SkinnedMesh合并为一个SkinnedMesh的多维材质


        public static int VERTEX_NUMBER; //所有顶点数
        public static int BONE_NUMBER;     //bones总数

        public void CombineBasicSkinnedMesh()
        {
 
            SkinnedMeshRenderer[] skinmeshRenders = GetComponentsInChildren<SkinnedMeshRenderer>();
            List<Material> mats = new List<Material>();
            List<CombineInstance> combine = new List<CombineInstance>();


            Transform[] totalBones = new Transform[BONE_NUMBER];
            Matrix4x4[] totalBindPoses = new Matrix4x4[BONE_NUMBER];
            BoneWeight[] totalBoneWeight = new BoneWeight[VERTEX_NUMBER];
            int offset = 0;
            int b_offset = 0;
            Transform[] usedBones = new Transform[totalBones.Length];
            Hashtable boneHash = new Hashtable();

            GameObject go = new GameObject();
            go.name = CombineName;

            for (int i = 0; i < skinmeshRenders.Length; i++)
            {
                for (int j = 0; j < skinmeshRenders[i].sharedMaterials.Length; j++)
                {
                    CombineInstance com = new CombineInstance();
                    com.mesh = skinmeshRenders[i].sharedMesh;
                    com.subMeshIndex = j;
                    com.transform = skinmeshRenders[i].transform.localToWorldMatrix;

                    //判断相同材质公用
                    if (mats.Contains(skinmeshRenders[i].sharedMaterials[j]))
                    {
                        var t = mats.IndexOf(skinmeshRenders[i].sharedMaterials[j]);

                        CombineInstance[] comM = new CombineInstance[2] { combine.ToArray()[t], com };
                        Mesh mm = new Mesh();
                        mm.CombineMeshes(comM, true);

                        CombineInstance comcom = new CombineInstance();
                        comcom.mesh = mm;
                        comcom.transform = go.transform.localToWorldMatrix;
                        combine[t] = comcom;

                        continue;
                    }

                    combine.Add(com);
                    
                    //拷贝Bones
                    for (int x = 0; x < skinmeshRenders[i].bones.Length; x++)
                    {

                        bool flag = false;
                        for (int kk = 0; kk < totalBones.Length; kk++)
                        {
                            if (usedBones[kk] != null)
                                //如果bone已经插入
                                if ((skinmeshRenders[i].bones[x] == usedBones[kk]))
                                {
                                    flag = true;
                                    break;
                                }
                        }

                        //If Bone is New ...
                        if (!flag)
                        {
                            //Debug.Log("Inserted bone:"+smrenderer.bones[x].name);
                            for (int f = 0; f < totalBones.Length; f++)
                            {
                                //在第一free position插入bone
                                if (usedBones[f] == null)
                                {
                                    usedBones[f] = skinmeshRenders[i].bones[x];
                                    break;
                                }
                            }
                            //在totalBones中插入bones
                            totalBones[offset] = skinmeshRenders[i].bones[x];
                            //HashTable参考
                            boneHash.Add(skinmeshRenders[i].bones[x].name, offset);

                            //重新计算BindPoses
                            //totalBindPoses[offset] = smrenderer.sharedMesh.bindposes[x] ;						
                            totalBindPoses[offset] = skinmeshRenders[i].bones[x].worldToLocalMatrix * transform.localToWorldMatrix;
                            offset++;
                        }
                    }

                    //重新计算BoneWeights
                    for (int x = 0; x < skinmeshRenders[i].sharedMesh.boneWeights.Length; x++)
                    {
                        //只是复制和更改骨骼索引 !!						
                        totalBoneWeight[b_offset] = recalculateIndexes(skinmeshRenders[i].sharedMesh.boneWeights[x], boneHash, skinmeshRenders[i].bones);
                        b_offset++;
                    }


                    Debug.Log(skinmeshRenders[i].name+ ":"+skinmeshRenders[i].bones.Length);
                   

                    mats.Add(skinmeshRenders[i].sharedMaterials[j]);
                }

                skinmeshRenders[i].gameObject.SetActive(false);
            }

            SkinnedMeshRenderer mr = go.AddComponent<SkinnedMeshRenderer>();

            mr.sharedMesh = new Mesh();
            mr.sharedMesh.name = CombineName;
            mr.sharedMesh.CombineMeshes(combine.ToArray(), false);
            gameObject.SetActive(true);
            mr.sharedMaterials = mats.ToArray();

            //设置Bindposes
            mr.sharedMesh.bindposes = totalBindPoses;

            // 设置BoneWeights
            mr.sharedMesh.boneWeights = totalBoneWeight;

            //设置bones
            mr.bones = totalBones;

            mr.sharedMesh.RecalculateNormals();
            mr.sharedMesh.RecalculateBounds();

            go.transform.parent = gameObject.transform;

            //savePrefabs = true;
            //saveMesh = true;
            //saveMaterials = false;
            //saveTextures = false;
            //Save(go);
            //Destroy(go);
        }

        //为新骨头设置索引
        static BoneWeight recalculateIndexes(BoneWeight bw, Hashtable boneHash, Transform[] meshBones)
        {
            BoneWeight retBw = bw;
            retBw.boneIndex0 = (int)boneHash[meshBones[bw.boneIndex0].name];
            retBw.boneIndex1 = (int)boneHash[meshBones[bw.boneIndex1].name];
            retBw.boneIndex2 = (int)boneHash[meshBones[bw.boneIndex2].name];
            retBw.boneIndex3 = (int)boneHash[meshBones[bw.boneIndex3].name];
            return retBw;
        }


#if UNITY_EDITOR
        public string MaterialTexFolder;
        public void Save(GameObject go)
        {

            if (folder == "")
            {              
                folder = "Assets/Tools/CombineMeshe/";
            }

            //Mesh保存
            if (saveMesh)
            {
              
                // Check if destination folder exists
                if (!Directory.Exists(folder + "Meshes/"))
                {
                    Directory.CreateDirectory(folder + "Meshes/");
                }
                string path = folder + "Meshes/" + go.GetComponent<MeshFilter>().sharedMesh.name + ".asset";

                //判断是否重名
                if (File.Exists(path))
                {
                    for (int i = 0; i < 100; i++)
                    {                      
                        path = path.Replace(".asset", "") + i.ToString() + ".asset";                     
                        if (!File.Exists(path))
                        {                        
                            break;
                        }
                    }

                }
                SaveAssets.SaveMesh(path, go.GetComponent<MeshFilter>().sharedMesh);

            }
            
            
            // 贴图保存
            if (saveTextures)
            {               
                // Check if destination folder exists
                if (!Directory.Exists(folder + "Textures/"))
                {
                    Directory.CreateDirectory(folder + "Textures/");
                }
                string path = folder + "Textures/" + go.GetComponent<MeshRenderer>().sharedMaterial.mainTexture.name + ".png";
                
                //判断是否重名
                if (File.Exists(path))
                {                 
                    for (int i = 0; i < 100; i++)
                    {                     
                        path = path.Replace(".png", "") +i.ToString() + ".png";                    
                        if (!File.Exists(path))
                        {                    
                            break;
                        }
                    }
                }
               
                SaveAssets.SaveTextures(path, go.GetComponent<MeshRenderer>().sharedMaterial.mainTexture.name, (Texture2D)go.GetComponent<MeshRenderer>().sharedMaterial.mainTexture);
                MaterialTexFolder = path;
            }
            // 材质球保存
            if (saveMaterials)
            {

                // Check if destination folder exists
                if (!Directory.Exists(folder + "Materials/"))
                {
                    Directory.CreateDirectory(folder + "Materials/");
                }
                string path = folder + "Materials/" + go.name + ".mat";

                //判断是否重名
                if (File.Exists(path))
                {
                    for (int i = 0; i < 100; i++)
                    {
                        path = path.Replace(".mat", "") + i.ToString() + ".mat";
                        if (!File.Exists(path))
                        {
                            break;
                        }
                    }

                }

                Material mater = go.GetComponent<MeshRenderer>().sharedMaterial;
                Texture2D Tex = (Texture2D)AssetDatabase.LoadAssetAtPath(MaterialTexFolder, typeof(Texture2D));
                mater.mainTexture = Tex;

                SaveAssets.SaveMaterial(path, mater);
            }

            // 预制体保存
            if (savePrefabs)
            {

                // Check if destination folder exists
                if (!Directory.Exists(folder + "Prefabs/"))
                {
                    Directory.CreateDirectory(folder + "Prefabs/");
                }
                string path = folder + "Prefabs/" + go.name + ".prefab";

                //判断是否重名
                if (File.Exists(path))
                {
                    for (int i = 0; i < 100; i++)
                    {
                        path = path.Replace(".prefab", "") + i.ToString() + ".prefab";
                        if (!File.Exists(path))
                        {
                            break;
                        }
                    }

                }
                SaveAssets.SavePrefab(path, go);
            }
        }
       #endif

    }

}
