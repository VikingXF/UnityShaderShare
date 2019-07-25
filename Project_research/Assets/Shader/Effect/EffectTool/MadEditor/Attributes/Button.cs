using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

namespace MAD
{
	[AttributeUsage(AttributeTargets.Method, AllowMultiple = false, Inherited = false)]
	public class ButtonAttribute : Attribute
	{
		public enum ESize
		{
			Common,
			Mini,
			Large
		}

		public enum EColor
		{
			White,
			Black,
			Gray,
			Red,
			Green,
			Blue,
			Yellow,
			Cyan,
			Magenta,
		}

		public string Name { get; protected set; }
		public ESize SizeType { get; protected set; }
		public Color BgColor { get; protected set; }
		public GUIStyle Style { get; protected set; }
		
		static protected Dictionary<ESize, GUIStyle> guiStyleDic = new Dictionary<ESize, GUIStyle>();

		public ButtonAttribute(string name)
			: this(name, ESize.Common)
		{ }

		public ButtonAttribute(string name, ESize size)
		{
			Name = name;
			SizeType = size;
			Style = GetGUIStyle();
			BgColor = Color.white;
		}

		public ButtonAttribute(string name, ESize size, EColor colorType)
		{
			Name = name;
			SizeType = size;
			Style = GetGUIStyle();
			BgColor = ParseColorType(colorType);
		}

		public ButtonAttribute(string name, ESize size, float colorR, float colorG, float colorB)
		{
			Name = name;
			SizeType = size;
			Style = GetGUIStyle();
			BgColor = new Color(colorR, colorG, colorB);
		}

		private GUIStyle GetGUIStyle()
		{
			GUIStyle result = null;
			if (!guiStyleDic.TryGetValue(SizeType, out result))
			{
				if (SizeType == ESize.Common)
				{
					result = new GUIStyle("Button");
				}
				else if (SizeType == ESize.Mini)
				{
					result = new GUIStyle("minibutton");
				}
				else if (SizeType == ESize.Large)
				{
					result = new GUIStyle("LargeButton");
				}
				if (result != null)
				{
					guiStyleDic.Add(SizeType, result);
				}
			}
			return result;
		}

		private Color ParseColorType(EColor colorType)
		{
			Color c = Color.white;
			if (colorType == EColor.White) { c = Color.white; }
			else if (colorType == EColor.Black) { c = Color.black; }
			else if (colorType == EColor.Gray) { c = Color.gray; }
			else if (colorType == EColor.Red) { c = new Color(1.0f, 0.5f, 0.5f); }
			else if (colorType == EColor.Green) { c = new Color(0.5f, 1.0f, 0.5f); }
			else if (colorType == EColor.Blue) { c = new Color(0.5f, 0.5f, 1.0f); }
			else if (colorType == EColor.Yellow) { c = new Color(1.0f, 1.0f, 0.5f); }
			else if (colorType == EColor.Cyan) { c = new Color(0.5f, 1.0f, 1.0f); }
			else if (colorType == EColor.Magenta) { c = new Color(1.0f, 0.5f, 1.0f); }
			return c;
		}
	}
}
