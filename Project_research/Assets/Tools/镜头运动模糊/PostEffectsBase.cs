//=======================================================
// 作者：xuefei
// 描述：镜头运动模糊
//=======================================================
using UnityEngine;
using System.Collections;

[ExecuteInEditMode] //在编辑器状态下也可以执行脚本来查看效果
[RequireComponent (typeof(Camera))] //绑定摄像机组件
public class PostEffectsBase : MonoBehaviour {

	// 开始时调用
	protected void CheckResources() {
		bool isSupported = CheckSupport();
		
		if (isSupported == false) {
			NotSupported();
		}
	}

	// 检查当前平台是否支持渲染纹理和屏幕特效
	protected bool CheckSupport() {
		if (SystemInfo.supportsImageEffects == false || SystemInfo.supportsRenderTextures == false) {
			Debug.LogWarning("This platform does not support image effects or render textures.");
			return false;
		}
		
		return true;
	}

	// 当平台不支持时调用
	protected void NotSupported() {
		enabled = false;
	}
	
	protected void Start() {
		CheckResources();
	}

	// 当创建材质时，检查shader是否可用，创建材质时调用
	protected Material CheckShaderAndCreateMaterial(Shader shader, Material material) {
		if (shader == null) {
			return null;
		}
		
		if (shader.isSupported && material && material.shader == shader)
			return material;
		
		if (!shader.isSupported) {
			return null;
		}
		else {
			material = new Material(shader);
			material.hideFlags = HideFlags.DontSave;
			if (material)
				return material;
			else 
				return null;
		}
	}
}
