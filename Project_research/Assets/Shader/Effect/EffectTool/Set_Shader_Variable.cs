using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Set_Shader_Variable : MonoBehaviour
{

    public enum ShaderProperties
    {
        _Color,
        _Mask
    }
    public ShaderProperties ShaderFloatProperty = ShaderProperties._Color;
    public AnimationCurve FloatCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
    public Gradient Color = new Gradient();
    public bool IsLoop;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
