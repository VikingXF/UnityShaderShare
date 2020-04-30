using System.Collections.Specialized;
using UnityEngine;

namespace ParticleEffectSys
{
    public class ParticleItem : MonoBehaviour
    {
        public ParticlePlayType PlayType;
        public float Duration;

        public ParticleSystem[] EffectItems;
        public Animator[] EffectAnimators;
        public TrailRenderer[] EffectTrails;

        public event System.Action StartPlayParticleCallback;

        private void Reset()
        {
            ParticleSystem particle = GetComponentInChildren<ParticleSystem>();
            if (particle != null)
                Duration = particle.main.duration;
        }

        public void Play()
        {
            //强制刷新下状态
            gameObject.SetActive(true);   
            
            CancelInvoke(nameof(Stop));
            CancelInvoke(nameof(StopImmediately));

            if (EffectItems.Length > 0)
            {
                EffectItems[0].Play(true);
            }

            if (EffectAnimators.Length > 0)
            {
                for (int i = 0; i < EffectAnimators.Length; i++)
                {
                    EffectAnimators[i].enabled = true;
                    EffectAnimators[i].Play(0, 0, 0);
                }
            }

            if (PlayType == ParticlePlayType.Once)
            {
                Invoke(nameof(Stop), Duration);
            }

            if (StartPlayParticleCallback != null)
            {
                StartPlayParticleCallback.Invoke();
            }
        }

        public void Stop()
        {
            if (EffectItems.Length > 0)
            {
                for (int i = 0; i < EffectItems.Length; i++)
                {
                    EffectItems[i].Stop();
                }
            }

            if (EffectAnimators.Length > 0)
            {
                for (int i = 0; i < EffectAnimators.Length; i++)
                {
                    EffectAnimators[i].enabled = false;
                }    
            }
            
            Invoke(nameof(StopImmediately), 1f);
        }

        public void StopImmediately()
        {
            Clear();
            gameObject.SetActive(false);
        }

        public void Clear()
        {
            if (EffectItems.Length > 0)
            {
                for (int i = 0; i < EffectItems.Length; i++)
                {
                    EffectItems[i].Clear();
                }
            }

            if (EffectTrails.Length > 0)
            {
                for (int i = 0; i < EffectTrails.Length; i++)
                {
                    EffectTrails[i].Clear();
                }
            }
        }
    }
}