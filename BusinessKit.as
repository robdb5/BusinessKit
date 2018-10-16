package 
{

	import gs.TweenLite;
	import gs.easing.*;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.display.*;
	import flash.events.*;
	import flash.errors.*;
	import flash.utils.*;
	import fl.events.*;

	public class BusinessKit extends MovieClip
	{

		private var menu:Array;//used to save the items data
		private var opened_menu:int;// tells menu to open at startup
		private var move_if_mouse_over:Boolean = false;//tha name says everything
		private var xmlLoader:URLLoader;// xml loader
		private var busPanel:BusinessPanel = new BusinessPanel();
		private var tmr:Timer;
		public var toolTip:ToolTip = new ToolTip('Double Click to Exit');

		public function BusinessKit()
		{
			// constructor code
			stage.frameRate = 30;
			init();
		}

		function init()
		{


			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			fscommand("fullscreen", "true");
			fscommand("allowscale", "true");

			busPanel.x = 882,busPanel.y = 313.15;
			busPanel.width = 818,busPanel.height = 626;
			addChild(busPanel);
			setChildIndex(busPanel,4);
			busPanel.visible = true;

			footer.closeMain.buttonMode = true;
			footer.closeMain.mouseEnabled = true;
			footer.closeMain.useHandCursor = true;

			footer.exitBtn.buttonMode = true;
			footer.exitBtn.mouseEnabled = true;
			footer.exitBtn.useHandCursor = true;

			footer.videoBtn.buttonMode = true;
			footer.videoBtn.mouseEnabled = true;
			footer.videoBtn.useHandCursor = true;

			toolTip.x = -430,toolTip.y = -35;
			toolTip.width = 250,toolTip.height = 35;
			footer.exitBtn.addChild(toolTip);
			footer.exitBtn.setChildIndex(toolTip,1);
			toolTip.visible = false;
			toolTip.start();

			footer.videoBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			footer.closeMain.addEventListener(MouseEvent.CLICK,onMouseClick);
			footer.exitBtn.addEventListener(MouseEvent.CLICK,exitClicked);

			footer.exitBtn.mouseChildren = false;
			footer.exitBtn.doubleClickEnabled = true;
			footer.exitBtn.addEventListener(MouseEvent.DOUBLE_CLICK,exitDoubleClicked);

			loadXML("xml/menu.xml");

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

			trace(event.target + " is complete!");

			menu = prepareMenu(xmlLoader.data.toString());
			placeItemsOnStage();
		}

		function errorHandler(event:ErrorEvent):void
		{
			trace(((("error occured with " + event.target) + ": ") + event.text));
		}


		function placeItemsOnStage():void
		{
			var pos:Number = 0;
			//define the container properties
			menuContainer.x = 0;
			menuContainer.y = 0;

			for (var c:int = 0; c < menu.length; c++)
			{
				var it:menuItem = new menuItem  ;//load out menuItem, because its exported to AS, we can use it here
				it.x = c * 79;//its the gray border width
				it.y = 0;//place on top
				it.id = "Item-" + c;//id the menuItem
				it.name = "Item-" + c;//name of menuItem
				it.posX = pos;//actual pos, useful to open and know position
				it.itemLabel.text = String(menu[c].Ititle);//load the label in uppercase

				it.useHandCursor = true;//use hand cursor
				it.buttonMode = true;

				it.addEventListener(MouseEvent.CLICK,onMouseClick);

				if ((move_if_mouse_over == true))
				{
					it.addEventListener(MouseEvent.CLICK,onMouseOver);
				}

				it.itemText.visible = false;//hide the textField
				menuContainer.addChild(it);


				//add the menu item as child;
				if ((String(menu[c].IcontentType) == "image/swf"))
				{//check the content and load things according to it
					var loader:Loader = new Loader  ;
					loader.x = 10;
					loader.y = 15;
					it.addChild(loader);
					loader.load(new URLRequest(menu[c].IcontentData.toString()));
				}

				if ((String(menu[c].IcontentType) == "image/swf"))
				{//check the content and load things according to it
					var loader1:Loader = new Loader  ;
					loader1.x = 79;
					loader1.y = 0;
					it.addChild(loader1);
					loader1.load(new URLRequest(menu[c].IcontentData1.toString()));

				}

				if ((String(menu[c].IcontentType2) == "image/swf"))
				{//check the content and load things according to it
					var loader2:Loader = new Loader  ;
					loader2.x = 0;
					loader2.y = 0;
					it.addChild(loader2);
					loader2.load(new URLRequest(menu[c].IcontentData2.toString()));

				}
				else if ((String(menu[c].IcontentType) == "text"))
				{
					it.itemText.visible = true;
					it.itemText.text = menu[c].IcontentData.toString();
				}
				pos +=  79;//the next menuItem x position


				//put mask in place / adjust width
				masker.width = menu.length * 79 + 725;
				masker.height = menuContainer.height;
				masker.x = 0;
				masker.y = 0;
			}
		}


		function onMouseOver(evt:MouseEvent):void
		{

			if (evt.target.name.toString() == "buttonBack")
			{
				prepareMove(evt);
			}

		}

		function onMouseOut(evt:MouseEvent):void
		{

			trace("onMouseOut");
		}
		function prepareMove(evt:MouseEvent):void
		{
			var targetName:String = evt.currentTarget.name.toString();//get the menuItem
			var temp:Array = targetName.split("-");//split his name: Item-x
			var itemNumber:int = temp[1];//got item number
			moveItem(itemNumber);//move it
		}

		function onMouseClick(evt:MouseEvent):void
		{
			if (evt.target.name.toString() == "buttonBack")
			{
				prepareMove(evt);//mouse action was done in buttonBack
				busPanel.visible = false;
			}

			if (evt.target.name.toString() == "closeMain")
			{

				var num:int;

				var itemToMove:menuItem = menuContainer.getChildByName(("Item-" + String(num))) as menuItem;
				//get the menuItem child
				for (var m = 0; m < menu.length; m++)
				{
					var tempMc = menuContainer.getChildByName(("Item-" + m));

					if (tempMc.x >= itemToMove.x)
					{
						TweenLite.to(tempMc,1,{x:tempMc.posX,ease:Quart.easeIn});

					}
					trace((("close" + evt.currentTarget.name) + " clicked!"));
				}


				initTimer();

			}

			if (evt.target.name.toString() == "videoBtn")
			{
				trace((("videoBtn" + evt.currentTarget.name) + " clicked!"));
				busPanel.visible = false;
				
				var num1:int;

				var itemToMove1:menuItem = menuContainer.getChildByName(("Item-" + String(num1))) as menuItem;
				//get the menuItem child
				for (var m1 = 0; m1 < menu.length; m1++)
				{
					var tempMc1 = menuContainer.getChildByName(("Item-" + m1));

					if (tempMc1.x >= itemToMove1.x)
					{
						TweenLite.to(tempMc1,1,{x:tempMc1.posX,ease:Quart.easeIn});

					}
					trace((("close" + evt.currentTarget.name) + " clicked!"));
				}

			}


		}

		private function initTimer():void
		{
			tmr = new Timer(1000,1);
			tmr.addEventListener(TimerEvent.TIMER, handleTimer);
			//tmr.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerResult);
			tmr.start();
		}

		function handleTimer(event:TimerEvent):void
		{

			//trace((("showBusPanel" + event.currentTarget.name) + " clicked!"));
			busPanel.visible = true;
			tmr.stop();
		}

		function moveItem(num:int):void
		{
			var itemToMove:menuItem = menuContainer.getChildByName(("Item-" + String(num))) as menuItem;
			//get the menuItem child
			for (var m = 0; m < menu.length; m++)
			{
				var tempMc = menuContainer.getChildByName(("Item-" + m));

				if (tempMc.x > itemToMove.x)
				{
					TweenLite.to(tempMc,1,{x:tempMc.posX + itemToMove.width - 79,ease:Quart.easeOut});
				}


				if (tempMc.x <= itemToMove.x)
				{
					TweenLite.to(tempMc,1,{x:tempMc.posX,ease:Quart.easeOut});
				}
			}
		}


		function prepareMenu(XMLData:String):Array
		{
			var menuXML:XML = new XML(XMLData);

			//just in case
			menuXML.ignoreWhitespace = true;


			//get XML item's entrys
			var XMLItems = menuXML.descendants("item");


			//load all items into an array
			var itemsArray:Array = new Array  ;


			var itemObj:Object;


			for (var i in XMLItems)
			{
				itemObj = new Object  ;
				itemObj.Ititle = XMLItems[i]. @ Ititle;
				itemObj.IcontentType = XMLItems[i]. @ IcontentType;
				itemObj.IcontentType1 = XMLItems[i]. @ IcontentType1;
				itemObj.IcontentType2 = XMLItems[i]. @ IcontentType2;
				itemObj.IcontentData = XMLItems[i]. @ IcontentData;
				itemObj.IcontentData1 = XMLItems[i]. @ IcontentData1;
				itemObj.IcontentData2 = XMLItems[i]. @ IcontentData2;
				itemObj.itemID = "menu" + i;
				itemsArray.push(itemObj);
			}

			opened_menu = menuXML. @ menuOpen;//get menu for open.
			move_if_mouse_over = menuXML. @ moveOnMouseOver.toString() == "true" ? true:false;//get the option for load or not mouseOver open
			return itemsArray;
		}

		function exitClicked(event:MouseEvent):void
		{
			//fscommand("quit");
			toolTip.visible = true;
		}
		
		function exitDoubleClicked(event:MouseEvent):void
		{
			fscommand("quit");
		}




	}

}