using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OptimizationTools
{

    //[CreateAssetMenu(menuName = "Create ShowObject")]
    public class ShaderSave : ScriptableObject
    {

        [SerializeField]//必须要加  
        public List<Shader> _EffectshaderAssetLst = new List<Shader>();
    }
}