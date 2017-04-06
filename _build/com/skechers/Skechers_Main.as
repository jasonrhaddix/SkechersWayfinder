package com.skechers
{
	//********************************************************************
	// Flash Imports
	//********************************************************************
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.ui.*;
	import flash.media.*;
	import flash.net.*;
	
	
	//********************************************************************
	// Skechers Imports
	//********************************************************************
	import com.skechers.ExitApplication;


	//********************************************************************
	//********************************************************************
	// GreenSock Imports
	//********************************************************************
	import com.greensock.*;
	import com.greensock.easing.*;


	//********************************************************************
	// Blacklisted Imports
	//********************************************************************
	import com.blacklisted.utils.*;
	import com.blacklisted.*;


	//********************************************************************
	// PQ Labs Imports
	//********************************************************************
	/*
	import pq.multitouch.*;
	import pq.multitouch.events.*;
	import pq.multitouch.gestures.*;
	*/




	public class Skechers_Main extends Sprite
	{
		//*********************************************************
		// CONSTANTS
		//*********************************************************
		public static const STAGE_WIDTH                      :int = 1920;
		public static const STAGE_HEIGHT                     :int = 1080;
		private static const FLOOR_POS_SHIFT_AMOUNT          :int = 150;
		private static const FLOOR_PLACEMENT_DIST            :int = 1000;
		private static const TOP_FLOOR                       :int = 3;
		private static const BOTTOM_FLOOR                    :int = 1;
		private static const FLOOR_CHANGE_SCROLL_SPEED       :int = 1;
		private static const LOCK_NAV_TIMEOUT                :Number = 3.2;//sec

		public const STARTING_FLOOR                          :int = 2;


		//*********************************************************
		// VARIABLES
		//*********************************************************

		// 3D Perspective
		private var perspective3D:PerspectiveProjection;


		// Components
		private var mapFloor_Container_Mask                  : Sprite;
		public var mapFloor_Container                        : Sprite;
		public var mapFloor1                                 : MapFloor_1;
		public var mapFloor2                                 : MapFloor_2;
		public var mapFloor3                                 : MapFloor_3;
		public var navigation                                : Navigation;
		public var infoBar                                   : InfoBar;
		public var rightBar                                  : RightBar;
		public var thumbPrint                                : ThumbPrint;


		// Floor Position Control
		public var currentFloor                              : int = 2;


		// Gestures
		//public var flickGesture                              : BaseGesture;


		// Video Background
		private var videoBg_Container                        : Sprite;
		private var videoBg_Player                           : Video;
		private var videoBg_NetConnection                    : NetConnection;
		private var videoBg_NetStream                        : NetStream;
		private var videoBg_ConnectionReady                  : Boolean = false;
		private var videoBg_IsComplete                       : Boolean = false;
		
		
		// Exiting Script
		public var exitApp                                   : ExitApplication;
		private var mouseShowing                             : Boolean = false;




		//*********************************************************
		// Constructor
		//*********************************************************
		public function Skechers_Main()
		{
			// Hide Mouse
			hideMouse();
			stage.addEventListener( KeyboardEvent.KEY_DOWN, reportKeyDown );
			//stage.addEventListener( KeyboardEvent.KEY_UP, reportKeyUp );
			
			// Add Variables and Constants to GlobalVarContainer
			addToGlobalVarContainer();


			// Define stage properties
			//swfStage  = mainContent.stage;
			stage.align = StageAlign.TOP_LEFT;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.scaleMode = StageScaleMode.NO_SCALE;


			//3D Perspective
			perspective3D = new PerspectiveProjection();
			perspective3D.fieldOfView = 80.0;
			perspective3D.projectionCenter = new Point(stage.stageWidth / 2,stage.stageHeight / 2);
			root.transform.perspectiveProjection = perspective3D;


			// Connect to display || add TouchViewer to stage ( for debugging )
			//MultiTouch.init(stage, connectFailed);
			//stage.addChild(TouchViewer.getInstance());


			// Map Floor Container Mask
			mapFloor_Container_Mask = new Sprite();
			mapFloor_Container_Mask.x = 0;
			mapFloor_Container_Mask.y = 40;
			mapFloor_Container_Mask.graphics.beginFill( 0x00CCFF, 1 );
			mapFloor_Container_Mask.graphics.drawRect( 0, 0, stage.stageWidth, 763 );
			mapFloor_Container_Mask.graphics.endFill();


			// Map Floor Container;
			mapFloor_Container = new Sprite();
			mapFloor_Container.x = stage.stageWidth / 2;
			mapFloor_Container.y = ( stage.stageHeight / 2 ) - FLOOR_POS_SHIFT_AMOUNT;
			mapFloor_Container.mask = mapFloor_Container_Mask;


			// Floor 1
			mapFloor1 = new MapFloor_1();
			mapFloor1.x = -15;
			mapFloor1.y = FLOOR_PLACEMENT_DIST;

			// Floor 2
			mapFloor2 = new MapFloor_2();
			mapFloor2.x = 15;
			mapFloor2.y = 0;


			//Floor 3
			mapFloor3 = new MapFloor_3();
			mapFloor3.x = -15;
			mapFloor3.y =  -  FLOOR_PLACEMENT_DIST;


			// Infor Bar
			infoBar = new InfoBar();
			infoBar.x = 0;
			infoBar.y = 0;


			// Right Bar
			rightBar = new RightBar();
			rightBar.x = stage.stageWidth;
			rightBar.y = ( stage.stageHeight / 2 ) - FLOOR_POS_SHIFT_AMOUNT;


			// Navigation
			navigation = new Navigation();
			navigation.x = 0;
			navigation.y = stage.stageHeight - 285;
			
			
			// ThumbPrint
			thumbPrint = new ThumbPrint();
			thumbPrint.x = 70;
			thumbPrint.y = 125;


			// Video Background
			initVideoBackground();

			// Add all Components to stage
			addComponentsToStage();

			// Add all Components to stage
			defineStageButtons();

			// Add Gestures
			//addPQLabsGestures();
			
			// Init Closing Script
			exitApp = new ExitApplication();

		}





		//*********************************************************
		// Add Variables and Constants to GlobalVarContainer
		//*********************************************************
		private function addToGlobalVarContainer():void
		{
			// Add Constants
			GlobalVarContainer.consts._STAGE_WIDTH = STAGE_WIDTH;
			GlobalVarContainer.consts._STAGE_HEIGHT = STAGE_HEIGHT;

			// Add Variables
			GlobalVarContainer.vars._main = this;
			GlobalVarContainer.stage._stage = stage;

		}





		//*********************************************************
		// Add all components to stage
		//*********************************************************
		private function addComponentsToStage():void
		{
			videoBg_Container.addChild( videoBg_Player );
			addChild( videoBg_Container );

			mapFloor_Container.addChild( mapFloor1 );
			mapFloor_Container.addChild( mapFloor2 );
			mapFloor_Container.addChild( mapFloor3 );
			addChild( mapFloor_Container_Mask );
			addChild( mapFloor_Container );

			addChild( infoBar );
			addChild( rightBar );
			addChild( navigation );
			addChild( thumbPrint );

		}





		private function defineStageButtons():void
		{
			//rightBar.rightBar_Art.floorUp_btn.buttonMode = true;
			rightBar.rightBar_Art.floorUp_btn.mouseChildren = false;
			rightBar.rightBar_Art.floorUp_btn._floorDirec = "up";
			rightBar.rightBar_Art.floorUp_btn.addEventListener( MouseEvent.CLICK, moveToFloor );

			//rightBar.rightBar_Art.floorDown_btn.buttonMode = true;
			rightBar.rightBar_Art.floorDown_btn.mouseChildren = false;
			rightBar.rightBar_Art.floorDown_btn._floorDirec = "down";
			rightBar.rightBar_Art.floorDown_btn.addEventListener( MouseEvent.CLICK, moveToFloor );

			//startApp_btn.buttonMode = true;
			//startApp_btn.addEventListener( MouseEvent.CLICK, startApp );

		}




		
		public function addPQLabsGestures():void
		{
			//flickGesture = MultiTouch.enableGesture( mapFloor_Container, new FlickGesture(), onFlick );

		}





		private function startApp( e:MouseEvent ):void
		{
			stage.displayState = StageDisplayState.FULL_SCREEN;

		}





		//*********************************************************
		// Handle floor-floor animation | Flick
		//*********************************************************
		/*
		public function onFlick( e:FlickEvent ):void
		{

			if (e.direction == Direction.UP || e.direction == Direction.DOWN)
			{

				lockNavigation();

				if (e.direction == Direction.DOWN && currentFloor < TOP_FLOOR)
				{
					++currentFloor;

				}
				else if ( e.direction == Direction.UP  && currentFloor > BOTTOM_FLOOR )
				{
					--currentFloor;
				}


				switch ( currentFloor )
				{
					case 1 :
						if (! navigation.isRouting)
						{
							mapFloor1.set_FloorToFloor();
							mapFloor1.animate_FloorToFloor();
						}

						TweenMax.to( mapFloor_Container, FLOOR_CHANGE_SCROLL_SPEED, { y:(( stage.stageHeight / 2 ) - FLOOR_POS_SHIFT_AMOUNT ) - FLOOR_PLACEMENT_DIST, ease:Expo.easeOut, delay:0.0 });

						break;

					case 2 :
						if (! navigation.isRouting)
						{
							mapFloor2.set_FloorToFloor();
							mapFloor2.animate_FloorToFloor();
						}

						TweenMax.to( mapFloor_Container, FLOOR_CHANGE_SCROLL_SPEED, { y:( stage.stageHeight / 2 ) - FLOOR_POS_SHIFT_AMOUNT, ease:Expo.easeOut, delay:0.0 });

						break;

					case 3 :
						if (! navigation.isRouting)
						{
							mapFloor3.set_FloorToFloor();
							mapFloor3.animate_FloorToFloor();
						}

						TweenMax.to( mapFloor_Container, FLOOR_CHANGE_SCROLL_SPEED, { y:(( stage.stageHeight / 2 ) - FLOOR_POS_SHIFT_AMOUNT ) + FLOOR_PLACEMENT_DIST, ease:Expo.easeOut, delay:0.0 });

						break;

					default :
						trace( "MoveToFloor : Floor num out of bounds!" );

				}

				rightBar.selectFloor( currentFloor );

				setTimeout( unlockNavigation, ( LOCK_NAV_TIMEOUT * 1000 ) );

			}

			e.stopImmediatePropagation();

		}
		*/




		//*********************************************************
		// Handle floor-floor animation | Button Press
		//*********************************************************
		public function moveToFloor( e:MouseEvent ):void
		{
			lockNavigation();

			if (e.target._floorDirec == "up" && currentFloor < TOP_FLOOR)
			{
				++currentFloor;

			}
			else if ( e.target._floorDirec == "down" && currentFloor > BOTTOM_FLOOR )
			{
				--currentFloor;
			}
			else
			{
				return;
			}


			moveToFloor_Animate( currentFloor );

		}





		public function moveToFloor_Animate( floorNum:int, $onSelect:Boolean=false ):void
		{
			currentFloor = floorNum;

			switch ( floorNum )
			{
				case 1 :
					if (! $onSelect && ! navigation.isRouting)
					{
						mapFloor1.set_FloorToFloor();
						mapFloor1.animate_FloorToFloor();
					}
					TweenMax.to( mapFloor_Container, FLOOR_CHANGE_SCROLL_SPEED, { y:(( stage.stageHeight / 2 ) - FLOOR_POS_SHIFT_AMOUNT ) - FLOOR_PLACEMENT_DIST, ease:Expo.easeInOut, delay:0.0 });

					break;

				case 2 :
					if (! $onSelect && ! navigation.isRouting)
					{
						mapFloor2.set_FloorToFloor();
						mapFloor2.animate_FloorToFloor();
					}
					TweenMax.to( mapFloor_Container, FLOOR_CHANGE_SCROLL_SPEED, { y:( stage.stageHeight / 2 ) - FLOOR_POS_SHIFT_AMOUNT, ease:Expo.easeInOut, delay:0.0 });

					break;

				case 3 :
					if (! $onSelect && ! navigation.isRouting)
					{
						mapFloor3.set_FloorToFloor();
						mapFloor3.animate_FloorToFloor();
					}
					TweenMax.to( mapFloor_Container, FLOOR_CHANGE_SCROLL_SPEED, { y:(( stage.stageHeight / 2 ) - FLOOR_POS_SHIFT_AMOUNT ) + FLOOR_PLACEMENT_DIST, ease:Expo.easeInOut, delay:0.0 });

					break;

				default :
					trace( "MoveToFloor : Floor num out of bounds!" );

			}


			rightBar.selectFloor( floorNum );

			setTimeout( unlockNavigation, ( LOCK_NAV_TIMEOUT * 1000 ) );

		}





		public function lockNavigation():void
		{
			//setTimeout( disableGestures, 50);

			rightBar.mouseEnabled = false;
			rightBar.mouseChildren = false;

		}


		public function unlockNavigation():void
		{
			//addPQLabsGestures();

			rightBar.mouseEnabled = true;
			rightBar.mouseChildren = true;

		}





		public function lockNavigation_Routing():void
		{
			//setTimeout( disableGestures, 50);

			//navigation.alpha = 0.5;
			//rightBar.alpha = 0.5;

			TweenMax.killTweensOf( navigation, false );
			TweenMax.killTweensOf( rightBar, false );

			TweenMax.to( navigation, 0.75, { alpha:0.5, delay:0.25 });
			TweenMax.to( rightBar, 0.75, { alpha:0.5, delay:0.25 });

			rightBar.mouseEnabled = false;
			rightBar.mouseChildren = false;

			navigation.navigation_art.mouseEnabled = false;
			navigation.navigation_art.mouseChildren = false;

			mapFloor1.mapFloor_1_Art.mouseEnabled = false;
			mapFloor1.mapFloor_1_Art.mouseChildren = false;

			mapFloor2.mapFloor_2_Art.mouseEnabled = false;
			mapFloor2.mapFloor_2_Art.mouseChildren = false;

			mapFloor3.mapFloor_3_Art.mouseEnabled = false;
			mapFloor3.mapFloor_3_Art.mouseChildren = false;
		}


		public function unlockNavigation_Routing():void
		{
			//addPQLabsGestures();

			//navigation.alpha = 1;
			//rightBar.alpha = 1;

			TweenMax.killTweensOf( navigation, false );
			TweenMax.killTweensOf( rightBar, false );

			TweenMax.to( navigation, 0.75, { alpha:1, delay:0.0, overwrite:true });
			TweenMax.to( rightBar, 0.75, { alpha:1, delay:0.0, overwrite:true });

			rightBar.mouseEnabled = true;
			rightBar.mouseChildren = true;

			navigation.navigation_art.mouseEnabled = true;
			navigation.navigation_art.mouseChildren = true;

			navigation.navigation_art.mouseEnabled = true;
			navigation.navigation_art.mouseChildren = true;

			mapFloor1.mapFloor_1_Art.mouseEnabled = true;
			mapFloor1.mapFloor_1_Art.mouseChildren = true;

			mapFloor2.mapFloor_2_Art.mouseEnabled = true;
			mapFloor2.mapFloor_2_Art.mouseChildren = true;

			mapFloor3.mapFloor_3_Art.mouseEnabled = true;
			mapFloor3.mapFloor_3_Art.mouseChildren = true;

		}







		public function disableGestures():void
		{
			//MultiTouch.disableGesture( flickGesture );

		}


		/*
		// USE 'addPQLabsGestures()' to enable gestures ***********************************
		public function enableGestures():void
		{
		MultiTouch.enableGesture(mapFloor_Container, new FlickGesture(), onFlick);
		
		}
		*/





		//*********************************************************
		// PQLabs : Server connection error
		//*********************************************************
		private function connectFailed():void
		{
			trace("Failed to connect with PQ-Multi-Touch Server!");

		}





		//*********************************************************
		// Video Background
		//*********************************************************
		private function initVideoBackground():void
		{
			videoBg_Container = new Sprite();

			videoBg_Player = new Video();
			videoBg_Player.width = 1920;
			videoBg_Player.height = 1080;
			videoBg_Player.smoothing = true;

			videoBg_NetConnection = new NetConnection();
			videoBg_NetConnection.addEventListener( NetStatusEvent.NET_STATUS, onNetStatusEvent_NetConnection );
			videoBg_NetConnection.client = new Object();
			videoBg_NetConnection.connect( null );

		}





		private function onNetStatusEvent_NetConnection( infoObject:NetStatusEvent ):void
		{

			for (var prop in infoObject.info)
			{

				if ( prop == "code" && infoObject.info[prop] == "NetConnection.Connect.Success" )
				{

					videoBg_NetStream = new NetStream(videoBg_NetConnection);
					videoBg_NetStream.client = new CustomClient();
					videoBg_NetStream.bufferTime = 3;
					videoBg_Player.attachNetStream( videoBg_NetStream );

					videoBg_NetStream.addEventListener( NetStatusEvent.NET_STATUS, onStatusEvent );
					videoBg_NetConnection.removeEventListener( NetStatusEvent.NET_STATUS, onNetStatusEvent_NetConnection );

					GlobalVarContainer.vars.netStream = videoBg_NetStream;
					videoBg_ConnectionReady = true;

					videoBg_NetStream.play( "app-assets/video/BG_vid_long.mp4" );
				}

			}

		}




		private function onStatusEvent( infoObject:NetStatusEvent ):void
		{

			for (var prop in infoObject.info)
			{

				//trace("STATUS: " + "\t"+prop+":\t"+infoObject.info[prop]);

				if ( prop == "code" && infoObject.info[prop] == "NetStream.Play.Reset" )
				{
					//
				}

				if ( prop == "code" && infoObject.info[prop] == "NetStream.Play.Start" )
				{
					//
				}

				if ( prop == "code" && infoObject.info[prop] == "NetStream.Buffer.Empty" )
				{
					//
				}

				if ( prop == "code" && infoObject.info[prop] == "NetStream.Buffer.Full" )
				{
					//
				}

			}

		}





		public function replayVideoBackground():void
		{
			videoBg_NetStream.seek(0);

		}
		
		
			
		
		
		
		//************************************************************
		// Keypress Mouse SHOW/HIDE
		//************************************************************
		
		
		private function reportKeyDown(e:KeyboardEvent):void 
		{ 
			var btn = e.charCode;
			
			switch( btn )
			{
				case 0: // CTRL Button
					if( mouseShowing){
						hideMouse();
						mouseShowing = false;
					} else {
						showMouse();
						mouseShowing = true;
					}
			}
			
			//trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (character code: " + event.charCode + ")"); 
		}
		
		
		private function showMouse():void
		{
			Mouse.show();
		}
		
		private function hideMouse():void
		{
			Mouse.hide();
		}
		
	}

}