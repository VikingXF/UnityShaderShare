using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace RoleMaterialNameSpace
{
    [System.Serializable]
    public class RoleParts
    {
        public string RolePartsName;
        public List<Material> RolePartMaterials;
    }
    [System.Serializable]
    public class RoleMaterials
    {
        public string RoleName;
        public List<RoleParts> roleParts;
    }

    //[CreateAssetMenu(menuName = "Create ShowObject")]
    public class RoleMaterialSave : ScriptableObject
    {

        [SerializeField]//必须要加  
        public List<RoleMaterials> _assetLst = new List<RoleMaterials>();
    }
}