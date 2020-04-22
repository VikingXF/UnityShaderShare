//=============================================
//作者:
//描述:
//创建时间:2020/04/22 09:56:16
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;

namespace UIAlphaMask
{
    [CustomEditor(typeof(UIAlphaMask))]
    public class UIAlphaMaskEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            UIAlphaMask maskTarget = (UIAlphaMask)target;

            if (maskTarget.GetComponents<UIAlphaMask>().Length > 1)
            {
                GUILayout.Label("请确认添加UIAlphaMask脚本是否重复.");
                return;
            }

            bool useMaskAlphaChannel = EditorGUILayout.Toggle("Use Mask Alpha Channel (not RGB)", maskTarget.useMaskAlphaChannel);
            if (useMaskAlphaChannel != maskTarget.useMaskAlphaChannel)
            {
                maskTarget.useMaskAlphaChannel = useMaskAlphaChannel;
            }


            if (!Application.isPlaying)
            {
                bool displayImage = EditorGUILayout.Toggle("Display image", maskTarget.GetComponent<Image>().enabled);
                if (displayImage != maskTarget.GetComponent<Image>().enabled)
                {
                    maskTarget.GetComponent<Image>().enabled = displayImage;
                    
                }

            }

            if (!Application.isPlaying)
            {
                if (GUILayout.Button("Apply UIMask to Children"))
                {
                    //ApplyMaskToChildren();                 
                    Debug.Log(maskTarget.GetComponent<RectTransform>().rect);
                    Debug.Log(maskTarget.GetComponent<RectTransform>().lossyScale);
                    Debug.Log(maskTarget.GetComponent<RectTransform>().position);
                }
            }

        }

        private void ApplyMaskToChildren()
        {
            UIAlphaMask maskTarget = (UIAlphaMask)target;
            Shader UIDefaultAlphaMaskShader = Shader.Find("Babybus/UI/UI-Default-AlphaMask");          
            Shader SpriteDefaultShader = Shader.Find("Sprites/Default");
            Shader UIDefaultShader = Shader.Find("UI/Default");
            Shader UIDefaultFontShader = Shader.Find("UI/Default Font");
            if ((UIDefaultAlphaMaskShader == null) || (UIDefaultAlphaMaskShader == null))
            {
                Debug.Log("UIAlphaMaskShaders项目中不存在.");
                return;
            }           
            Texture maskTexture = maskTarget.GetComponent<Image>().mainTexture;

            List<Component> components = new List<Component>();
            components.AddRange(maskTarget.transform.gameObject.GetComponentsInChildren<Image>());
           

        }


    }
}

