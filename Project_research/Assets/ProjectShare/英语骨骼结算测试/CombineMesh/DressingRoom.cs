using System.Collections;
using System.Collections.Generic;
using UnityEngine;


/// <summary>
/// Unity 换装以及合并网格
/// </summary>
[RequireComponent(typeof(SkinnedMeshRenderer))]
public class DressingRoom : MonoBehaviour
{

    /// <summary>
    /// 载入的换装资源，其中包含了所有的可以更换的部位的SkinnedMeshRenderer
    /// </summary>
    GameObject tempAvatar;

    /// <summary>
    /// 加载的骨骼预设，其中包括了所有的骨骼节点
    /// </summary>
    GameObject targetSkeleton;

    /// <summary>
    /// 所有骨骼节点
    /// </summary>
    Transform[] allBones;

    /// <summary>
    /// 将换装资源信息关联到Dictionary
    /// </summary>
    Dictionary<string, Dictionary<string, SkinnedMeshRenderer>> skinData = new Dictionary<string, Dictionary<string, SkinnedMeshRenderer>>();

    /// <summary>
    /// 当前装扮信息关联到Dictionary，用来获取所有展示部位的SkinnedMeshRenderer
    /// </summary>
    Dictionary<string, SkinnedMeshRenderer> skinPerform = new Dictionary<string, SkinnedMeshRenderer>();

    void Start()
    {
        LoadResourse();
        InitData(tempAvatar);
        InitSkin();
    }

    /// <summary>
    /// 加载所需要的资源
    /// </summary>
    void LoadResourse()
    {
        tempAvatar = Instantiate(Resources.Load("FemaleSource")) as GameObject;
        tempAvatar.SetActive(false);
        targetSkeleton = Instantiate(Resources.Load("targetmodel")) as GameObject;
        allBones = targetSkeleton.GetComponentsInChildren<Transform>();
    }

    /// <summary>
    /// 1.将加载的资源的信息记录到skinData
    /// 2.为对应的换装部位创建SkinnedMeshRenderer
    /// </summary>
    /// <param name="avata"></param>
    void InitData(GameObject avata)
    {
        if (avata == null)
        {
            return;
        }
        SkinnedMeshRenderer[] skins = tempAvatar.GetComponentsInChildren<SkinnedMeshRenderer>();
        for (int i = 0; i < skins.Length; i++)
        {
            // 此处命名示例 : hair-03
            string[] str = skins[i].name.Split('-');
            if (!skinData.ContainsKey(str[0]))
            {
                skinData.Add(str[0], new Dictionary<string, SkinnedMeshRenderer>());
                GameObject part = new GameObject();
                part.name = str[0];
                // 将SkinnedMeshRenderer父对象设置为骨骼根节点
                part.transform.parent = targetSkeleton.transform;
                // 修改坐标和旋转角度
                part.transform.localPosition = skins[i].transform.localPosition;
                part.transform.localRotation = skins[i].transform.localRotation;
                // 添加关联到skinPerform
                skinPerform.Add(str[0], part.AddComponent<SkinnedMeshRenderer>());
            }
            // 添加关联到skinData
            skinData[str[0]].Add(str[1], skins[i]);
        }
    }

    /// <summary>
    /// 初始化默认的一套装扮
    /// </summary>
    void InitSkin()
    {
        ChangeMesh("coat", "003");
        ChangeMesh("head", "003");
        ChangeMesh("hair", "003");
        ChangeMesh("pant", "003");
        ChangeMesh("foot", "003");
        ChangeMesh("hand", "003");
        CombineMesh();
    }

    /// <summary>
    /// 修改局部的SkinnedMeshRenderer来达到换装目的
    /// </summary>
    /// <param name="type">部位</param>
    /// <param name="model">型号</param>
    void ChangeMesh(string type, string model)
    {
        SkinnedMeshRenderer sm = skinData[type][model];
        // 新替换的部件的所需要的骨骼节点
        List<Transform> bones = new List<Transform>();
        for (int i = 0; i < sm.bones.Length; i++)
        {
            for (int j = 0; j < allBones.Length; j++)
            {
                if (sm.bones[i].name == allBones[j].name)
                {
                    bones.Add(allBones[j]);
                }
            }
        }
        // 更改网格
        skinPerform[type].sharedMesh = sm.sharedMesh;
        // 更改骨骼
        skinPerform[type].bones = bones.ToArray();
        // 更改材质
        skinPerform[type].materials = sm.materials;
    }

    /// <summary>
    /// 合并展示用的所用的SkinnedMeshRenderer，最终使用一个进行渲染
    /// </summary>
    void CombineMesh()
    {
        List<CombineInstance> combineInstances = new List<CombineInstance>();
        List<Material> materials = new List<Material>();
        List<Transform> bones = new List<Transform>();
        // 遍历所有展示的SkinnedMeshRenderer
        foreach (SkinnedMeshRenderer smr in skinPerform.Values)
        {
            // 按顺序添加材质
            materials.AddRange(smr.materials);
            // 处理SubMesh
            // 1. SubMesh会对应同样的shareMesh
            // 2. SubMesh添加骨骼节点时会添加同样的骨骼节点到数组中
            // 3. 关键的是subMeshIndex用来标注当前是第几个SubMesh，对应需要使用的Material
            // 4. 一个Mesh有多少Sub Mesh可以在Mesh资源的Inspector窗口下发显示模型三角形和顶点数的地方显示
            for (int sub = 0; sub < smr.sharedMesh.subMeshCount; sub++)
            {
                CombineInstance ci = new CombineInstance();
                ci.mesh = smr.sharedMesh;
                // subMeshIndex属性用于指向待合并的SubMesh
                // 会根据这个属性去寻找需要使用的材质的下标
                // 要保证材质，骨骼的添加顺序是跟这个值的顺序是一致的
                ci.subMeshIndex = sub;
                // 
                combineInstances.Add(ci);
                // 
                for (int j = 0; j < smr.bones.Length; j++)
                {
                    for (int k = 0; k < allBones.Length; k++)
                    {
                        if (smr.bones[j].name == allBones[k].name)
                        {
                            bones.Add(allBones[k]);
                            break;
                        }
                    }
                }
            }
            // 旧的SkinnedMeshRenderer可以隐藏或者删除
            // smr.gameObject.SetActive(false);
            DestroyImmediate(smr.gameObject);
        }
        SkinnedMeshRenderer main = gameObject.GetComponent<SkinnedMeshRenderer>();
        main.sharedMesh = new Mesh();
        // CombineMeshes第三个参数表示使用应用CombineInstance的Transform变换
        // 这里并没有设置所以填false
        main.sharedMesh.CombineMeshes(combineInstances.ToArray(), false, false);
        main.bones = bones.ToArray();
        main.materials = materials.ToArray();
    }
}
