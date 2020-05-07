//////////////////////////////////////////////////////
// Glow Editor    			        //
//////////////////////////////////////////////////////

#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;

namespace Glow
{

    [CustomEditor(typeof(Glow))]
    public class MKGlowEditor : UnityEditor.Editor
	{
		//Main
		private SerializedProperty _debugView;
		private SerializedProperty _workflow;
		private SerializedProperty _selectiveRenderLayerMask;

		//Bloom
		private SerializedProperty _bloomThreshold;
		private SerializedProperty _bloomScattering;
		private SerializedProperty _bloomIntensity;
		
		public void OnEnable()
		{
			//Main
			_debugView = serializedObject.FindProperty("debugView");
			_workflow = serializedObject.FindProperty("workflow");
			_selectiveRenderLayerMask = serializedObject.FindProperty("selectiveRenderLayerMask");

			//Bloom
			_bloomThreshold = serializedObject.FindProperty("bloomThreshold");
			_bloomScattering = serializedObject.FindProperty("bloomScattering");
			_bloomIntensity = serializedObject.FindProperty("bloomIntensity");
		}

		public override void OnInspectorGUI()
		{
			
		}
    }
}
#endif