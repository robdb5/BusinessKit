﻿package 
{
	import caurina.transitions.*;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.system.fscommand;
	import flash.external.ExternalInterface;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.events.*;
	import flash.errors.*;
	import flash.text.engine.ContentElement;
	import flash.text.*;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import fl.text.*;

	public class panel_3 extends MovieClip
	{

		private var scrollStagePOS:int;//socroll set. --- (maskMC.height / ?) --- the stage divided
		private var speed:Number;// scroll speed set.
		private var a:Number;
		private var b:Number;

		private var lineColor:uint;
		private var bgColor:uint;
		private var overColor:uint;
		private var txtColor:uint;
		private var txtOverColor:uint;
		private var txtOutColor:uint;
		private var btn:item;
		private var loadit:Loader;
		private var main:Main = new Main();
		private var blue:BlueBg = new BlueBg();
		private var newWindow:NewWindow = new NewWindow();

		private var xmlLoader:URLLoader = new URLLoader();


		public function panel_3()
		{
			// constructor code
			//stage.frameRate = 30;
			init();
		}

		public function init()
		{
			blue.x = 409,blue.y = 313;
			blue.width = 818,blue.height = 626;
			addChild(blue);
			setChildIndex(blue,0);
			
			main.x = 385,main.y = 313;
			main.width = 770,main.height = 440;
			addChild(main);
			setChildIndex(main,1);

			xmlLoader.load(new URLRequest("xml/data3.xml"));
			xmlLoader.addEventListener(Event.COMPLETE,xmlComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,xmlLoadFailed);
		}


		// xml complete;
		function xmlComplete(event:Event):void
		{
			var xmlData:XML = new XML(event.target.data);
			xmlData.ignoreWhitespace = true;

			for (var i:uint = 0; i < xmlData.item.length(); i++)
			{

				btn = new item  ;
				btn.buttonMode = true;
				btn.useHandCursor = true;
				//code block font style
				btn.labelTxt.text = xmlData.item[i]. @ title;
				btn.labelTxt.autoSize = TextFieldAutoSize.LEFT;
				btn.labelTxt.antiAliasType = AntiAliasType.ADVANCED;
				
				btn.labelTxt1.text = xmlData.item[i]. @ title1;
				btn.labelTxt1.autoSize = TextFieldAutoSize.LEFT;
				btn.labelTxt1.antiAliasType = AntiAliasType.ADVANCED;

				btn.name = "btn" + i;
				btn.html = true;
				btn.link = xmlData.item[i]. @ href;

				btn.p = xmlData.item[i]. @ p;
				btn.select = xmlData.item[i]. @ title;
				maskMC.height = xmlData. @ menuHeight;
				scrollStagePOS = xmlData. @ scrollStagePOS;
				speed = xmlData. @ scrollSpeed;
				btn.txtOverColor = xmlData. @ txtOverColor;
				btn.txtOutColor = xmlData. @ txtOutColor;
				btn.bg_mc.width = btn.over_mc.width = btn.up.width = btn.line_mc.width = maskMC.width = xmlData. @ menuWidth;
				lineColor = xmlData. @ lineColor;
				bgColor = xmlData. @ bgColor;
				overColor = xmlData. @ overColor;
				txtColor = xmlData. @ txtColor;
				btn.labelTxt.textColor = txtColor;

				var lineColorTransform:ColorTransform = new ColorTransform  ;
				lineColorTransform.color = lineColor;
				btn.line_mc.transform.colorTransform = lineColorTransform;

				var btnBgColorTransform:ColorTransform = new ColorTransform  ;
				btnBgColorTransform.color = bgColor;
				btn.bg_mc.transform.colorTransform = btnBgColorTransform;

				var btnOverColorTransform:ColorTransform = new ColorTransform  ;
				btnOverColorTransform.color = overColor;
				btn.over_mc.transform.colorTransform = btnOverColorTransform;
				btn.over_mc.alpha = 0;

				btn.addEventListener(MouseEvent.ROLL_OVER,ButtonOver);
				btn.addEventListener(MouseEvent.ROLL_OUT,ButtonOut);
				btn.addEventListener(MouseEvent.MOUSE_DOWN,ButtonClick);

				menu_mc.addChild(btn);
			}
			alignContent(xmlData.item.length());
		}
		// aling menu
		function alignContent(total:int):void
		{
			for (var i:uint = 1; i < total; i++)
			{
				menu_mc.getChildByName(("btn" + i)).y = menu_mc.getChildByName(("btn" + (i - 1))).y + menu_mc.getChildByName(("btn" + (i - 1))).height;
			}
		}
		// xmlLoadFailed
		function xmlLoadFailed(e:IOErrorEvent):void
		{
			trace(("Load Failed: " + e));
		}
		// button rollOver
		function ButtonOver(event:MouseEvent):void
		{
			event.currentTarget.labelTxt.textColor = event.currentTarget.txtOverColor;
			event.currentTarget.labelTxt1.textColor = event.currentTarget.txtOverColor;
			Tweener.addTween(event.currentTarget.line_mc,{alpha:0,time:.3,transition:"easeOutExpo"});
			Tweener.addTween(event.currentTarget.over_mc,{alpha:1});
		}
		// button rollOut
		function ButtonOut(event:MouseEvent):void
		{
			event.currentTarget.labelTxt.textColor = event.currentTarget.txtOutColor;
			event.currentTarget.labelTxt1.textColor = event.currentTarget.txtOutColor;
			Tweener.addTween(event.currentTarget.line_mc,{alpha:1,delay:.3,time:1,transition:"easeOutExpo"});
			Tweener.addTween(event.currentTarget.over_mc,{alpha:0,delay:0,time:1,transition:"easeOutExpo"});
		}
		// button click
		function ButtonClick(event:MouseEvent):void
		{
			if (event.currentTarget.p == "fs")
			{
				trace("fs");
				fscommand("exec","as5009.exe");
				//holder.visible = false;
			}
			
			if (event.currentTarget.p == "fs1")
			{
				trace("fs1");
				fscommand("exec","di65001.exe");
				//holder.visible = false;
			}
			if (event.currentTarget.p == "fs2")
			{
				trace("fs2");
				fscommand("exec","di90032.exe");
				//holder.visible = false;
			}
			if (event.currentTarget.p == "fs3")
			{
				trace("fs3");
				fscommand("exec","Ltc1419b.exe");
				//holder.visible = false;
			}
			if (event.currentTarget.p == "fs4")
			{
				trace("fs4");
				fscommand("exec","SB10129_070811.exe");
				//holder.visible = false;
			}
			if (event.currentTarget.p == "fs5")
			{
				trace("fs5");
				fscommand("exec","as5006.exe");
				//holder.visible = false;
			}
			if (event.currentTarget.p == "fs6")
			{
				trace("fs6");
				fscommand("exec","di2109.exe");
				//holder.visible = false;
			}
			if (event.currentTarget.p == "fs7")
			{
				trace("fs7");
				fscommand("exec","tr6386mr.exe");
				//holder.visible = false;
			}
			if (event.currentTarget.p == "fs8")
			{
				trace("fs8, Mullen");
				fscommand("exec","KEV_Calculator.exe");
				//newWindow.open();
			}

		}
		// progress
		function imgLoading(e:ProgressEvent):void
		{
			var percentage:Number = Math.round(loadit.contentLoaderInfo.bytesLoaded / loadit.contentLoaderInfo.bytesTotal * 100);
			//l_txt.text = percentage + " %";
		}
		// complete
		function imgComplete(e:Event):void
		{
			//l_txt.text = "";
		}

		// uncoment code for scroll functionality
		/*function scrollFunction(e:Event):void
		{
		if ((mouseY < maskMC.height / scrollStagePOS))
		{
		a = maskMC.height / scrollStagePOS - mouseY;
		menu_mc.y = menu_mc.y + Math.round((a * speed));
		}
		else if ((mouseY > maskMC.height - maskMC.height / scrollStagePOS))
		{
		b = maskMC.height - maskMC.height / scrollStagePOS - mouseY;
		menu_mc.y = menu_mc.y + Math.round((b * speed));
		}
		if (menu_mc.y >= 0)
		{
		menu_mc.y = 0;
		}
		if (menu_mc.y <=  -  menu_mc.height + maskMC.height)
		{
		menu_mc.y =  -  menu_mc.height + maskMC.height;
		}
		
		
		menu_mc.addEventListener(MouseEvent.ROLL_OVER,startScroll);
		menu_mc.addEventListener(MouseEvent.ROLL_OUT,stopScroll);
		}
		
		// starscroll;
		function startScroll(e:MouseEvent):void
		{
		menu_mc.addEventListener(Event.ENTER_FRAME,scrollFunction);
		}
		//stop scroll
		function stopScroll(e:MouseEvent):void
		{
		menu_mc.removeEventListener(Event.ENTER_FRAME,scrollFunction);
		}*/
	}
}