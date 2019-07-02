namespace xfScreenshot
{
    public interface IDataDispose
    {
        void Write<T>(string path, T t);
        T Read<T>(string path);
    }
}
