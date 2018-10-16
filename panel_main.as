package 
{
	import caurina.transitions.*;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
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
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	import flash.media.Video;
	import fl.video.FLVPlayback;
	import flash.media.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.errors.*;
	import flash.display.*;
	import flash.external.*;
	import flash.text.engine.ContentElement;
	import flash.text.*;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import fl.text.*;
	import fl.video.*;
	//import com.flashsupport.video.FLVPlaybackPro;

	public class panel_main extends MovieClip
	{

		private const SMOOTHING:Boolean = true;

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
		private var xmlLoader:URLLoader = new URLLoader();
		private var vidBtn:VidBtn = new VidBtn();
		private var delay:uint = 3000;
		private var repeat:uint = 1;
		private var tmr:Timer = new Timer(delay,repeat);
		private var vid:Video = new Video(900,550);
		private var main:Main = new Main();
		private var buttonBG:ButtonBg = new ButtonBg();

		public function panel_main()
		{
			// constructor code
			//stage.frameRate = 30;
			init();
		}

		public function init()
		{

			main.x = 409,main.y = 313;
			main.width = 818,main.height = 626;
			addChild(main);
			setChildIndex(main,0);
			main.visible = true;
			
			buttonBG.buttonMode = true;
			buttonBG.mouseEnabled = true;
			buttonBG.useHandCursor = true;
			buttonBG.visible = true;
			buttonBG.x = 650,buttonBG.y = 475;
			buttonBG.width = 288,buttonBG.height = 264;
			addChild(buttonBG);
			setChildIndex(buttonBG,1);
			
			loadXML("xml/panel_main.xml");


		}
		
		function loadXML(event:String):void
		{

			xmlLoader = new URLLoader  ;
			xmlLoader.load(new URLRequest(event));

			xmlLoader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			xmlLoader.addEventListener(Event.COMPLETE,onComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);

		}
		
		function progressHandler(evt:ProgressEvent):void
		{

			var nPercent:Number = Math.round(evt.bytesLoaded / evt.bytesTotal * 100);
			trace(("progress: " + evt.bytesLoaded));

		}
		
		function onComplete(event:Event):void
		{
			var xmlData:XML = new XML(event.target.data);
			xmlData.ignoreWhitespace = true;

			for (var i:uint = 0; i < xmlData.item.length(); i++)
			{

				btn = new item  ;
				btn.x = 80;
				btn.buttonMode = true;
				btn.mouseEnabled = true;
				btn.useHandCursor = true;
				//code block font style
				btn.labelTxt.text = xmlData.item[i]. @ title;
				btn.labelTxt.autoSize = TextFieldAutoSize.LEFT;
				btn.labelTxt.antiAliasType = AntiAliasType.ADVANCED;

				btn.name = "btn" + i;
				btn.html = true;
				btn.link = xmlData.item[i]. @ href;

				btn.p = xmlData.item[i]. @ p;
				btn.select = xmlData.item[i]. @ title;
				//btn.bold = xmlData.item[i]. @ title;
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

				var lineColorTransform:ColorTransform = new ColorTransform  ;
				lineColorTransform.color = lineColor;
				btn.line_mc.transform.colorTransform = lineColorTransform;
				btn.line_mc.alpha = 0;

				var btnBgColorTransform:ColorTransform = new ColorTransform  ;
				btnBgColorTransform.color = bgColor;
				btn.bg_mc.transform.colorTransform = btnBgColorTransform;
				btn.bg_mc.alpha = 0;

				var btnOverColorTransform:ColorTransform = new ColorTransform  ;
				btnOverColorTransform.color = overColor;
				btn.over_mc.transform.colorTransform = btnOverColorTransform;
				btn.over_mc.alpha = 0;

				btn.addEventListener(MouseEvent.ROLL_OVER,ButtonOver);
				btn.addEventListener(MouseEvent.ROLL_OUT,ButtonOut);
				btn.addEventListener(MouseEvent.CLICK,ButtonClick);

				menu_mc.addChild(btn);
				//menu_mc.setChildIndex(btn,1);
			}
			alignContent(xmlData.item.length());
		}
		
		function errorHandler(event:ErrorEvent):void
		{
			trace(((("error occured with " + event.target) + ": ") + event.text));
		}
		
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
			Tweener.addTween(event.currentTarget.line_mc,{alpha:0,time:.3,transition:"easeOutExpo"});
			Tweener.addTween(event.currentTarget.over_mc,{alpha:0});
		}
		// button rollOut
		function ButtonOut(event:MouseEvent):void
		{
			event.currentTarget.labelTxt.textColor = event.currentTarget.txtOutColor;
			Tweener.addTween(event.currentTarget.line_mc,{alpha:0,delay:.3,time:1,transition:"easeOutExpo"});
			Tweener.addTween(event.currentTarget.over_mc,{alpha:0,delay:0,time:1,transition:"easeOutExpo"});
		}
		// button click
		public function ButtonClick(event:MouseEvent):void
		{
			if (event.currentTarget.p == "fs")
			{
				trace("fs");
				fscommand("exec", "FLVPlaybackPro.exe");
			}
			if (event.currentTarget.p == "fs1")
			{
				trace("fs1");
				fscommand("exec", "FLVPlaybackPro1.exe");
			}
			if (event.currentTarget.p == "fs2")
			{
				trace("fs2");
				fscommand("exec", "FLVPlaybackPro2.exe");
			}
			if (event.currentTarget.p == "fs3")
			{
				trace("fs3");
				fscommand("exec", "FLVPlaybackPro3.exe");

			}
			if (event.currentTarget.p == "fs4")
			{
				trace("fs1");
				fscommand("exec", "FLVPlaybackPro4.exe");

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