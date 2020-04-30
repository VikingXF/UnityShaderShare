using UnityEngine;

namespace ParticleEffectSys
{
    [RequireComponent(typeof(ParticleItem))]
    public class ParticleEffectBase : MonoBehaviour
    {
        public ParticleItem Item;
        [Header("动画控制器时间，不是秒！！！")]
        [Tooltip("动画控制器时间，不是秒！！！")]
        public float TriggerTime;
        
        private void Reset()
        {
            Item = GetComponent<ParticleItem>();
        }

        protected virtual void OnEnable()
        {
            if(Item != null)
                Item.StartPlayParticleCallback += StartRunning;
        }

        protected virtual void OnDisable()
        {
            if(Item != null)
                Item.StartPlayParticleCallback -= StartRunning;
        }

        void StartRunning()
        {
            CancelInvoke(nameof(ExecuteEvent));

            int intergerTime = (int) TriggerTime;
            float decimalTime = TriggerTime - intergerTime;
            float time = intergerTime + decimalTime * 5 / 3;
            Invoke(nameof(ExecuteEvent), time);
        }
        
        public virtual void ExecuteEvent()
        {
            
        }
    }
}