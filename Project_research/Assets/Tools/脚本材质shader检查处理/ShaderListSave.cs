using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BabybusOptimizationTools
{

    //[CreateAssetMenu(menuName = "Create ShowObject")]
    public class ShaderListSave : ScriptableObject
    {

        [SerializeField]//必须要加  
        public List<Shader> _FrameworkshaderAssetLst = new List<Shader>();
        
    }
  
}