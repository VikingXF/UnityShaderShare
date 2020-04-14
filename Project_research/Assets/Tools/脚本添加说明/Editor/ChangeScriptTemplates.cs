using System.IO;

public class ChangeScriptTemplates : UnityEditor.AssetModificationProcessor
{
    private static string str =
          "//=============================================\r\n"
        + "//作者:\r\n"
        + "//描述:\r\n"
        + "//创建时间:#CreateTime#\r\n"
        + "//版本:v 1.0\r\n"
        + "//=============================================\r\n";

    public static void OnWillCreateAsset(string path)
    {
        path = path.Replace(".meta", "");
        if (path.EndsWith(".cs"))
        {
            string allText = str;
            allText += File.ReadAllText(path);
            allText = allText.Replace("#CreateTime#", System.DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));
            File.WriteAllText(path, allText);
        
        }
    }

}
