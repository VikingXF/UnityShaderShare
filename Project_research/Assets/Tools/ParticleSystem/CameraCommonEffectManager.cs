using DG.Tweening;
using UnityEngine;

namespace ParticleEffectSys
{
    public class CameraCommonEffectManager : MonoBehaviour
    {
        #region 单例

        private static CameraCommonEffectManager instance;
        public static CameraCommonEffectManager Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = (CameraCommonEffectManager)FindObjectOfType(typeof(CameraCommonEffectManager));

                    if (instance == null)
                    {
                        instance = Camera.main.gameObject.AddComponent<CameraCommonEffectManager>();
                    }
                }

                return instance;
            }
        }

        #endregion

        public Camera MainCamera;

        private Tweener _shakeCameraTweener;

        private void Awake()
        {
            instance = this;
            if (MainCamera == null)
            {
                MainCamera = Camera.main;
            }
        }

        public void ShakeCamera(float duration, float strength = 1f, int vibrato = 10, float randomness = 90f)
        {
            if (_shakeCameraTweener != null && _shakeCameraTweener.IsPlaying())
            {
                _shakeCameraTweener.Complete();
            }

            _shakeCameraTweener = MainCamera.transform.DOShakePosition(duration, strength, vibrato, randomness);
        }

        private void OnDestroy()
        {
            if (instance == this)
            {
                instance = null;
            }
        }
    }
}