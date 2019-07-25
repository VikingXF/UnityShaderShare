using UnityEngine;
using UnityEditor;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace MAD
{
	[InitializeOnLoad] 
	public static class MadEditorConfig
	{
		static MadEditorConfig()
		{
			CustomEditorAttributesType = typeof(Editor).Assembly.GetType("UnityEditor.CustomEditorAttributes");
			CustomEditorAttributesType_Initialized = CustomEditorAttributesType.GetField("s_Initialized", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
			CustomEditorAttributesType_CachedEditorForType = CustomEditorAttributesType.GetField("kCachedEditorForType", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
			CustomEditorAttributesType_CachedMultiEditorForType = CustomEditorAttributesType.GetField("kCachedMultiEditorForType", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
			CustomEditorAttributesType_CustomEditors = CustomEditorAttributesType.GetField("kSCustomEditors", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
			CustomEditorAttributesType_CustomMultiEditors = CustomEditorAttributesType.GetField("kSCustomMultiEditors", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);

			MonoEditorType = CustomEditorAttributesType.GetNestedType("MonoEditorType", BindingFlags.Public | BindingFlags.NonPublic);
			MonoEditorType_InspectedType = MonoEditorType.GetField("m_InspectedType", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
			MonoEditorType_InspectorType = MonoEditorType.GetField("m_InspectorType", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
			MonoEditorType_EditorForChildClasses = MonoEditorType.GetField("m_EditorForChildClasses", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
			MonoEditorType_IsFallback = MonoEditorType.GetField("m_IsFallback", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

			CustomEditorType = typeof(CustomEditor);
			CustomEditor_InspectedTypeField = typeof(CustomEditor).GetField("m_InspectedType", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
			CustomEditor_EditorForChildClassesField = typeof(CustomEditor).GetField("m_EditorForChildClasses", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

			BindEditors();
		}

		static private void BindEditors()
		{
			Type editorType = typeof(Editor);
			Type madEditorType = typeof(MadEditor);
			Type monobehaviourType = typeof(MonoBehaviour);
			Assembly userAssembly = typeof(ButtonAttribute).Assembly;
			Assembly userEditorAssembly = madEditorType.Assembly;

			List<Type> customEditorTypeList = new List<Type>(); // 所有派生自"Editor" 的"自定义Editor"类
			List<Type> defaultTypeList = new List<Type>(); // 所有派生自"MonoBehaviour"且未绑定"自定义Editor"的类

			//bool initialized = (bool)CustomEditorAttributesType_Initialized.GetValue(null);

			// 找到所有的 "自定义Editor"
			foreach (var et in userEditorAssembly.GetTypes())
			{
				if (et.IsSubclassOf(editorType))
				{
					if (et.IsDefined(typeof(CustomEditor), true))
					{
						CustomEditor a = et.GetCustomAttributes(typeof(CustomEditor), true)[0] as CustomEditor;
						Type t = CustomEditor_InspectedTypeField.GetValue(a) as Type;
						//bool editChild = (bool)CustomEditor_EditorForChildClassesField.GetValue(a);

						customEditorTypeList.Add(t);
					}
				}
			}
			// 找到所有的无 "自定义Editor" 的 "MonoBehaviour"
			foreach (var t in userAssembly.GetTypes())
			{
				if (!(t.IsSubclassOf(monobehaviourType)))
				{
					continue;
				}
				bool hasMatchEditor = false;
				for (int i = 0; i < customEditorTypeList.Count; i++)
				{
					if (customEditorTypeList[i].IsAssignableFrom(t))
					{
						hasMatchEditor = true;
						break;
					}
				}
				if (!hasMatchEditor)
				{
					defaultTypeList.Add(t);
				}
			}

			// 为这些 "MonoBehaviour" 统一绑定指定的 "Editor"
			bool isMultiEditor = true;
			// 从 2017.4 开始，CustomEditorAttributesType_CustomEditors字段类型不再是List而是Dictionary，先进行类型判断
			bool IsBackedByADictionary = typeof(IDictionary).IsAssignableFrom(CustomEditorAttributesType_CustomEditors.FieldType);

			foreach (var scriptType in defaultTypeList)
			{
				object entry = Activator.CreateInstance(MonoEditorType);

				MonoEditorType_InspectedType.SetValue(entry, scriptType);
				MonoEditorType_InspectorType.SetValue(entry, madEditorType);
				MonoEditorType_IsFallback.SetValue(entry, false);
				MonoEditorType_EditorForChildClasses.SetValue(entry, false);
				
				if (IsBackedByADictionary)
				{
					IDictionary dict = (IDictionary)CustomEditorAttributesType_CustomEditors.GetValue(null);
					IList list;

					if (dict.Contains(scriptType))
					{
						list = (IList)dict[scriptType];
					}
					else
					{
						list = (IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(MonoEditorType));
						dict[scriptType] = list;
					}
					list.Insert(0, entry);

					if (isMultiEditor)
					{
						IDictionary dictM = (IDictionary)CustomEditorAttributesType_CustomMultiEditors.GetValue(null);
						IList listM;

						if (dictM.Contains(scriptType))
						{
							listM = (IList)dictM[scriptType];
						}
						else
						{
							listM = (IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(MonoEditorType));
							dictM[scriptType] = listM;
						}
						listM.Insert(0, entry);
					}
				}
				else
				{
					if (CustomEditorAttributesType_CachedEditorForType != null && CustomEditorAttributesType_CachedMultiEditorForType != null)
					{
						((IDictionary)CustomEditorAttributesType_CachedEditorForType.GetValue(null))[scriptType] = madEditorType;
						if (isMultiEditor)
						{
							((IDictionary)CustomEditorAttributesType_CachedMultiEditorForType.GetValue(null))[scriptType] = madEditorType;
						}
					}

					// Insert a new type entry at the beginning of the relevant lists
					{
						((IList)CustomEditorAttributesType_CustomEditors.GetValue(null)).Insert(0, entry);
						if (isMultiEditor)
						{
							((IList)CustomEditorAttributesType_CustomMultiEditors.GetValue(null)).Insert(0, entry);
						}
					}
				}
			}
		}
		
		static private readonly Type CustomEditorType;
		static private readonly FieldInfo CustomEditor_InspectedTypeField = typeof(CustomEditor).GetField("m_InspectedType", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
		static private readonly FieldInfo CustomEditor_EditorForChildClassesField = typeof(CustomEditor).GetField("m_EditorForChildClasses", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

		static private readonly Type CustomEditorAttributesType;
		static private readonly FieldInfo CustomEditorAttributesType_CachedEditorForType;
		static private readonly FieldInfo CustomEditorAttributesType_CachedMultiEditorForType;
		static private readonly FieldInfo CustomEditorAttributesType_CustomEditors;
		static private readonly FieldInfo CustomEditorAttributesType_CustomMultiEditors;
		static private readonly FieldInfo CustomEditorAttributesType_Initialized;

		static private readonly Type MonoEditorType;
		static private readonly FieldInfo MonoEditorType_InspectedType;
		static private readonly FieldInfo MonoEditorType_InspectorType;
		static private readonly FieldInfo MonoEditorType_EditorForChildClasses;
		static private readonly FieldInfo MonoEditorType_IsFallback;
	}
}
