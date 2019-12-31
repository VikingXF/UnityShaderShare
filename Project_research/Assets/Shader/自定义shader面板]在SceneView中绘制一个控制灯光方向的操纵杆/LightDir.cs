//=======================================================
// 作者：xuefei
// 描述：[自定义shader面板]在SceneView中绘制一个控制灯光方向的操纵杆
//=======================================================
using UnityEditor;
using UnityEngine;


internal class LightDir : MaterialPropertyDrawer
{
    float height = 16;
    bool isEditor = false;
    bool starEditor = true;
    GameObject selectGameObj;
    public Quaternion rot = Quaternion.identity;

    MaterialProperty m_prop;
    //判断是否为Vector类型
    static bool IsPropertyTypeSuitable(MaterialProperty prop)
    {
        return prop.type == MaterialProperty.PropType.Vector;
    }
    public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
    {
        //如果不是Vector类型，则把unity的默认警告框的高度40
        if (!IsPropertyTypeSuitable(prop))
        {
            return 40f;
        }
        height = EditorGUI.GetPropertyHeight(SerializedPropertyType.Vector3, new GUIContent(label));
        return height;
    }
    public override void OnGUI(Rect position, MaterialProperty prop, string label, MaterialEditor editor)
    {
        //如果不是Vector类型，则显示一个警告框
        if (!IsPropertyTypeSuitable(prop))
        {
            GUIContent c = EditorGUIUtility.TrTextContent("LightDir used on a non-Vector property: " + prop.name, EditorGUIUtility.IconContent("console.erroricon").image);
            EditorGUI.LabelField(position, c, EditorStyles.helpBox);
            return;
        }

        EditorGUI.BeginChangeCheck();

        float oldLabelWidth = EditorGUIUtility.labelWidth;
        EditorGUIUtility.labelWidth = 0f;

        Color oldColor = GUI.color;
        if (isEditor) GUI.color = Color.green;

        //绘制属性
        Rect VectorRect = new Rect(position)
        {
            width = position.width - 68f
        };
        Vector3 value = new Vector3(prop.vectorValue.x, prop.vectorValue.y, prop.vectorValue.z);
        value = EditorGUI.Vector3Field(VectorRect, label, value);

        //绘制开关
        Rect TogglegRect = new Rect(position)
        {
            x = position.xMax - 64f,
            y = (height > 16) ? position.y + 16 : position.y,
            width = 60f,
            height = 16
        };
        isEditor = GUI.Toggle(TogglegRect, isEditor, "Set", "Button");
        if (isEditor)
        {
            if (starEditor)
            {
                m_prop = prop;
                InitSenceGUI(value);
            }
        }
        else
        {
            if (!starEditor)
            {
                ClearSenceGUI();
            }
        }

        GUI.color = oldColor;
        EditorGUIUtility.labelWidth = oldLabelWidth;
        if (EditorGUI.EndChangeCheck())
        {
            prop.vectorValue = new Vector4(value.x, value.y, value.z);
        }

    }
    void InitSenceGUI(Vector3 value)
    {
        Tools.current = Tool.None;
        selectGameObj = Selection.activeGameObject;
        Vector3 worldDir = selectGameObj.transform.rotation * value;
        rot = Quaternion.FromToRotation(Vector3.forward, worldDir);
        SceneView.onSceneGUIDelegate += OnSceneGUI;
        starEditor = false;
    }
    void ClearSenceGUI()
    {
        SceneView.onSceneGUIDelegate -= OnSceneGUI;
        m_prop = null;
        selectGameObj = null;
        starEditor = true;
    }

    void OnSceneGUI(SceneView senceView)
    {
        if (Selection.activeGameObject != selectGameObj)
        {
            ClearSenceGUI();
            isEditor = false;
            return;
        }

        Vector3 pos = selectGameObj.transform.position;

        rot = Handles.RotationHandle(rot, pos);
        Vector3 newlocalDir = Quaternion.Inverse(selectGameObj.transform.rotation) * rot * Vector3.forward;

        m_prop.vectorValue = new Vector4(newlocalDir.x, newlocalDir.y, newlocalDir.z);

        Handles.color = Color.green;
        Handles.ConeHandleCap(0, pos, rot, HandleUtility.GetHandleSize(pos), EventType.Repaint);
    }
}