//=======================================================
// 作者：xuefei
// 描述：1.选择地块，随机赋予材质，2.选择格子数新建随机材质地形
//=======================================================
#if UNITY_EDITOR
using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;
using System.Linq;

namespace Babybus.Tiyong.English
{
    public class RandomMaterial : EditorWindow
    {

        int toolbarInt = 0;
        string[] toolbarStrings = new string[] { "地块随机材质", "新建地块" };

        //随机材质========================================
        #region
        [SerializeField]
        protected List<RmaterialItem> Rmaterials = new List<RmaterialItem>();

        [System.Serializable]
        public class RmaterialItem
        {
            [SerializeField]
            public Material Rmaterial;
            [SerializeField]
            public int Weightmaterial;
     
        }
        //序列化对象
        protected SerializedObject _serializedMaterial;
        //序列化属性
        protected SerializedProperty _MaterialassetLstProperty;
        #endregion
        //===========================================
        int[] weights;

        //新建地块
        #region
        public int GridWidth = 10;
        public int GridHeight = 8;
        private bool isRandomcreate = false;
        private bool isDebug = false;
        private float Randomnum = 1f;

        [SerializeField]
        private float _relief = 15f;

        [SerializeField]
        protected List<RobjectItem> Robjects = new List<RobjectItem>();

        [System.Serializable]
        public class RobjectItem
        {
            [SerializeField]
            public GameObject Robject;
            [SerializeField]
            public int Weightobject;
            [SerializeField]
            public bool Judgerotate = false;

        }

        //序列化对象
        protected SerializedObject _serializedobject;
 
        //序列化属性
        protected SerializedProperty _objectassetLstProperty;
        #endregion
        //===========================================


        [MenuItem("Tools/地块随机")]
        public static void ShowWindow()
        {
            EditorWindow editorWindow = EditorWindow.GetWindow(typeof(RandomMaterial));
            editorWindow.autoRepaintOnSceneChange = true;
            editorWindow.Show();
            editorWindow.titleContent.text = "地块随机";
        }

        void OnEnable()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
            SceneView.onSceneGUIDelegate += this.OnSceneGUI;
            //使用当前类初始化
            _serializedMaterial = new SerializedObject(this);
            //获取当前类中可序列话的属性
            _MaterialassetLstProperty = _serializedMaterial.FindProperty("Rmaterials");
            

            _serializedobject = new SerializedObject(this);       
            _objectassetLstProperty = _serializedobject.FindProperty("Robjects");
			

        }
        void OnDestroy()
        {
            SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
        }

        void OnSceneGUI(SceneView sceneView)
        {

        }
        private void OnGUI()
        {
            GUILayout.Space(10f);
            toolbarInt = GUILayout.Toolbar(toolbarInt, toolbarStrings);
            switch (toolbarInt)
            {
                case 0:
                    GUILayout.BeginVertical("box", GUILayout.Width(400));
                    GUILayout.Label("地块随机材质");

                    //更新
                    _serializedMaterial.Update();
                    //开始检查是否有修改
                    EditorGUI.BeginChangeCheck();
                    //显示属性
                    //第二个参数必须为true，否则无法显示子节点即List内容
                    EditorGUILayout.PropertyField(_MaterialassetLstProperty, true);

                    //结束检查是否有修改
                    if (EditorGUI.EndChangeCheck())
                    {//提交修改
                        _serializedMaterial.ApplyModifiedProperties();     
                        weights = new int[Rmaterials.Count];
                        for (int i = 0; i < Rmaterials.Count; i++)
                        {
                            weights[i] = Rmaterials[i].Weightmaterial;
                        }

                    }

                    if (GUILayout.Button("随机材质"))
                    {
                        Randommaterial();
                    }
                   
                    break;
                case 1:
                    GUILayout.BeginVertical("box", GUILayout.Width(400));
                    GUILayout.Label("新建地块");

                    GridWidth = EditorGUILayout.IntField("横排格子数", GridWidth);
                    GridHeight = EditorGUILayout.IntField("竖排格子数", GridHeight);
                    isDebug = EditorGUILayout.Toggle("调试模式删除旧地形", isDebug);
                    isRandomcreate = EditorGUILayout.Toggle("是否不规则创建格子", isRandomcreate);
                    if (isRandomcreate)
                    {
                        Randomnum = EditorGUILayout.Slider("变化程度", Randomnum, 0.4f, 0.8f);
                        _relief = EditorGUILayout.Slider("生成变化因子", _relief, 0.01f, 15f);
                    }                   
                    _serializedobject.Update();   
                    EditorGUI.BeginChangeCheck();                  
                    EditorGUILayout.PropertyField(_objectassetLstProperty, true);
                    if (EditorGUI.EndChangeCheck())
                    {
                        _serializedobject.ApplyModifiedProperties();
                        weights = new int[Robjects.Count];
                        for (int i = 0; i < Robjects.Count; i++)
                        {
                            weights[i] = Robjects[i].Weightobject;
                        }

                    }
                    if (GUILayout.Button("新建地块"))
                    {
                        Randomobject();
                    }
                    break;


            }
        }

        //随机材质
        private void Randommaterial()
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
                        go.gameObject.GetComponent<MeshRenderer>().sharedMaterial = Rmaterials[RandomByWeight(weights)].Rmaterial;
                    }
                        
                }

            }
                
        }

        private float _seedX, _seedZ;
        private bool Del =false;
        //[SerializeField]
       // private float _mapSize = 1f;
        private void Randomobject()
        {
            if (Robjects.Count!=0)
            {
                float len = Robjects[0].Robject.GetComponent<MeshFilter>().sharedMesh.bounds.size.x;
                if (isDebug)
                {
                    DestroyImmediate(GameObject.Find("地块"));
                }
                GameObject go = new GameObject("地块");
                go.transform.localPosition = new Vector3(GridWidth * len / 2, 0, GridHeight * len / 2);
                //go.transform.localScale = new Vector3(_mapSize, _mapSize, _mapSize);

                _seedX = Random.value * 100f;
                _seedZ = Random.value * 100f;

                for (float x = 0; x < GridWidth* len; x += len)
                {
                    for (float z = 0; z < GridHeight* len; z += len)
                    {
                        int weig = RandomByWeight(weights);
                        GameObject plot = Instantiate(Robjects[weig].Robject);                        
                        plot.transform.localPosition = new Vector3(x + len / 2, 0, z + len / 2);
                        if (Robjects[weig].Judgerotate)
                        {
                            plot.transform.Rotate(new Vector3(0, 90 * Random.Range(0, 3), 0));
                        }

                        plot.transform.SetParent(go.transform);
                        SetY(plot);
                        Debug.Log(Del);
                        if (Del)
                        {
                            DestroyImmediate(plot);
                            Del = false;
                        }

                    }

                }
                go.transform.localPosition = Vector3.zero;
                go.transform.localScale = Vector3.one;
                go.transform.localEulerAngles = Vector3.zero;
            }
            else
            {
                Debug.Log("请设置需要生成地块预制体");
            }

        }
       
        private void SetY(GameObject plot)
        {
            float y = 0;
            float lenY = Robjects[0].Robject.GetComponent<MeshFilter>().sharedMesh.bounds.size.y;
           // Debug.Log(lenY);
            if (isRandomcreate)
                
            {
                float xSample = (plot.transform.localPosition.x + _seedX) / _relief;
                float zSample = (plot.transform.localPosition.z + _seedZ) / _relief;
                float noise = Mathf.PerlinNoise(xSample, zSample);
               // Debug.Log(noise);
                if (noise > Randomnum)
                {
                    //y = lenY;
                    //y = 1;
                    Del =true;
                }            
            }
            plot.transform.localPosition = new Vector3(plot.transform.localPosition.x, y, plot.transform.localPosition.z);
        }
        /// <summary>
        /// 权重随机
        /// </summary>
        /// <param name="weights"></param>
        /// <returns>索引</returns>
        public static int RandomByWeight(int[] weights)
        {
            var sum = weights.Sum();
            var numberRand = UnityEngine.Random.Range(1, sum + 1);
            var sumTemp = 0;
            for (var i = 0; i < weights.Length; i++)
            {
                sumTemp += weights[i];
                if (numberRand <= sumTemp)
                {
                    return i;
                }
            }

            //全是0则随机返回一个
            return UnityEngine.Random.Range(0, weights.Length);
        }

    }
}
#endif