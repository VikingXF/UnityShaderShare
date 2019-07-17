//=======================================================
// 作者：xuefei
// 描述：字动画资源名字选取第一个字符其他字符去掉进行重命名
//=======================================================
#if UNITY_EDITOR
using System.IO;
using UnityEngine;
using UnityEditor;
using System.Collections;

namespace xfTools
{
	public class ReName : EditorWindow {

		 [MenuItem("Tools/重命名工具（1）")]
		 public static void ShowWindow()
		 {

			EditorWindow editorWindow = EditorWindow.GetWindow(typeof(ReName));
			editorWindow.autoRepaintOnSceneChange = true;
			editorWindow.Show();
			editorWindow.title = "ReName";
		}

		void OnGUI()
		{
			EditorGUILayout.Space();
			if(GUILayout.Button("重命名",GUILayout.MinHeight(60)))
			{
		
				Rename();
			}
		}
		
		void Rename()
		{
			Object[] m_objects = Selection.GetFiltered(typeof(Object), SelectionMode.DeepAssets);
			
			foreach (Object item in m_objects)
			{
				Debug.Log(item.name.Substring(0,1));
				string itemname = item.name.Substring(0,1);
				string path = AssetDatabase.GetAssetPath(item);
				AssetDatabase.RenameAsset(path,itemname);
				
			}
			AssetDatabase.SaveAssets();
			AssetDatabase.Refresh();
		}
	}
}
#endif