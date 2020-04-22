//=============================================
//作者:
//描述:
//创建时间:2020/04/22 09:55:56
//版本:v 1.0
//=============================================
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UIAlphaMask
{
    public class UIAlphaMask : MonoBehaviour
    {
        [SerializeField]
        private bool _useMaskAlphaChannel = false;

        public bool useMaskAlphaChannel
        {
            get
            {
                return _useMaskAlphaChannel;
            }
            set
            {
                //SetMaskBoolValueInMaterials("_UseAlphaChannel", value);
                _useMaskAlphaChannel = value;
            }
        }
    }

}

