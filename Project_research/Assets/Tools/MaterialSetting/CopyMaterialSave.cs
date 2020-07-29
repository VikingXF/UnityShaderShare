using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RoleMaterialNameSpace
{
    public class CopyMaterialSave : ScriptableObject
    {
       
       [SerializeField]//必须要加  
        public List<Material> copymaterials = new List<Material>();
       
    }
    
}

