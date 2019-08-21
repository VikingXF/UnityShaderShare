using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
#if UNITY_EDITOR
namespace CombineMeshSpace
{
    public class SaveAssets
    {
        /// <summary>
        /// 保存贴图
        /// </summary>
        /// <param (string)name="folder"></param>
        /// <param (string)name="name"></param>
        /// <param (Texture2D)name="Tex"></param>
        public static void SaveTextures(string path, string name,Texture2D Tex)
        {

            byte[] bytes = Tex.EncodeToPNG();         
            File.WriteAllBytes(path, bytes);//保存

            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//导入资源

            //贴图的导入设置
            TextureImporter textureIm = AssetImporter.GetAtPath(path) as TextureImporter;
            textureIm.textureCompression = TextureImporterCompression.Compressed;
            textureIm.isReadable = false;
            textureIm.anisoLevel = 9;
            textureIm.mipmapEnabled = false;
            textureIm.wrapMode = TextureWrapMode.Clamp;


            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//刷新

        }


        /// <summary>
        /// 保存Mesh
        /// </summary>
        /// <param (string)name="path"></param>
        /// <param (mesh)name="mesh"></param>
        public static void SaveMesh(string path, Mesh mesh)
        {

            AssetDatabase.CreateAsset(mesh, path);
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//刷新

        }

        /// <summary>
        /// 保存Prefab
        /// </summary>
        /// <param (string)name="path"></param>
        /// <param (GameObject)name="gameObject"></param>
        public static void SavePrefab(string path, GameObject gameObject)
        {

            PrefabUtility.SaveAsPrefabAsset(gameObject, path);
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//刷新

        }

        /// <summary>
        /// 保存Material
        /// </summary>
        /// <param (string)name="path"></param>
        /// <param (Material)name="material"></param>
        public static void SaveMaterial(string path, Material material)
        {

            AssetDatabase.CreateAsset(material, path);

            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//刷新

        }
    }
}
#endif
