using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeCloth : MonoBehaviour
{
    public Transform Target;
    // Start is called before the first frame update
    void Start()
    {
        Utility.AddSkinnedMeshFromModle(transform, Target);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
