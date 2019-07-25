using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace MAD
{
	public class MadExample1 : MonoBehaviour
	{
		public int id;
		[MAD.Group(GroupAttribute.EState.StartGroup, "Texts")]
		public string text1;
		public string text2;
		[MAD.Group(GroupAttribute.EState.EndGroup)]
		public string text3;
		[MAD.Group(GroupAttribute.EState.StartAndEndGroup)]
		public List<string> textList;
		public RuntimePlatform platform;

		[MAD.ShowProperty(ShowPropertyAttribute.EValueType.Int)]
		public int ID
		{
			get { return id; }
			set { id = value; }
		}

		[MAD.ShowProperty(ShowPropertyAttribute.EValueType.Enum)]
		public RuntimePlatform Platform
		{
			get { return platform; }
			set { platform = value; }
		}

		[MAD.ShowProperty(ShowPropertyAttribute.EValueType.Bool)]
		public bool Enabled
		{
			get { return enabled; }
			set { enabled = value; }
		}

		[MAD.ShowProperty(ShowPropertyAttribute.EValueType.String)]
		public string Name
		{
			get { return gameObject.name; }
		}

		[MAD.ShowProperty(ShowPropertyAttribute.EValueType.Vector3)]
		public Vector3 Pos
		{
			get { return transform.localPosition; }
			set { transform.localPosition = value; }
		}

		[Button("Method A")]
		public void MethodA()
		{
			Debug.Log(gameObject.name + "：Method A");
		}

		[Button("Method B", ButtonAttribute.ESize.Mini)]
		public void MethodB()
		{
			Debug.Log(gameObject.name + "：Method B");
		}

		[Group(GroupAttribute.EState.StartGroup, "Color Methods")]
		[Button("Method C", ButtonAttribute.ESize.Common, ButtonAttribute.EColor.Red)]
		public void MethodC()
		{
			Debug.Log(gameObject.name + "：Method C");
		}

		[Button("Static Method D", ButtonAttribute.ESize.Large, 1.0f, 1.0f, 0.7f)]
		static private void MethodD()
		{
			Debug.Log("Static Method D");
		}
	}
}
