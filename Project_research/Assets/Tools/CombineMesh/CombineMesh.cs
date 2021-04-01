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
       //public bool saveMeshFbx = true;
        public bool saveMaterials = true;
        public bool saveTextures = true;
        public string folder = "Assets/Tools/CombineMesh/";
        public List<GameObject> CombineMeshs = new List<GameObject>();

        public void CombineLightmapMesh()
        {

            List<MeshRenderer> meshRenders = new List<MeshRenderer>();
            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
            List<CombineInstance> combine = new List<CombineInstance>();
            List<Vector2[]> uvList2 = new List<Vector2[]>();

            List<Material> mats = new List<Material>();
            GameObject go = new GameObject();
            go.name = CombineName;

            foreach (var CombineMesh in CombineMeshs)
            {
                meshRenders.Add(CombineMesh.GetComponent<MeshRenderer>());
            }
            Debug.Log(meshRenders.Count);
            for (int i = 0; i < meshRenders.Count; i++)
            {
                Vector2 lightmapScale = new Vector2(meshRenders[i].lightmapScaleOffset.x, meshRenders[i].lightmapScaleOffset.y);
                Vector2 lightmapOffset = new Vector2(meshRenders[i].lightmapScaleOffset.z, meshRenders[i].lightmapScaleOffset.w);
                for (int j = 0; j < meshRenders[i].sharedMaterials.Length; j++)
                {
                    CombineInstance com = new CombineInstance();
                    com.mesh = meshFilters[i].sharedMesh;
                    com.lightmapScaleOffset = meshRenders[i].lightmapScaleOffset;
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
                    // com.lightmapScaleOffset = meshRenders[i].lightmapScaleOffset;

                    Vector2[] uvList2Array = new Vector2[com.mesh.uv2.Length];
                    for (int k = 0; k < com.mesh.uv2.Length; k++)
                    {
                        Vector2 uv2scale;
                        Debug.Log(com.mesh.uv2.Length);
                        Debug.Log("meshFilters" + meshFilters[i].mesh.uv2[k]);
                        Debug.Log("com" + com.mesh.uv2[k]);
                        Debug.Log("x" + com.lightmapScaleOffset.x);
                        Debug.Log("z" + com.lightmapScaleOffset.z);
                        Debug.Log("w" + com.lightmapScaleOffset.w);
                        uv2scale.x = com.mesh.uv2[k].x * lightmapScale.x;
                        uv2scale.y = com.mesh.uv2[k].y * lightmapScale.y;
                        uvList2Array[k] = uv2scale + lightmapOffset;
                        Debug.Log("uvList2Array" + uvList2Array[k]);
                    }

                    com.mesh.uv2 = uvList2Array;
                    combine.Add(com);
                    mats.Add(meshRenders[i].sharedMaterials[j]);
                }

                //Vector2[] uvList2Array = new Vector2[meshFilters[i].mesh.uv2.Length];
                //for (int j = 0; j < meshFilters[i].mesh.uv2.Length; j++)
                //{
                //    uvList2Array[j] = meshFilters[i].mesh.uv2[j] * new Vector2(meshRenders[i].lightmapScaleOffset.x, meshRenders[i].lightmapScaleOffset.y) + new Vector2(meshRenders[i].lightmapScaleOffset.z, meshRenders[i].lightmapScaleOffset.w);               
                //}
                //uvList2.Add(uvList2Array);

            }

            MeshRenderer mr = go.AddComponent<MeshRenderer>();
            MeshFilter mf = go.AddComponent<MeshFilter>();
            mf.sharedMesh = new Mesh();
            mf.sharedMesh.name = CombineName;
            mf.sharedMesh.CombineMeshes(combine.ToArray(), false);
            //mf.sharedMesh.uv2 = uvList2.ToArray();

            gameObject.SetActive(true);
            mr.sharedMaterials = mats.ToArray();
            go.transform.parent = gameObject.transform;

            //====
            mr.lightmapIndex = 0;
            mr.lightmapScaleOffset = new Vector4(1, 1, 0, 0);
            go.isStatic = true;
            //=====

            savePrefabs = true;
            saveMesh = true;
            saveMaterials = false;
            saveTextures = false;
            //Save(go);
        }


        //1.实现多个Mesh合并为一个Mesh的多维材质
        public void CombineBasicMesh()
        {
           

            List<MeshRenderer> meshRenders = new List<MeshRenderer>(); 
            foreach (var CombineMesh in CombineMeshs)
            {
                meshRenders.Add(CombineMesh.GetComponent<MeshRenderer>());
            }
          
            List<Material> mats = new List<Material>();
            //Vector2 Lightuv2 = new Vector2();
            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
            List<CombineInstance> combine = new List<CombineInstance>();
            GameObject go = new GameObject();
            go.name = CombineName;

            for (int i = 0; i < meshRenders.Count; i++)
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

                        //Vector2 uvscale = new Vector2(com.lightmapScaleOffset.x, com.lightmapScaleOffset.y);
                        //Vector2 uvoffset = new Vector2(com.lightmapScaleOffset.z, com.lightmapScaleOffset.w);
 

                        CombineInstance comcom = new CombineInstance();
                        comcom.mesh = mm;  
                        
                        comcom.transform = go.transform.localToWorldMatrix;
                        combine[t] = comcom;

                        continue;
                    }
                   // com.lightmapScaleOffset = meshRenders[i].lightmapScaleOffset;
                    combine.Add(com);
                    mats.Add(meshRenders[i].sharedMaterials[j]);
                }

                //meshFilters[i].gameObject.SetActive(false);
            }



            MeshRenderer mr = go.AddComponent<MeshRenderer>();
            MeshFilter mf = go.AddComponent<MeshFilter>();
            mf.sharedMesh = new Mesh();
            mf.sharedMesh.name = CombineName;
            mf.sharedMesh.CombineMeshes(combine.ToArray(), false);

            gameObject.SetActive(true);
            mr.sharedMaterials = mats.ToArray();
            go.transform.parent = gameObject.transform;

            //====
            mr.lightmapIndex = 0;
            mr.lightmapScaleOffset = new Vector4(1, 1, 0, 0);
            go.isStatic = true;
            //=====

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

        public void CombineBasicSkinnedMesh()
        {
 
            SkinnedMeshRenderer[] skinmeshRenders = GetComponentsInChildren<SkinnedMeshRenderer>();
            List<Material> mats = new List<Material>();
            List<CombineInstance> combine = new List<CombineInstance>();

            List<Transform> bones = new List<Transform>();
            Transform[] transforms = GetComponentsInChildren<Transform>();

            GameObject go = new GameObject();
            go.name = CombineName;

            for (int i = 0; i < skinmeshRenders.Length; i++)
            {
                SkinnedMeshRenderer temp = skinmeshRenders[i];
                for (int j = 0; j < temp.sharedMaterials.Length; j++)
                {
                    CombineInstance com = new CombineInstance();
                    com.mesh = temp.sharedMesh;
                    com.subMeshIndex = j;
                    com.transform = temp.transform.localToWorldMatrix;
                    //com.transform = temp.transform.localToWorldMatrix* transform.worldToLocalMatrix;
                    //取得temp相对应名称的骨骼列表 
                    int startBoneIndex = bones.Count;
                    foreach (Transform t in temp.bones)
                    {
                        foreach (Transform transform in transforms)
                        {
                            if (transform.name != t.name)
                                continue;
                            bones.Add(transform);
                            break;
                        }
                    }

                    //子网格
                    int endBoneIndex = bones.Count;
                    for (int num = 1; num < temp.sharedMesh.subMeshCount; ++num)
                    {
                        for (int jj = startBoneIndex; jj < endBoneIndex; ++jj)
                        {
                            bones.Add(bones[jj]);
                        }
                    }

                    ////判断相同材质公用
                    //if (mats.Contains(temp.sharedMaterials[j]))
                    //{
                    //    var t = mats.IndexOf(temp.sharedMaterials[j]);

                    //    CombineInstance[] comM = new CombineInstance[2] { combine.ToArray()[t], com };
                    //    Mesh mm = new Mesh();
                    //    mm.CombineMeshes(comM, true);

                    //    CombineInstance comcom = new CombineInstance();
                    //    comcom.mesh = mm;
                    //    comcom.transform = go.transform.localToWorldMatrix;
                    //    combine[t] = comcom;

                    //    continue;
                    //}

                    combine.Add(com);                  
                    Debug.Log(temp.name+ ":"+ temp.bones.Length);
                    
                    

                    mats.Add(temp.sharedMaterials[j]);
                }

                temp.gameObject.SetActive(false);
            }

            SkinnedMeshRenderer mr = go.AddComponent<SkinnedMeshRenderer>();

            mr.sharedMesh = new Mesh();
            mr.sharedMesh.name = CombineName;
            mr.sharedMesh.CombineMeshes(combine.ToArray(), false);
            gameObject.SetActive(true);
            mr.sharedMaterials = mats.ToArray();

            ////设置Bindposes
            //mr.sharedMesh.bindposes = totalBindPoses;

            //// 设置BoneWeights
            //mr.sharedMesh.boneWeights = totalBoneWeight;

            ////设置bones
            //mr.bones = totalBones;

            mr.bones = bones.ToArray();
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
