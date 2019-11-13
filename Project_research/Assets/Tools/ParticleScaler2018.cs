//This script will only work in editor mode. You cannot adjust the scale dynamically in-game!

using UnityEngine;
using System.Collections;
#if UNITY_EDITOR
using UnityEditor;

#endif

[ExecuteInEditMode]
public class ParticleScaler2018 : MonoBehaviour
{
    public float particleScale = 1.0f;
    public bool alsoScaleGameobject = true;

    float prevScale;

    void Start()
    {
        prevScale = particleScale;
    }

    void Update()
    {
#if UNITY_EDITOR
        //check if we need to update
        if (prevScale != particleScale && particleScale > 0)
        {
            if (alsoScaleGameobject)
            {
                transform.localScale = new Vector3(particleScale, particleScale, particleScale);
               
                ScaleChilds(transform, transform.localScale);
            }

            float scaleFactor = particleScale / prevScale;

            //scale legacy particle systems
            ScaleLegacySystems(scaleFactor);

            //scale shuriken particle systems
            ScaleShurikenSystems(scaleFactor);

            //scale trail renders
            ScaleTrailRenderers(scaleFactor);

            prevScale = particleScale;
        }
#endif
    }

    void ScaleChilds(Transform parent, Vector3 scale)
    {
        if (parent.childCount > 0)
        {
            for (int i = 0; i < parent.childCount; i++)
            {
                var child = parent.GetChild(i);
                child.transform.localScale = scale;
                ScaleChilds(child.transform, scale);
            }
        }
    }

    void ScaleShurikenSystems(float scaleFactor)
    {
#if UNITY_EDITOR
        //get all shuriken systems we need to do scaling on
        ParticleSystem[] Psystems = GetComponentsInChildren<ParticleSystem>();

        foreach (ParticleSystem Psystem in Psystems)
        {

           

            var main = Psystem.main;

            var startSize = main.startSize;
            startSize.constantMax = startSize.constantMax * scaleFactor;
            startSize.constantMin = startSize.constantMin * scaleFactor;
            main.startSize = startSize;

            var startSpeed = main.startSpeed;
            startSpeed.constantMax = startSpeed.constantMax * scaleFactor;
            startSpeed.constantMin = startSpeed.constantMin * scaleFactor;
            main.startSpeed = startSpeed;

            var gravityModifier = main.gravityModifier;
            gravityModifier.constantMax = gravityModifier.constantMax * scaleFactor;
            gravityModifier.constantMin = gravityModifier.constantMin * scaleFactor;
            main.gravityModifier = gravityModifier;

            //Psystem.startSpeed *= scaleFactor;
            //Psystem.startSize *= scaleFactor;
            //Psystem.gravityModifier *= scaleFactor;

            //some variables cannot be accessed through regular script, we will acces them through a serialized object
            SerializedObject so = new SerializedObject(Psystem);

            //unity 4.0 and onwards will already do this one for us
#if UNITY_3_5
			so.FindProperty("ShapeModule.radius").floatValue *= scaleFactor;
			so.FindProperty("ShapeModule.boxX").floatValue *= scaleFactor;
			so.FindProperty("ShapeModule.boxY").floatValue *= scaleFactor;
			so.FindProperty("ShapeModule.boxZ").floatValue *= scaleFactor;
#endif

            so.FindProperty("VelocityModule.x.scalar").floatValue *= scaleFactor;
            so.FindProperty("VelocityModule.y.scalar").floatValue *= scaleFactor;
            so.FindProperty("VelocityModule.z.scalar").floatValue *= scaleFactor;
            so.FindProperty("ClampVelocityModule.magnitude.scalar").floatValue *= scaleFactor;
            so.FindProperty("ClampVelocityModule.x.scalar").floatValue *= scaleFactor;
            so.FindProperty("ClampVelocityModule.y.scalar").floatValue *= scaleFactor;
            so.FindProperty("ClampVelocityModule.z.scalar").floatValue *= scaleFactor;
            so.FindProperty("ForceModule.x.scalar").floatValue *= scaleFactor;
            so.FindProperty("ForceModule.y.scalar").floatValue *= scaleFactor;
            so.FindProperty("ForceModule.z.scalar").floatValue *= scaleFactor;
            so.FindProperty("ColorBySpeedModule.range").vector2Value *= scaleFactor;
            so.FindProperty("SizeBySpeedModule.range").vector2Value *= scaleFactor;
            so.FindProperty("RotationBySpeedModule.range").vector2Value *= scaleFactor;

            so.ApplyModifiedProperties();
        }
#endif
    }

    // 过时的方法，Unity 2018 不能使用
    void ScaleLegacySystems(float scaleFactor)
    {
#if UNITY_EDITOR
//		//get all emitters we need to do scaling on
//		ParticleEmitter[] emitters = GetComponentsInChildren<ParticleEmitter>();
//
//		//get all animators we need to do scaling on
//		ParticleAnimator[] animators = GetComponentsInChildren<ParticleAnimator>();
//
//		//apply scaling to emitters
//		foreach (ParticleEmitter emitter in emitters)
//		{
//			emitter.minSize *= scaleFactor;
//			emitter.maxSize *= scaleFactor;
//			emitter.worldVelocity *= scaleFactor;
//			emitter.localVelocity *= scaleFactor;
//			emitter.rndVelocity *= scaleFactor;
//
//			//some variables cannot be accessed through regular script, we will acces them through a serialized object
//			SerializedObject so = new SerializedObject(emitter);
//
//			so.FindProperty("m_Ellipsoid").vector3Value *= scaleFactor;
//			so.FindProperty("tangentVelocity").vector3Value *= scaleFactor;
//			so.ApplyModifiedProperties();
//		}
//
//		//apply scaling to animators
//		foreach (ParticleAnimator animator in animators)
//		{
//			animator.force *= scaleFactor;
//			animator.rndForce *= scaleFactor;
//		}
#endif
    }

    void ScaleTrailRenderers(float scaleFactor)
    {
        //get all animators we need to do scaling on
        TrailRenderer[] trails = GetComponentsInChildren<TrailRenderer>();

        //apply scaling to animators
        foreach (TrailRenderer trail in trails)
        {
            trail.startWidth *= scaleFactor;
            trail.endWidth *= scaleFactor;
        }
    }
}