//=============================================
//作者:
//描述:
//创建时间:2020/04/15 08:37:58
//版本:v 1.0
//=============================================
using UnityEngine;
using System.Collections;
using UnityEditor;
[ExecuteInEditMode]
//定制Serializable类的每个实例的GUI
[CustomPropertyDrawer(typeof(Time_all))]
public class CharacterDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        //创建一个属性包装器，用于将常规GUI控件与SerializedProperty一起使用
        using (new EditorGUI.PropertyScope(position, label, property))
        {
            //设置属性名宽度 Name HP
            EditorGUIUtility.labelWidth = 60;
            //输入框高度，默认一行的高度
            position.height = EditorGUIUtility.singleLineHeight;

            //gameObj位置矩形
            Rect gameObj = new Rect(position)
            {
                width = 160,
                height = 20
            };

            Rect Start = new Rect(position)
            {
                width = 100,    //减去icon的width 64
                x = position.x + 162             //在icon的基础上右移64
            };

            Rect Starting = new Rect(Start)
            {
                y = Start.y + EditorGUIUtility.singleLineHeight + 2

            };
            Rect Miding = new Rect(Starting)
            {
                //在name的基础上，y坐标下移
                y = Starting.y + EditorGUIUtility.singleLineHeight + 2
            };

            Rect Ending = new Rect(Miding)
            {
                //在hp的基础上，y坐标下移
                y = Miding.y + EditorGUIUtility.singleLineHeight + 2
            };

            //找到每个属性的序列化值
            SerializedProperty gameObjProperty = property.FindPropertyRelative("gameObj");
            SerializedProperty startProperty = property.FindPropertyRelative("Start");
            SerializedProperty startingProperty = property.FindPropertyRelative("Starting");
            SerializedProperty MidProperty = property.FindPropertyRelative("Miding");
            SerializedProperty EndProperty = property.FindPropertyRelative("Ending");
            // SerializedProperty weaponProperty = property.FindPropertyRelative("weapon");

            //绘制icon
            gameObjProperty.objectReferenceValue = EditorGUI.ObjectField(gameObj, gameObjProperty.objectReferenceValue, typeof(GameObject), true);
            startProperty.floatValue = EditorGUI.FloatField(Start, "Start", startProperty.floatValue);
            startingProperty.floatValue = EditorGUI.FloatField(Starting, "Starting", startingProperty.floatValue);
            MidProperty.floatValue = EditorGUI.FloatField(Miding, "Miding", MidProperty.floatValue);
            EndProperty.floatValue = EditorGUI.FloatField(Ending, "Ending", EndProperty.floatValue);

        }
    }
}