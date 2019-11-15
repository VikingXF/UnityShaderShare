using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;

#endif

[ExecuteInEditMode]
public class SetParticleLayer : MonoBehaviour
{
    public int particleLayer = 0;
    float prevLayer;

    void Start()
    {
        prevLayer = particleLayer;
    }

    // Update is called once per frame
    void Update()
    {
        if (prevLayer != particleLayer)
        {

            LayerRenderers();

        }
    }

    void LayerRenderers()
    {
#if UNITY_EDITOR
        ParticleSystemRenderer[] PSystemsRenders = GetComponentsInChildren<ParticleSystemRenderer>();

        foreach (ParticleSystemRenderer PSystemsRender in PSystemsRenders)
        {
            PSystemsRender.sortingOrder = particleLayer;

        }

#endif
    }

}
