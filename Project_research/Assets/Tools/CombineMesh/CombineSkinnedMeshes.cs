

using UnityEngine;
using System.Collections;


public class CombineSkinnedMeshes : MonoBehaviour
{

    /// Usually rendering with triangle strips is faster.
    /// However when combining objects with very low triangle counts, it can be faster to use triangles.
    /// Best is to try out which value is faster in practice.
    public bool castShadows = true;
    public bool receiveShadows = true;

    /* This is for very particular use, you must set it regarding to your Character */
    public static int VERTEX_NUMBER ; //The number of vertices total of the character
    public static int BONE_NUMBER ;     //The number of bones total

    // Use this for initialization
    void Start()
    {

        //Getting all Skinned Renderer from Children
        Component[] allsmr = GetComponentsInChildren(typeof(SkinnedMeshRenderer));
        Matrix4x4 myTransform = transform.worldToLocalMatrix;

        //The hash with the all bones references: it will be used for set up the BoneWeight Indexes
        Hashtable boneHash = new Hashtable();

        /* If you want make a counter in order to get the total of Vertices and Bones do it here ... */

        //The Sum of All Child Bones
        Transform[] totalBones = new Transform[BONE_NUMBER];//Total of Bones for my Example
                                                            //The Sum of the BindPoses
        Matrix4x4[] totalBindPoses = new Matrix4x4[BONE_NUMBER];//Total of BindPoses
                                                                //The Sum of BoneWeights
        BoneWeight[] totalBoneWeight = new BoneWeight[VERTEX_NUMBER];//total of Vertices for my Example

        int offset = 0;
        int b_offset = 0;
        Transform[] usedBones = new Transform[totalBones.Length];

        ArrayList myInstances = new ArrayList();

        //Setting my Arrays for copies		
        ArrayList myMaterials = new ArrayList();

        for (int i = 0; i < allsmr.Length; i++)
        {
            //Getting one by one
            SkinnedMeshRenderer smrenderer = (SkinnedMeshRenderer)allsmr[i];
            //Making changes to the Skinned Renderer
            //SkinMeshCombineUtility.MeshInstance instance = new SkinMeshCombineUtility.MeshInstance();

            //Setting the Mesh for the instance
            //instance.mesh = smrenderer.sharedMesh;

            //Getting All Materials
            for (int t = 0; t < smrenderer.sharedMaterials.Length; t++)
            {
                myMaterials.Add(smrenderer.sharedMaterials[t]);
            }

            if (smrenderer != null && smrenderer.enabled /*&& instance.mesh != null*/)
            {

                //instance.transform = myTransform * smrenderer.transform.localToWorldMatrix;

                //Material == null
                smrenderer.sharedMaterials = new Material[1];

                //Getting  subMesh
                //for (int t = 0; t < smrenderer.sharedMesh.subMeshCount; t++)
                //{
                //    instance.subMeshIndex = t;
                //    myInstances.Add(instance);
                //}

                //Copying Bones
                for (int x = 0; x < smrenderer.bones.Length; x++)
                {

                    bool flag = false;
                    for (int j = 0; j < totalBones.Length; j++)
                    {
                        if (usedBones[j] != null)
                            //If the bone was already inserted
                            if ((smrenderer.bones[x] == usedBones[j]))
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
                            //Insert bone at the firs free position
                            if (usedBones[f] == null)
                            {
                                usedBones[f] = smrenderer.bones[x];
                                break;
                            }
                        }
                        //inserting bones in totalBones
                        totalBones[offset] = smrenderer.bones[x];
                        //Reference HashTable
                        boneHash.Add(smrenderer.bones[x].name, offset);

                        //Recalculating BindPoses
                        //totalBindPoses[offset] = smrenderer.sharedMesh.bindposes[x] ;						
                        totalBindPoses[offset] = smrenderer.bones[x].worldToLocalMatrix * transform.localToWorldMatrix;
                        offset++;
                    }
                }

                //RecalculateBoneWeights
                for (int x = 0; x < smrenderer.sharedMesh.boneWeights.Length; x++)
                {
                    //Just Copying and changing the Bones Indexes !!						
                    totalBoneWeight[b_offset] = recalculateIndexes(smrenderer.sharedMesh.boneWeights[x], boneHash, smrenderer.bones);
                    b_offset++;
                }
                //Disabling current SkinnedMeshRenderer
                ((SkinnedMeshRenderer)allsmr[i]).enabled = false;
            }
        }

        //SkinMeshCombineUtility.MeshInstance[] instances = (SkinMeshCombineUtility.MeshInstance[])myInstances.ToArray(typeof(SkinMeshCombineUtility.MeshInstance));

        // Make sure we have a SkinnedMeshRenderer
        if (GetComponent(typeof(SkinnedMeshRenderer)) == null)
        {
            gameObject.AddComponent(typeof(SkinnedMeshRenderer));
        }

        //Setting Skinned Renderer
        SkinnedMeshRenderer objRenderer = (SkinnedMeshRenderer)GetComponent(typeof(SkinnedMeshRenderer));
        //Setting Mesh
        //objRenderer.sharedMesh = SkinMeshCombineUtility.Combine(instances);

        objRenderer.castShadows = castShadows;
        objRenderer.receiveShadows = receiveShadows;

        //Setting Bindposes
        objRenderer.sharedMesh.bindposes = totalBindPoses;

        //Setting BoneWeights
        objRenderer.sharedMesh.boneWeights = totalBoneWeight;

        //Setting bones
        objRenderer.bones = totalBones;

        //Setting Materials
        objRenderer.sharedMaterials = (Material[])myMaterials.ToArray(typeof(Material));

        objRenderer.sharedMesh.RecalculateNormals();
        objRenderer.sharedMesh.RecalculateBounds();

        //Enable Mesh
        objRenderer.enabled = true;

        /* 	Debug.Log("############################################");
		Debug.Log("M Materials "+myMaterials.Count);
		Debug.Log("bindPoses "+objRenderer.sharedMesh.bindposes.Length);
		Debug.Log("boneWeights "+objRenderer.sharedMesh.boneWeights.Length);
		Debug.Log("Bones "+objRenderer.bones.Length);
		Debug.Log("Vertices "+objRenderer.sharedMesh.vertices.Length); */

    }

    /* 
	@Description: Revert the order of an array of components
	(NOT USED)
	*/
    static Component[] revertComponent(Component[] comp)
    {
        Component[] result = new Component[comp.Length];
        int x = 0;
        for (int i = comp.Length - 1; i >= 0; i--)
        {
            result[x++] = comp[i];
        }

        return result;
    }

    /* 
	@Description: Setting the Indexes for the new bones	
	*/
    static BoneWeight recalculateIndexes(BoneWeight bw, Hashtable boneHash, Transform[] meshBones)
    {
        BoneWeight retBw = bw;
        retBw.boneIndex0 = (int)boneHash[meshBones[bw.boneIndex0].name];
        retBw.boneIndex1 = (int)boneHash[meshBones[bw.boneIndex1].name];
        retBw.boneIndex2 = (int)boneHash[meshBones[bw.boneIndex2].name];
        retBw.boneIndex3 = (int)boneHash[meshBones[bw.boneIndex3].name];
        return retBw;
    }

    //public List<GameObject> CombineToSkinnedMeshes(List<MeshRenderer> meshRenderers, List<SkinnedMeshRenderer> skinnedMeshRenderers, Transform parent, int combinedIndex)
    //{
    //    // The list of Meshes created
    //    List<GameObject> combinedMeshes = new List<GameObject>();
    //    // The list of combineInstances
    //    CombineInstanceID combineInstances = new CombineInstanceID();

    //    int verticesCount = 0;
    //    int combinedGameObjectCount = 0;

    //    /*
    //    / Skinned mesh parameters
    //    */
    //    // List of bone weight
    //    List<BoneWeight> boneWeights = new List<BoneWeight>();
    //    // List of bones
    //    List<Transform> bones = new List<Transform>();
    //    // List of bindposes
    //    List<Matrix4x4> bindposes = new List<Matrix4x4>();
    //    // List of original bones mapped to their instanceId
    //    Dictionary<int, Transform> originalBones = new Dictionary<int, Transform>();
    //    // Link original bone instanceId to the new created bones
    //    Dictionary<int, Transform> originToNewBoneMap = new Dictionary<int, Transform>();
    //    // The vertices count
    //    int boneOffset = 0;

    //    // Get bones hierarchies from all skinned mesh
    //    for (int i = 0; i < skinnedMeshRenderers.Count; i++)
    //    {
    //        foreach (Transform t in skinnedMeshRenderers[i].bones)
    //        {
    //            if (!originalBones.ContainsKey(t.GetInstanceID()))
    //            {
    //                originalBones.Add(t.GetInstanceID(), t);
    //            }
    //        }
    //    }

    //    // Find the root bones
    //    Transform[] rootBones = FindRootBone(originalBones);
    //    for (int i = 0; i < rootBones.Length; i++)
    //    {
    //        // Instantiate the GameObject parent for this rootBone
    //        GameObject rootBoneParent = new GameObject("rootBone" + i);
    //        rootBoneParent.transform.position = rootBones[i].position;
    //        rootBoneParent.transform.parent = parent;
    //        rootBoneParent.transform.localPosition -= rootBones[i].localPosition;
    //        rootBoneParent.transform.localRotation = Quaternion.identity;

    //        // Instanciate a copy of the root bone
    //        GameObject newRootBone = InstantiateCopy(rootBones[i].gameObject);
    //        newRootBone.transform.position = rootBones[i].position;
    //        newRootBone.transform.rotation = rootBones[i].rotation;
    //        newRootBone.transform.parent = rootBoneParent.transform;
    //        newRootBone.AddComponent<MeshRenderer>();

    //        // Get the correspondancy map between original bones and new bones
    //        GetOrignialToNewBonesCorrespondancy(rootBones[i], newRootBone.transform, originToNewBoneMap);
    //    }

    //    // Copy Animator Controllers to new Combined GameObject
    //    foreach (Animator anim in parent.parent.GetComponentsInChildren<Animator>())
    //    {
    //        Transform[] children = anim.GetComponentsInChildren<Transform>();
    //        // Find the transform into which a copy of the Animator component will be added
    //        Transform t = FindTransformForAnimator(children, rootBones, anim);
    //        if (t != null)
    //        {
    //            CopyAnimator(anim, originToNewBoneMap[t.GetInstanceID()].parent.gameObject);
    //        }
    //    }

    //    for (int i = 0; i < skinnedMeshRenderers.Count; i++)
    //    {
    //        // Get a snapshot of the skinnedMesh renderer 
    //        Mesh mesh = copyMesh(skinnedMeshRenderers[i].sharedMesh, skinnedMeshRenderers[i].GetInstanceID().ToString());
    //        vertexOffset += mesh.vertexCount;

    //        verticesCount += skinnedMeshRenderers[i].sharedMesh.vertexCount;
    //        if (verticesCount > maxVerticesCount && combineInstances.Count() > 0)
    //        {
    //            // Create the new GameObject
    //            GameObject combinedGameObject = CreateCombinedSkinnedMeshGameObject(combineInstances, parent, combinedGameObjectCount, combinedIndex);
    //            // Assign skinnedMesh parameters values
    //            SkinnedMeshRenderer sk = combinedGameObject.GetComponent<SkinnedMeshRenderer>();
    //            AssignParametersToSkinnedMesh(sk, bones, boneWeights, bindposes);
    //            combinedMeshes.Add(combinedGameObject);
    //            boneOffset = 0;

    //            combineInstances.Clear();
    //            combinedGameObjectCount++;
    //            verticesCount = skinnedMeshRenderers[i].sharedMesh.vertexCount;
    //        }


    //        // Copy bone weights
    //        BoneWeight[] meshBoneweight = skinnedMeshRenderers[i].sharedMesh.boneWeights;
    //        foreach (BoneWeight bw in meshBoneweight)
    //        {
    //            BoneWeight bWeight = bw;
    //            bWeight.boneIndex0 += boneOffset;
    //            bWeight.boneIndex1 += boneOffset;
    //            bWeight.boneIndex2 += boneOffset;
    //            bWeight.boneIndex3 += boneOffset;

    //            boneWeights.Add(bWeight);
    //        }
    //        boneOffset += skinnedMeshRenderers[i].bones.Length;

    //        // Copy bones and bindposes
    //        Transform[] meshBones = skinnedMeshRenderers[i].bones;
    //        foreach (Transform bone in meshBones)
    //        {
    //            bones.Add(originToNewBoneMap[bone.GetInstanceID()]);
    //            bindposes.Add(bone.worldToLocalMatrix * parent.transform.localToWorldMatrix);
    //        }

    //        // Create the list of CombineInstance for this skinnedMesh
    //        Matrix4x4 matrix = parent.transform.worldToLocalMatrix * skinnedMeshRenderers[i].transform.localToWorldMatrix;
    //        combineInstances.AddRange(CreateCombinedInstances(mesh, skinnedMeshRenderers[i].sharedMaterials, skinnedMeshRenderers[i].GetInstanceID(), skinnedMeshRenderers[i].gameObject.name, matrix, combinedIndex));
    //    }

    //    if (combineInstances.Count() > 0)
    //    {
    //        // Create the combined GameObject which contains the combined meshes
    //        // Create the new GameObject
    //        GameObject combinedGameObject = CreateCombinedSkinnedMeshGameObject(combineInstances, parent, combinedGameObjectCount, combinedIndex);
    //        // Assign skinnedMesh parameters values
    //        SkinnedMeshRenderer sk = combinedGameObject.GetComponent<SkinnedMeshRenderer>();
    //        AssignParametersToSkinnedMesh(sk, bones, boneWeights, bindposes);
    //        combinedMeshes.Add(combinedGameObject);
    //    }

    //    return combinedMeshes;
    //}
}