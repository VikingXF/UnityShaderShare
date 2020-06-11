using System.IO;
using System.Xml.Serialization;
namespace Babybus.UtilityTools
{
    public class XMLDataDispose : IDataDispose
    {
        public void Write<T>(string path, T t)
        {
            FileStream fs = new FileStream(path, FileMode.Create);
            XmlSerializer xml = new XmlSerializer(typeof(T));
            xml.Serialize(fs, t);
            fs.Close();
        }
        public T Read<T>(string path)
        {
            FileStream fs = new FileStream(path, FileMode.Open);
            XmlSerializer bf = new XmlSerializer(typeof(T));
            T t = (T)bf.Deserialize(fs);
            return t;
        }
    }
}
