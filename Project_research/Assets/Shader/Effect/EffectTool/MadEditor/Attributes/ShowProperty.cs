using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

namespace MAD
{
	[AttributeUsage(AttributeTargets.Property, AllowMultiple = false, Inherited = false)]
	public class ShowPropertyAttribute : Attribute
	{
		public enum EValueType
		{
			Enum,
			Bool,
			Int,
			Float,
			String,
			Vector2,
			Vector3,
			Vector4,
		}
		
		public EValueType ValueType { get; protected set; }

		public ShowPropertyAttribute(EValueType type)
		{
			ValueType = type;
		}
	}
}
