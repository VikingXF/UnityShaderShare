//=============================================
//作者:
//描述:
//创建时间:2020/06/11 16:27:29
//版本:v 1.0
//=============================================
//=============================================
//作者:
//描述:控制相机拖动
//创建时间:2020/06/10 08:48:28
//版本:v 1.0
//=============================================
using UnityEngine;
namespace Babybus.UtilityTools
{
    /// <summary>
    /// 挂在相机上
    /// </summary>
    public class DragCamera : MonoBehaviour
    {
        [Header("移动速度")]
        public float MoveSpeed = 1;
        [Header("中心目标点")]
        public Transform CenterTarget;
        [Header("与中心距离")]
        public float Distance;
        [Header("平滑")]
        public float Smooth = 5;
        [Header("距离Log")]
        public bool Log;
        private Camera _camera;
        private Transform _transform;
        private Vector2 _lastMousePosition;
        private Vector2 _currentMousePosition;
        private Plane _plane;
        private float _enter;
        private Ray _ray;
        private Vector3 _delta;
        private Vector3 _cameraTargetPosition;
        private Vector3 _localPosition;
        private Vector3 _originLocalPosition;
        private bool _move;
        void Start()
        {
            _transform = transform;
            _camera = _transform.GetComponent<Camera>();
            _plane = new Plane(CenterTarget.forward, CenterTarget.position);           
            SetPostion();
        }
        
        public void SetPostion()
        {
            _cameraTargetPosition = transform.localPosition;
            if (Input.GetMouseButton(0))
            {
                _lastMousePosition = _currentMousePosition = Input.mousePosition;
            }
        }
        
        void Update()
        {
            if (Input.GetMouseButtonDown(0))
            {
                _lastMousePosition = _currentMousePosition = Input.mousePosition;
            }

            if (Input.GetMouseButton(0))
            {
                _move = true;
                _currentMousePosition = Input.mousePosition;
                _delta = (GetPosition(_lastMousePosition) - GetPosition(_currentMousePosition)) * MoveSpeed;

                _localPosition = CenterTarget.InverseTransformPoint(_cameraTargetPosition + _delta);
                if (Log)
                {
                    Debug.LogError("距离："+(_localPosition-_originLocalPosition).magnitude);
                }
                if ((_localPosition-_originLocalPosition).magnitude < Distance)
                {
                    _cameraTargetPosition = CenterTarget.TransformPoint(_localPosition);
                }
                _lastMousePosition = _currentMousePosition;
            }

            if (_move)
            {
                _transform.position = Vector3.Lerp(_transform.position, _cameraTargetPosition, Time.deltaTime * Smooth);
                if ((_transform.position - _cameraTargetPosition).magnitude < 0.01f)
                {
                    _move = false;
                }
            }
        }

        Vector3 GetPosition(Vector2 v2)
        {
            _ray = _camera.ScreenPointToRay(v2);
            _plane.Raycast(_ray, out _enter);
            return _ray.GetPoint(_enter);
        }
    }
}
