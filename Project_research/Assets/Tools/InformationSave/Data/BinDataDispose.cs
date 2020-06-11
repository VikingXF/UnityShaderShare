using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
namespace Babybus.UtilityTools
{
    public class BinDataDispose : IDataDispose
    {
        public void Write<T>(string path, T t)
        {
            FileStream fs = new FileStream(path, FileMode.Create);
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(fs, t);
            fs.Close();
        }
        public T Read<T>(string path)
        {
            FileStream fs = new FileStream(path, FileMode.Open);
            BinaryFormatter bf = new BinaryFormatter();
            T t = (T)bf.Deserialize(fs);
            fs.Close();
            return t;
        }
    }
}
