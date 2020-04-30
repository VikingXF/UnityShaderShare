using UnityEngine;

namespace ParticleEffectSys
{
    public class ParticleEffectShakeCamera : ParticleEffectBase
    {
        public float Duration;
        public float Strength = 1f;
        public int Vibrato = 10;
        public float Randomness = 90f;
        
        public override void ExecuteEvent()
        {
            base.ExecuteEvent();

            CameraCommonEffectManager.Instance.ShakeCamera(Duration, Strength, Vibrato, Randomness);
        }
    }
}