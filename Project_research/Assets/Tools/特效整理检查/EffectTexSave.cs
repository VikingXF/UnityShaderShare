using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OptimizationTools
{


    //[CreateAssetMenu(menuName = "Create ShowObject")]
    public class EffectTexSave : ScriptableObject
    {

        [SerializeField]//必须要加  
        public List<Texture2D> _EffectTexAssetLst = new List<Texture2D>();

    }
}