/*--------------------------------------------------------
  减面生成LOD工具
--------------------------------------------------------*/
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
using System.Collections;

public class MantisLODEditorOnline: MonoBehaviour {
	#if UNITY_EDITOR
	[MenuItem("Tools/Mantis LOD Editor Online")]
	public static void AddComponent() {
		GameObject SelectedObject = Selection.activeGameObject;
		if (SelectedObject) {
			// Register root object for undo.
			Undo.RegisterCreatedObjectUndo(SelectedObject.AddComponent(typeof(MantisLODEditorOnline)), "Add Mantis LOD Editor Online");
		}
	}
	[MenuItem ("Tools/Mantis LOD Editor Online", true)]
	static bool ValidateAddComponent () {
		// Return false if no gameobject is selected.
		return Selection.activeGameObject != null;
	}
	#endif
}
