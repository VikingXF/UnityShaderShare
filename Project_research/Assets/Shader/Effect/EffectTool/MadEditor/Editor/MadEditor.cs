using UnityEngine;
using UnityEditor;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace MAD
{
	public class MadEditor : Editor
	{
		private Type _targetType;

		private List<FieldInfo> _fieldList;
		private List<PropertyInfo> _propertyList;
		private List<MethodInfo> _methodList;

		private List<KeyValuePair<PropertyInfo, Attribute>> _showPropertyAttrList;
		private List<KeyValuePair<MethodInfo, Attribute>> _buttonMethodAttrList;
		private Dictionary<MemberInfo, Attribute> _groupMemberAttrDic;

		private void Init()
		{
			_targetType = target.GetType();

			// 获取各种 MemberInfo
			{
				// 获取所有可显示的 Field
				_fieldList = new List<FieldInfo>();
				SerializedProperty property = serializedObject.GetIterator();
				property.NextVisible(true); // 跳过 m_Script
				while (property.NextVisible(false))
				{
					FieldInfo fi = _targetType.GetField(property.name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
					if (fi != null)
					{
						_fieldList.Add(fi);
					}
				}

				// 获取所有 Property
				_propertyList = new List<PropertyInfo>(_targetType.GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance));
				// 获取所有 Method
				_methodList = new List<MethodInfo>(_targetType.GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static));
			}

			// 遍历各种 MemberInfo
			{
				_groupMemberAttrDic = new Dictionary<MemberInfo, Attribute>();
				_showPropertyAttrList = new List<KeyValuePair<PropertyInfo, Attribute>>();
				_buttonMethodAttrList = new List<KeyValuePair<MethodInfo, Attribute>>();

				// 遍历 Field
				foreach (var fi in _fieldList)
				{
					// 检查 GroupAttribute
					if (fi.IsDefined(typeof(GroupAttribute), false))
					{
						_groupMemberAttrDic.Add(fi, fi.GetCustomAttributes(typeof(GroupAttribute), false)[0] as GroupAttribute);
					}
				}
				// 遍历 Property
				foreach (var pi in _propertyList)
				{
					// 检查 ShowPropertyAttribute
					if (pi.IsDefined(typeof(ShowPropertyAttribute), false))
					{
						_showPropertyAttrList.Add(new KeyValuePair<PropertyInfo, Attribute>(pi, pi.GetCustomAttributes(typeof(ShowPropertyAttribute), false)[0] as ShowPropertyAttribute));
						// 检查 GroupAttribute
						if (pi.IsDefined(typeof(GroupAttribute), false))
						{
							_groupMemberAttrDic.Add(pi, pi.GetCustomAttributes(typeof(GroupAttribute), false)[0] as GroupAttribute);
						}
					}
				}
				// 遍历 Method
				foreach (var mi in _methodList)
				{
					// 检查 ButtonAttribute
					if (mi.IsDefined(typeof(ButtonAttribute), false))
					{
						_buttonMethodAttrList.Add(new KeyValuePair<MethodInfo, Attribute>(mi, mi.GetCustomAttributes(typeof(ButtonAttribute), false)[0] as ButtonAttribute));
						// 检查 GroupAttribute
						if (mi.IsDefined(typeof(GroupAttribute), false))
						{
							_groupMemberAttrDic.Add(mi, mi.GetCustomAttributes(typeof(GroupAttribute), false)[0] as GroupAttribute);
						}
					}
				}
			}
		}

		public override void OnInspectorGUI()
		{
			if (_targetType == null) Init();
			DrawCommonInspector();
			DrawExtraInspector();
		}
		
		public virtual bool DrawCommonInspector()
		{
			EditorGUI.BeginChangeCheck();
			serializedObject.Update();

			SerializedProperty spScript = serializedObject.FindProperty("m_Script");
			if (spScript != null)
			{
				using (new EditorGUI.DisabledScope(true))
				{
					EditorGUILayout.PropertyField(spScript, true);
				}
			}
			
			bool inGroup = false;
			for (int i = 0; i < _fieldList.Count; i++)
			{
				FieldInfo fi = _fieldList[i];

				SerializedProperty sp = serializedObject.FindProperty(fi.Name);

				GroupAttribute ga = GetGroupAttrByMemberName(sp.propertyPath);
				if (ga != null && ga.State != GroupAttribute.EState.EndGroup)
				{
					if (inGroup)
					{
						GUILayout.EndVertical();
						inGroup = false;
					}
					DrawGroupHeader(ga);
					inGroup = DrawGroupContentBg(ga);
				}

				EditorGUILayout.PropertyField(sp, true);

				if (ga != null && ga.State != GroupAttribute.EState.StartGroup)
				{
					GUILayout.EndVertical();
					inGroup = false;
				}
			}
			if (inGroup)
			{
				GUILayout.EndVertical();
				inGroup = false;
			}

			serializedObject.ApplyModifiedProperties();
			return EditorGUI.EndChangeCheck();
		}

		public virtual void DrawExtraInspector()
		{
			// 1. 显示属性
			DrawShowProperties();
			// 2. 显示方法按钮
			DrawMethodButtons();
		}

		private void DrawShowProperties()
		{
			// 不支持多选
			if (targets.Length != 1) return;

			// Draw Head
			if (_showPropertyAttrList.Count > 0)
			{
				GUILayout.BeginHorizontal();
				{
					GUILayout.Label("", GS.gsSpliterLine);
					GUILayout.Button("Property", GS.gsSpliterText);
					GUILayout.Label("", GS.gsSpliterLine);
				}
				GUILayout.EndHorizontal();
			}

			bool inGroup = false;
			for (int i = 0; i < _showPropertyAttrList.Count; i++)
			{
				KeyValuePair<PropertyInfo, Attribute> pair = _showPropertyAttrList[i];
				PropertyInfo info = pair.Key;
				ShowPropertyAttribute attr = pair.Value as ShowPropertyAttribute;

				GroupAttribute ga = (_groupMemberAttrDic.ContainsKey(info) ? _groupMemberAttrDic[info] : null) as GroupAttribute;
				if (ga != null && ga.State != GroupAttribute.EState.EndGroup)
				{
					if (inGroup)
					{
						GUILayout.EndVertical();
						inGroup = false;
					}
					DrawGroupHeader(ga);
					inGroup = DrawGroupContentBg(ga);
				}

				if (attr.ValueType == ShowPropertyAttribute.EValueType.Enum)
				{
					if (info.CanRead)
					{
						object rawValue = info.GetValue(target, null);
						if (rawValue is Enum)
						{
							Enum value = (Enum)rawValue;
							Enum newValue = EditorGUILayout.EnumPopup(info.Name, value);
							if (info.CanWrite && value != newValue)
							{
								info.SetValue(target, newValue, null);
							}
						}
					}
				}
				else if (attr.ValueType == ShowPropertyAttribute.EValueType.Bool)
				{
					if (info.CanRead)
					{
						object rawValue = info.GetValue(target, null);
						if (rawValue is bool)
						{
							bool value = (bool)rawValue;
							bool newValue = EditorGUILayout.Toggle(info.Name, value);
							if (info.CanWrite && value != newValue)
							{
								info.SetValue(target, newValue, null);
							}
						}
					}
				}
				else if (attr.ValueType == ShowPropertyAttribute.EValueType.Int)
				{
					if (info.CanRead)
					{
						object rawValue = info.GetValue(target, null);
						if (rawValue is int)
						{
							int value = (int)rawValue;
							int newValue = EditorGUILayout.IntField(info.Name, value);
							if (info.CanWrite && value != newValue)
							{
								info.SetValue(target, newValue, null);
							}
						}
					}
				}
				else if (attr.ValueType == ShowPropertyAttribute.EValueType.Float)
				{
					if (info.CanRead)
					{
						object rawValue = info.GetValue(target, null);
						if (rawValue is float)
						{
							float value = (float)rawValue;
							float newValue = EditorGUILayout.FloatField(info.Name, value);
							if (info.CanWrite && value != newValue)
							{
								info.SetValue(target, newValue, null);
							}
						}
					}
				}
				else if (attr.ValueType == ShowPropertyAttribute.EValueType.String)
				{
					if (info.CanRead)
					{
						object rawValue = info.GetValue(target, null);
						if (rawValue is string)
						{
							string value = rawValue as string ?? string.Empty;
							string newValue = EditorGUILayout.TextField(info.Name, value);
							if (info.CanWrite && value != newValue)
							{
								info.SetValue(target, newValue, null);
							}
						}
					}
				}
				else if (attr.ValueType == ShowPropertyAttribute.EValueType.Vector2)
				{
					if (info.CanRead)
					{
						object rawValue = info.GetValue(target, null);
						if (rawValue is Vector2)
						{
							Vector2 value = (Vector2)rawValue;
							Vector2 newValue = EditorGUILayout.Vector2Field(info.Name, value);
							if (info.CanWrite && value != newValue)
							{
								info.SetValue(target, newValue, null);
							}
						}
					}
				}
				else if (attr.ValueType == ShowPropertyAttribute.EValueType.Vector3)
				{
					if (info.CanRead)
					{
						object rawValue = info.GetValue(target, null);
						if (rawValue is Vector3)
						{
							Vector3 value = (Vector3)rawValue;
							Vector3 newValue = EditorGUILayout.Vector3Field(info.Name, value);
							if (info.CanWrite && value != newValue)
							{
								info.SetValue(target, newValue, null);
							}
						}
					}
				}
				else if (attr.ValueType == ShowPropertyAttribute.EValueType.Vector4)
				{
					if (info.CanRead)
					{
						object rawValue = info.GetValue(target, null);
						if (rawValue is Vector4)
						{
							Vector4 value = (Vector4)rawValue;
							Vector4 newValue = EditorGUILayout.Vector4Field(info.Name, value);
							if (info.CanWrite && value != newValue)
							{
								info.SetValue(target, newValue, null);
							}
						}
					}
				}

				if (ga != null && ga.State != GroupAttribute.EState.StartGroup)
				{
					GUILayout.EndVertical();
					inGroup = false;
				}
			}
			if (inGroup)
			{
				GUILayout.EndVertical();
				inGroup = false;
			}
		}

		private void DrawMethodButtons()
		{
			// Draw Head
			if (_buttonMethodAttrList.Count > 0)
			{
				GUILayout.BeginHorizontal();
				{
					GUILayout.Label("", GS.gsSpliterLine);
					GUILayout.Button("Method", GS.gsSpliterText);
					GUILayout.Label("", GS.gsSpliterLine);
				}
				GUILayout.EndHorizontal();
			}

			bool inGroup = false;
			for (int i = 0; i < _buttonMethodAttrList.Count; i++)
			{
				KeyValuePair<MethodInfo, Attribute> pair = _buttonMethodAttrList[i];
				if (pair.Key.GetParameters().Length > 0)
				{
					continue;
				}

				ButtonAttribute attr = pair.Value as ButtonAttribute;

				GroupAttribute ga = (_groupMemberAttrDic.ContainsKey(pair.Key) ? _groupMemberAttrDic[pair.Key] : null) as GroupAttribute;
				if (ga != null && ga.State != GroupAttribute.EState.EndGroup)
				{
					if (inGroup)
					{
						GUILayout.EndVertical();
						inGroup = false;
					}
					DrawGroupHeader(ga);
					inGroup = DrawGroupContentBg(ga);
				}

				Color prevColor = GUI.backgroundColor;
				GUI.backgroundColor = attr.BgColor;
				bool click = GUILayout.Button(attr.Name, attr.Style);
				GUI.backgroundColor = prevColor;

				if (click)
				{
					for (int j = 0; j < targets.Length; j++)
					{
						pair.Key.Invoke(targets[j], null);
					}
				}

				if (ga != null && ga.State != GroupAttribute.EState.StartGroup)
				{
					GUILayout.EndVertical();
					inGroup = false;
				}
			}
			if (inGroup)
			{
				GUILayout.EndVertical();
				inGroup = false;
			}
		}

		private GroupAttribute GetGroupAttrByMemberName(string memberName)
		{
			if (string.IsNullOrEmpty(memberName))
			{
				return null;
			}
			foreach (var pair in _groupMemberAttrDic)
			{
				if (pair.Key.Name == memberName)
				{
					return pair.Value as GroupAttribute;
				}
			}
			return null;
		}

		private void DrawGroupHeader(GroupAttribute ga)
		{
			if (ga == null || ga.State == GroupAttribute.EState.EndGroup) return;

			Color prevColor = GUI.backgroundColor;
			GUI.backgroundColor = ga.Title != null ? new Color(0.8f, 0.9f, 0.99f) : new Color(0.78f, 0.78f, 0.78f);
			GUILayout.Label(ga.Title, ga.Title != null ? GS.gsGroupTitle1 : GS.gsGroupTitle2);
			GUI.backgroundColor = prevColor;
		}

		private bool DrawGroupContentBg(GroupAttribute ga)
		{
			if (ga != null && (ga.State == GroupAttribute.EState.StartGroup || ga.State == GroupAttribute.EState.StartAndEndGroup))
			{
				Color prevColor = GUI.backgroundColor;
				GUI.backgroundColor = new Color(0.91f, 0.91f, 0.91f);
				GUILayout.BeginVertical(ga.Title != null ? GS.gsGroupContent1 : GS.gsGroupContent2);
				GUI.backgroundColor = prevColor;
				return true;
			}
			return false;
		}
	}

	static class GS
	{
		static public GUIStyle gsSpliterLine;
		static public GUIStyle gsSpliterText;

		static public GUIStyle gsGroupTitle1;
		static public GUIStyle gsGroupTitle2;
		static public GUIStyle gsGroupContent1;
		static public GUIStyle gsGroupContent2;

		static GS()
		{
			gsSpliterLine = new GUIStyle("RL DragHandle");
			gsSpliterLine.stretchWidth = true;
			gsSpliterLine.overflow = new RectOffset(0, 0, -8, 8);

			gsSpliterText = new GUIStyle("Label");
			gsSpliterText.stretchWidth = false;

			gsGroupTitle1 = new GUIStyle("dragtab");
			gsGroupTitle1.normal.background = gsGroupTitle1.onNormal.background;
			gsGroupTitle1 = new GUIStyle("TimeScrubberButton");
			gsGroupTitle1.fixedWidth = 0;

			gsGroupTitle1 = new GUIStyle("RL Header");
			gsGroupTitle1.stretchWidth = true;
			gsGroupTitle1.margin = new RectOffset(0, 0, 3, 0);
			gsGroupTitle1.padding = new RectOffset(10, 10, 0, 0);
			gsGroupTitle1.alignment = TextAnchor.MiddleLeft;
			gsGroupTitle1.fixedHeight = 22;
			gsGroupTitle1.fontSize = 12;
			gsGroupTitle1.fontStyle = FontStyle.Bold;
			gsGroupTitle1.normal.textColor = new Color32(210, 210, 210, 255);

			gsGroupTitle2 = new GUIStyle("RL Header");
			gsGroupTitle2.stretchWidth = true;
			gsGroupTitle2.margin = new RectOffset(0, 0, 3, 0);
			gsGroupTitle2.overflow = new RectOffset(0, 0, 0, 1);
			gsGroupTitle2.fixedHeight = 4;

			gsGroupContent1 = new GUIStyle("RL Background");
			gsGroupContent1.stretchHeight = false;
			gsGroupContent1.fixedHeight = 0;
			gsGroupContent1.padding = new RectOffset(15, 8, 4, 8);
			gsGroupContent1.margin = new RectOffset(0, 0, 0, 3);

			gsGroupContent2 = new GUIStyle("RL Background");
			gsGroupContent2.stretchHeight = false;
			gsGroupContent2.fixedHeight = 0;
			gsGroupContent2.padding = new RectOffset(15, 8, 0, 8);
			gsGroupContent2.margin = new RectOffset(0, 0, 0, 3);
		}
	}
}
