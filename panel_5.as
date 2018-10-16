package  
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

	public class panel_5 extends MovieClip
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

		private var blue:BlueBg = new BlueBg();
		private var main:Main = new Main();

		private var xmlLoader:URLLoader = new URLLoader();


		public function panel_5()
		{
			// constructor code
			//stage.frameRate = 30;
			init();
		}

		public function init()
		{
			//brOver.visible = false;
			//br1Over.visible = false;
			
			blue.x = 409,blue.y = 313;
			blue.width = 818,blue.height = 626;
			addChild(blue);
			setChildIndex(blue,0);

			main.x = 385,main.y = 350;
			main.width = 770,main.height = 440;
			addChild(main);
			setChildIndex(main,1);

			xmlLoader.load(new URLRequest("xml/data5.xml"));
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
				btn.mouseEnabled = true;
				btn.useHandCursor = true;
				btn.x = -5, btn.y = 75;
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
				btn.labelTxt1.textColor = txtColor;

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
				
				brOut.addEventListener(MouseEvent.MOUSE_OVER, brochureHandler);
				brOver.addEventListener(MouseEvent.MOUSE_OUT, brochureHandler);
				//br1Out.addEventListener(MouseEvent.MOUSE_OVER, brochureHandler);
				//br1Over.addEventListener(MouseEvent.MOUSE_OUT, brochureHandler);

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
			
			if (event.currentTarget.p == "fs3")
			{
				trace("fs3");
				brOut.visible = false;
				brOver.visible = true;
			}
			if (event.currentTarget.p == "fs10")
			{
				trace("fs10");
				//br1Out.visible = false;
				//br1Over.visible = true;
			}
		}
		// button rollOut
		function ButtonOut(event:MouseEvent):void
		{
			event.currentTarget.labelTxt.textColor = event.currentTarget.txtOutColor;
			event.currentTarget.labelTxt1.textColor = event.currentTarget.txtOutColor;
			Tweener.addTween(event.currentTarget.line_mc,{alpha:1,delay:.3,time:1,transition:"easeOutExpo"});
			Tweener.addTween(event.currentTarget.over_mc,{alpha:0,delay:0,time:1,transition:"easeOutExpo"});
			
			if (event.currentTarget.p == "fs3")
			{
				trace("fs3");
				brOut.visible = true;
				brOver.visible = false;
			}
			if (event.currentTarget.p == "fs10")
			{
				trace("fs10");
				//br1Out.visible = true;
				//br1Over.visible = false;
			}
		}
		// button click
		function ButtonClick(event:MouseEvent):void
		{
			if (event.currentTarget.p == "fs")
			{
				trace("fs");
				fscommand("exec","SB10109A_0916HR.exe");
			}

			if (event.currentTarget.p == "fs1")
			{
				trace("fs1");
				fscommand("exec","SB10188_100311.exe");

			}
			
			if (event.currentTarget.p == "fs2")
			{
				trace("fs2");
				fscommand("exec","SB10221.exe");
				brOut.visible = false;
				brOver.visible = true;

			}

			if (event.currentTarget.p == "fs3")
			{
				trace("fs3");
				fscommand("exec","WMI1559.exe");
			}

			if (event.currentTarget.p == "fs4")
			{
				trace("fs4");
				fscommand("exec","hispanic.exe");
			}

			if (event.currentTarget.p == "fs5")
			{
				trace("fs5");
				fscommand("exec","africanam.exe");
			}

			if (event.currentTarget.p == "fs6")
			{
				trace("fs6");
				fscommand("exec","chinese.exe");
			}

			if (event.currentTarget.p == "fs7")
			{
				trace("fs7");
				fscommand("exec","korean.exe");
			}

			if (event.currentTarget.p == "fs8")
			{
				trace("fs8");
				fscommand("exec","asianindian.exe");
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
		
		function brochureHandler(event:MouseEvent):void
		{

			// handles brochure over /out state
			switch (event.currentTarget)
			{

				case brOut :
					//trace("brOut: " + event.currentTarget);
					brOut.visible = false;
					brOver.visible = true;
					//this.addEventListener(MouseEvent.ROLL_OVER,ButtonOver);
					break;
				case brOver :
					//trace("brOver: " + event.currentTarget);
					brOut.visible = true;
					brOver.visible = false;
					//this.addEventListener(MouseEvent.ROLL_OUT,ButtonOut);
					break;
				/*case br1Out :
					trace("br1Out: " + event.currentTarget);
					br1Out.visible = false;
					br1Over.visible = true;
					break;
				case br1Over :
					trace("br1Over: " + event.currentTarget);
					br1Out.visible = true;
					br1Over.visible = false;
					break;*/
			}

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