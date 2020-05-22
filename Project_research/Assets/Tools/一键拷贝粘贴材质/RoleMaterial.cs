//=============================================
//作者:
//描述:
//创建时间:2020/05/22 18:03:28
//版本:v 1.0
//=============================================
#if UNITY_EDITOR
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;

public class RoleMaterial : EditorWindow
{
    int toolbarInt = 0;
    string[] toolbarStrings = new string[] { "角色1", "角色2", "多维材质顺序","复制材质球"};

    //刺猬爸爸
    #region
    public int ciweibabaMaterialCount = 0;
    [SerializeField]
    protected List<Material> ciweibabamaterials ;

    //序列化对象
    protected SerializedObject _serializedciweibabaMaterial;

    //序列化属性
    protected SerializedProperty _ciweibabaMaterialassetLstProperty;
    #endregion


    //奇奇超人
    #region
    public int qiqicrMaterialCount = 0;
    [SerializeField]
    protected List<Material> qiqicrmaterials;

    //序列化对象
    protected SerializedObject _serializedqiqicrMaterial;

    //序列化属性
    protected SerializedProperty _qiqicrMaterialassetLstProperty;
    #endregion

    //多维材质
    #region  
    [SerializeField]
    protected List<Material> submaterials;

    //序列化对象
    protected SerializedObject _serializedsubMaterial;

    //序列化属性
    protected SerializedProperty _subMaterialassetLstProperty;
    #endregion


    //拷贝材质
    #region  
    [SerializeField]
    protected List<Material> copymaterials;

    //序列化对象
    protected SerializedObject _serializedcopyMaterial;

    //序列化属性
    protected SerializedProperty _copyMaterialassetLstProperty;
    #endregion

    [MenuItem("Tools/批量上材质")]
    public static void ShowWindow()
    {
        EditorWindow editorWindow = EditorWindow.GetWindow(typeof(RoleMaterial));
        editorWindow.autoRepaintOnSceneChange = true;
        editorWindow.Show();
        editorWindow.titleContent.text = "批量上材质";
    }

    void OnEnable()
    {
        SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
        SceneView.onSceneGUIDelegate += this.OnSceneGUI;

        //刺猬爸爸
        //使用当前类初始化
        _serializedciweibabaMaterial = new SerializedObject(this);
        //获取当前类中可序列话的属性
        _ciweibabaMaterialassetLstProperty = _serializedciweibabaMaterial.FindProperty("ciweibabamaterials");

        //奇奇超人
        _serializedqiqicrMaterial = new SerializedObject(this);
        _qiqicrMaterialassetLstProperty = _serializedqiqicrMaterial.FindProperty("qiqicrmaterials");

        //多维材质
        _serializedsubMaterial = new SerializedObject(this);
        _subMaterialassetLstProperty = _serializedsubMaterial.FindProperty("submaterials");

        //拷贝材质
        _serializedcopyMaterial = new SerializedObject(this);
        _copyMaterialassetLstProperty = _serializedcopyMaterial.FindProperty("copymaterials");
    }
    void OnDestroy()
    {
        SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
    }

    void OnSceneGUI(SceneView sceneView)
    {

    }

    void OnGUI()
    {
        GUILayout.Space(10f);
        toolbarInt = GUILayout.Toolbar(toolbarInt, toolbarStrings);
        switch (toolbarInt)
        {
            case 0:
                ciweiUI();
                break;
            case 1:
                qiqicrUI();
                break;
            case 2:
                subUI();
                break;
            case 3:
                copyUI();
                break;

        }

    }
    //刺猬爸爸UI
    private void ciweiUI()
    {
        GUILayout.BeginVertical("box", GUILayout.Width(400));
        GUILayout.Label("材质");
        ciweibabaMaterialCount = EditorGUILayout.IntField("材质序号", ciweibabaMaterialCount);
        //更新
        _serializedciweibabaMaterial.Update();
        //开始检查是否有修改
        EditorGUI.BeginChangeCheck();
        //显示属性
        //第二个参数必须为true，否则无法显示子节点即List内容
        EditorGUILayout.PropertyField(_ciweibabaMaterialassetLstProperty, true);

        //结束检查是否有修改
        if (EditorGUI.EndChangeCheck())
        {
            //提交修改
            _serializedciweibabaMaterial.ApplyModifiedProperties();

        }

        if (GUILayout.Button("一键上材质"))
        {
            Covermaterial();
        }
    }
    //奇奇超人UI
    private void qiqicrUI()
    {
        GUILayout.BeginVertical("box", GUILayout.Width(400));
        GUILayout.Label("材质");
        qiqicrMaterialCount = EditorGUILayout.IntField("材质序号", qiqicrMaterialCount);
        //更新
        _serializedqiqicrMaterial.Update();
        //开始检查是否有修改
        EditorGUI.BeginChangeCheck();
        //显示属性
        //第二个参数必须为true，否则无法显示子节点即List内容
        EditorGUILayout.PropertyField(_qiqicrMaterialassetLstProperty, true);

        //结束检查是否有修改
        if (EditorGUI.EndChangeCheck())
        {
            //提交修改
            _serializedqiqicrMaterial.ApplyModifiedProperties();

        }

        if (GUILayout.Button("一键上材质"))
        {
            Covermaterial();
        }
    }

    //多维材质UI
    private void subUI()
    {
        GUILayout.BeginVertical("box", GUILayout.Width(400));
        GUILayout.Label("多维材质");
        //更新
        _serializedsubMaterial.Update();
        //开始检查是否有修改
        EditorGUI.BeginChangeCheck();
        //显示属性
        //第二个参数必须为true，否则无法显示子节点即List内容
        EditorGUILayout.PropertyField(_subMaterialassetLstProperty, true);

        //结束检查是否有修改
        if (EditorGUI.EndChangeCheck())
        {
            //提交修改
            _serializedsubMaterial.ApplyModifiedProperties();

        }

        if (GUILayout.Button("一键上材质"))
        {
            Covermaterial();
        }
    }
    
    //复制材质UI
    private void copyUI()
    {
        GUILayout.BeginVertical("box", GUILayout.Width(400));
        GUILayout.Label("复制材质");
        //更新
        _serializedcopyMaterial.Update();
        //开始检查是否有修改
        EditorGUI.BeginChangeCheck();
        //显示属性
        //第二个参数必须为true，否则无法显示子节点即List内容
        EditorGUILayout.PropertyField(_copyMaterialassetLstProperty, true);

        //结束检查是否有修改
        if (EditorGUI.EndChangeCheck())
        {
            //提交修改
            _serializedcopyMaterial.ApplyModifiedProperties();

        }
        GUILayout.BeginHorizontal();
        if (GUILayout.Button("一键拷贝材质",GUILayout.Height(40)))
        {
            copymaterial();
        }
        if (GUILayout.Button("一键上材质",GUILayout.Height(40)))
        {
            pastematerial();
        }
        GUILayout.EndHorizontal();
       GUILayout.EndVertical();
    }
    //上材质
    private void Covermaterial()
    {
        if (Selection.activeTransform != null)
        {

            var plotobject = Selection.GetFiltered(typeof(GameObject), SelectionMode.Deep);
            GameObject go;
            foreach (var plotobjectitem in plotobject)
            {
                go = plotobjectitem as GameObject;
                if (go.gameObject.GetComponent<MeshRenderer>() != null)
                {
                    int mL = go.gameObject.GetComponent<MeshRenderer>().sharedMaterials.Length;
                    switch (toolbarInt)
                    {
                        case 0:                   
                                                   
                            if (mL> 1)
                            {
                                Material[] materials = new Material[mL];
                                for (int i = 0; i < mL; i++)
                                {

                                    materials[i] = ciweibabamaterials[ciweibabaMaterialCount];                                 
                                }
                                go.gameObject.GetComponent<MeshRenderer>().sharedMaterials = materials;
                            }
                            else
                            {
                               go.gameObject.GetComponent<MeshRenderer>().sharedMaterial = ciweibabamaterials[ciweibabaMaterialCount];
                            }
                            break;
                        case 1:
                            if (mL > 1)
                            {
                                Material[] materials = new Material[mL];
                                for (int i = 0; i < mL; i++)
                                {
                                    
                                    materials[i] = qiqicrmaterials[qiqicrMaterialCount];

                                }
                                go.gameObject.GetComponent<MeshRenderer>().sharedMaterials = materials;
                            }

                            else
                            {
                                go.gameObject.GetComponent<MeshRenderer>().sharedMaterial = qiqicrmaterials[qiqicrMaterialCount];
                            }                               
                            break;
                        case 2:
                            if (mL > 1)
                            {
                                Material[] materials = new Material[mL];
                                for (int i = 0; i < mL; i++)
                                {
                                   
                                    if (submaterials.Count == mL)
                                    {
                                        materials[i] = submaterials[i];
                                    }                                
                                }
                                go.gameObject.GetComponent<MeshRenderer>().sharedMaterials = materials;
                            }

                            else
                            {
                                go.gameObject.GetComponent<MeshRenderer>().sharedMaterial = submaterials[0];
                            }
                            break;
                    }
                   
                }

            }

        }

    }

    //拷贝材质
    private void copymaterial()
    {
        if (Selection.activeTransform != null)
        {

            copymaterials = new List<Material>();
            //Debug.Log(Selection.activeTransform.name);
            Transform[] father = Selection.activeTransform.GetComponentsInChildren<Transform>();
            foreach (var child in father)
            {
                if (child.GetComponent<MeshRenderer>() != null)
                {
                    int mL = child.GetComponent<MeshRenderer>().sharedMaterials.Length;
                    if (mL > 1)
                    {
                        for (int i = 0; i < mL; i++)
                        {
                            copymaterials.Add(child.GetComponent<MeshRenderer>().sharedMaterials[i]);

                        }
                    }
                    else
                    {
                        copymaterials.Add(child.GetComponent<MeshRenderer>().sharedMaterial);

                    }                 
                }
               
            }

            //var plotobject = Selection.GetFiltered(typeof(GameObject), SelectionMode.Deep);
            //List<Object> gos = new List<Object>(plotobject);

            //gos.Sort(delegate (Object p1, Object p2)
            //{
            //    GameObject go1 = p1 as GameObject;
            //    GameObject go2 = p2 as GameObject;

            //    return go1.transform.GetSiblingIndex() - go2.transform.GetSiblingIndex();
            //});

            //GameObject go;
            //foreach (var plotobjectitem in plotobject)
            //{               
            //    go = plotobjectitem as GameObject;
            //    //Debug.Log(go.name);
            //    //Debug.Log(go.transform.GetSiblingIndex());
            //    if (go.gameObject.GetComponent<MeshRenderer>() != null)
            //    {
            //        int mL = go.gameObject.GetComponent<MeshRenderer>().sharedMaterials.Length;
            //        if (mL > 1)
            //        {
            //            for (int i = 0; i < mL; i++)
            //            {
            //                copymaterials.Add(go.gameObject.GetComponent<MeshRenderer>().sharedMaterials[i]);

            //            }                       
            //        }
            //        else
            //        {
            //            copymaterials.Add(go.gameObject.GetComponent<MeshRenderer>().sharedMaterial);

            //        }

            //    }
            //}
        }
    }
    private void pastematerial()
    {
        if (Selection.activeTransform != null)
        {            
            int k = 0;
            Transform[] father = Selection.activeTransform.GetComponentsInChildren<Transform>();
            foreach (var child in father)
            {
                if (child.GetComponent<MeshRenderer>() != null)
                {
                    int mL = child.GetComponent<MeshRenderer>().sharedMaterials.Length;
                    if (mL > 1)
                    {

                        Material[] materials = new Material[mL];
                        for (int i = 0; i < mL; i++)
                        {                         
                            materials[i] = copymaterials[k];
                            k++;
                        }
                        child.GetComponent<MeshRenderer>().sharedMaterials = materials;
                    }
                    else
                    {
                        child.GetComponent<MeshRenderer>().sharedMaterial = copymaterials[k];
                        k++;
                    }
                }

            }

            //var plotobject = Selection.GetFiltered(typeof(GameObject), SelectionMode.Deep);
            //List<Object> gos = new List<Object>(plotobject);
            //gos.Sort(delegate (Object p1, Object p2)
            //{
            //    GameObject go1 = p1 as GameObject;
            //    GameObject go2 = p2 as GameObject;
            //    return go1.transform.GetSiblingIndex() - go2.transform.GetSiblingIndex();
            //});
            //GameObject go;
            //Debug.Log(copymaterials.Count);
            
            //foreach (var plotobjectitem in plotobject)
            //{
            //    //Debug.Log(k);
            //    go = plotobjectitem as GameObject;
            //    if (go.gameObject.GetComponent<MeshRenderer>() != null)
            //    {
            //        int mL = go.gameObject.GetComponent<MeshRenderer>().sharedMaterials.Length;
            //        if (mL > 1)
            //        {
                       
            //            Material[] materials = new Material[mL];
            //            for (int i = 0; i < mL; i++)
            //            {
            //                //Debug.Log("===============");
            //                materials[i] = copymaterials[k];
            //                k++;
            //            }
            //            go.gameObject.GetComponent<MeshRenderer>().sharedMaterials = materials;
            //        }
            //        else
            //        {
            //            go.gameObject.GetComponent<MeshRenderer>().sharedMaterial = copymaterials[k];
            //            k++;
            //        }

                   
                    
            //    }
            //}
        }
    }
}
#endif