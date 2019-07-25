using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

namespace MAD
{
	[AttributeUsage(AttributeTargets.Field | AttributeTargets.Property | AttributeTargets.Method, AllowMultiple = false, Inherited = false)]
	public class GroupAttribute : Attribute
	{
		public enum EState
		{
			StartGroup,
			EndGroup,
			StartAndEndGroup,
		}
		
		public string Title { get; protected set; }
		public EState State { get; protected set; }
		
		public GroupAttribute(EState state)
			: this(state, null)
		{}

		// state : 启动或结束 Group
		public GroupAttribute(EState state, string title)
		{
			Title = title;
			State = state;
		}
	}
}
