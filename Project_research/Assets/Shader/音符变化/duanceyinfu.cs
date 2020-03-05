using UnityEngine;
using System.Collections;

public class duanceyinfu : MonoBehaviour {

    float _countTime = 0;
    public float _limitTime = 0.5f;

    public Material materials;
   
	void Start ()
    {
        
         Debug.Log(materials.name);
        
       

    }

	void Update () {
        _countTime += Time.deltaTime;
        if (_countTime > _limitTime)
        {
            _countTime = 0;
            int randomIndex = Random.Range(0, 7);
            materials.SetFloat("_Amount", randomIndex * 0.17f);
            
        }

    }
}
