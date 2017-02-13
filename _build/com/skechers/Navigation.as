package com.skechers
{
	//********************************************************************
	// Flash Imports
	//********************************************************************
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	
	//********************************************************************
	// PQ Labs Imports
	//********************************************************************
	/*
	import pq.multitouch.*;
	import pq.multitouch.events.*;
	import pq.multitouch.gestures.*;
	*/

	//********************************************************************
	// GreenSock Imports
	//********************************************************************
	import com.greensock.*;
	import com.greensock.easing.*;
	
	
	//********************************************************************
	// Blacklisted Imports
	//********************************************************************
	import com.blacklisted.utils.*;
	
	
	
	
	
	public class Navigation extends Sprite
	{
		//*********************************************************
		// CONSTANTS
		//*********************************************************
		private static const FILTER_SLIDER_BOUNDS           : Rectangle = new Rectangle( 458, 0, 1099, 0 );
		private static const FILTER_ROOM_TYPE_ARRAY         : Array = new Array({ s:"Showrooms", c:"Conference Rooms", d:"Departments", p:"Public" });
		private static const FILTER_NAME_TXT_COLOR          : Number = 0x134B55; //0x19606D;
		private static const START_ROUTE_DELAY         		: int = 1500; // 1sec || milliseconds
		private static const RESET_ROUTE_DELAY              : Number = 20000; // 10sec || milliseconds
		private static const SLIDER_SNAP_SPEED              : Number = 0.4;
		private static const NAV_FILTER_TXT_COLOR           : Number = 0x35C6F2;
		
		
		//*********************************************************
		// VARIABLES
		//*********************************************************
		public var navigation_art                      : Navigation_Art;
		
		public var navRoomArray                        : Array;
		public var filterResults                       : Array;
		public var searchQueryMap                      : Dictionary = new Dictionary();
		private var filterType                         : String = "All";
		private var currFilter                         : String = "All";
		
		private var _mapFloor1                         : *;
		private var _mapFloor2                         : *;
		private var _mapFloor3                         : *;
		private var _main                              : *;
		
		private var resetRoute_Timer                   : Timer;
		public var isRouting                           : Boolean = false;
		
		
		
		
		
		public function Navigation()
		{
			GlobalVarContainer.vars._navigation = this;
			
			
			navigation_art = new Navigation_Art();
			navigation_art.filter_mc.section_btn_ALL.txt.textColor = FILTER_NAME_TXT_COLOR;
			
			
			_main = GlobalVarContainer.vars._main;
			_mapFloor1 = GlobalVarContainer.vars.floor1Art;
			_mapFloor2 = GlobalVarContainer.vars.floor2Art;
			_mapFloor3 = GlobalVarContainer.vars.floor3Art;
			
			
			resetRoute_Timer = new Timer( RESET_ROUTE_DELAY, 1 );
			resetRoute_Timer.addEventListener( TimerEvent.TIMER_COMPLETE, resetRoomSelection_Timer );
			
			
			contstructNavButtons();
			contstructRoomAndNavButtons();
			defineNavButtons();
			
			addComponentsToStage();
			
		}
		
		
		
		
		
		public function addComponentsToStage():void
		{
			addChild( navigation_art );
			
		}
		
		
		
		
		
		private function defineNavButtons():void
		{
						
			//Slider
			navigation_art.filter_mc.slider_mc.mouseChildren = false;
			navigation_art.filter_mc.slider_mc.addEventListener( MouseEvent.MOUSE_DOWN, dragSlider_Start );
			navigation_art.filter_mc.slider_mc.addEventListener( MouseEvent.MOUSE_UP, dragSlider_Stop );
			navigation_art.filter_mc.slider_mc.addEventListener( MouseEvent.MOUSE_OUT, dragSlider_Stop );
			
			
			
			navigation_art.filter_mc.section_btn_ALL._sliderPos = 1;
			navigation_art.filter_mc.section_btn_ALL.addEventListener( MouseEvent.CLICK, initFilterClick );
			
			navigation_art.filter_mc.section_btn_SHOWROOMS._sliderPos = 2;
			navigation_art.filter_mc.section_btn_SHOWROOMS.addEventListener( MouseEvent.CLICK, initFilterClick );
			
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS._sliderPos = 3;
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.addEventListener( MouseEvent.CLICK, initFilterClick );
			
			navigation_art.filter_mc.section_btn_DEPARTMENTS._sliderPos = 4;
			navigation_art.filter_mc.section_btn_DEPARTMENTS.addEventListener( MouseEvent.CLICK, initFilterClick );
			
			navigation_art.filter_mc.section_btn_PUBLIC._sliderPos = 5;
			navigation_art.filter_mc.section_btn_PUBLIC.addEventListener( MouseEvent.CLICK, initFilterClick );
			
			
			
			navigation_art.filter_mc.section_btn_ALL.mouseChildren = false;
			navigation_art.filter_mc.section_btn_SHOWROOMS.mouseChildren = false;
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.mouseChildren = false;
			navigation_art.filter_mc.section_btn_DEPARTMENTS.mouseChildren = false;
			navigation_art.filter_mc.section_btn_PUBLIC.mouseChildren = false;
			
			//navigation_art.filter_mc.section_btn_ALL.mouseEnabled = true;
			navigation_art.filter_mc.section_btn_SHOWROOMS.mouseEnabled = true;		
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.mouseEnabled = true;			
			navigation_art.filter_mc.section_btn_DEPARTMENTS.mouseEnabled = true;
			navigation_art.filter_mc.section_btn_PUBLIC.mouseEnabled = true;
			
			/*
			navigation_art.filter_mc.section_btn_ALL.buttonMode = true;
			navigation_art.filter_mc.section_btn_SHOWROOMS.buttonMode = true;
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.buttonMode = true;
			navigation_art.filter_mc.section_btn_DEPARTMENTS.buttonMode = true;
			navigation_art.filter_mc.section_btn_PUBLIC.buttonMode = true;
			*/
			
		}
		
		
		
		
		
		public function filterRooms( key:String, value:String ):Array
		{
			searchQueryMap[key] = value;
			
			filterResults = [];
			
			for each ( var object : Object in navRoomArray ) 
			{
				var match : Boolean = true;
			
				for (var key : * in searchQueryMap) 
				{
					if (searchQueryMap[key] !== object[key]) 
					{
						match = false;
						break;          
					}
				}
			
				if ( match ) {
					filterResults.push( object );
					
				}
				
			}

			
			var filterResults_Retun = [];
			
			for each ( var filterResults : Object in filterResults )
			{
				for (var prop : * in filterResults) {
					
					if( prop == "btn" )
					{
						TweenMax.to( filterResults[prop], 1, { alpha:1, tint:NAV_FILTER_TXT_COLOR, ease:Expo.easeOut });
						
					} 
					
				}
				
			}
			
			return filterResults_Retun;
			
		}
		
		
		
		
		
		private function dragSlider_Start( e:MouseEvent ):void
		{
			e.target.startDrag( false, FILTER_SLIDER_BOUNDS );
			navigation_art.filter_mc.slider_mc.addEventListener( Event.ENTER_FRAME, initFilter );
			
			
			navigation_art.filter_mc.section_btn_ALL.mouseEnabled = false;
			navigation_art.filter_mc.section_btn_SHOWROOMS.mouseEnabled = false;		
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.mouseEnabled = false;			
			navigation_art.filter_mc.section_btn_DEPARTMENTS.mouseEnabled = false;
			navigation_art.filter_mc.section_btn_PUBLIC.mouseEnabled = false;
			
		}
		
		
		private function dragSlider_Stop( e:MouseEvent ):void
		{			
			e.target.stopDrag();
			navigation_art.filter_mc.slider_mc.removeEventListener( Event.ENTER_FRAME, initFilter );
			
			
			navigation_art.filter_mc.section_btn_ALL.mouseEnabled = true;
			navigation_art.filter_mc.section_btn_SHOWROOMS.mouseEnabled = true;		
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.mouseEnabled = true;			
			navigation_art.filter_mc.section_btn_DEPARTMENTS.mouseEnabled = true;
			navigation_art.filter_mc.section_btn_PUBLIC.mouseEnabled = true;
			
			
			switch( currFilter )
			{					
				case "All" :
					navigation_art.filter_mc.section_btn_ALL.mouseEnabled = false;
					//navigation_art.filter_mc.section_btn_ALL.buttonMode = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, { x:457, ease:Expo.easeOut });
					break;
					
				case "Showrooms" :
					navigation_art.filter_mc.section_btn_SHOWROOMS.mouseEnabled = false;
					//navigation_art.filter_mc.section_btn_SHOWROOMS.buttonMode = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, { x:730, ease:Expo.easeOut });
					break;
					
				case "Conference Rooms" :
					navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.mouseEnabled = false;
					//navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.buttonMode = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, { x:1045, ease:Expo.easeOut });
					break;
					
				case "Departments" :
					navigation_art.filter_mc.section_btn_DEPARTMENTS.mouseEnabled = false;
					//navigation_art.filter_mc.section_btn_DEPARTMENTS.buttonMode = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, { x:1332, ease:Expo.easeOut });
					break;
				
				case "Public" :
					navigation_art.filter_mc.section_btn_PUBLIC.mouseEnabled = false;
					//navigation_art.filter_mc.section_btn_PUBLIC.buttonMode = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, { x:1552, ease:Expo.easeOut });
					break;
				
			}
			
		}
		
		
		
		
		private function initFilter( e:Event ):void
		{
			
			if( e.target.x < 590 )
			{
				filterType = "All";
								
			} else if( e.target.x >= 590 && e.target.x < 870 )
			{
				filterType = "Showrooms";
								
			} else if( e.target.x >= 870 && e.target.x < 1175 )
			{
				filterType = "Conference Rooms";
								
			} else if( e.target.x >= 1175 && e.target.x < 1475 )
			{
				filterType = "Departments";
								
			} else if( e.target.x >= 1475 )
			{
				filterType = "Public";
								
			}

			
			if( currFilter != filterType )
			{
				if( filterType == "All" ){
					
					resetRoomsFilter();
										
				} else
				{
					deselectRoomsFilter();
					
				}
								
				
				currFilter = filterType;
				resetSectionTextColor();
				
				
				switch( filterType )
				{
					case "All" :
						navigation_art.filter_mc.section_btn_ALL.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
						
					case "Showrooms" :
						navigation_art.filter_mc.section_btn_SHOWROOMS.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
					
					case "Conference Rooms" :
						navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
						
					case "Departments" :
						navigation_art.filter_mc.section_btn_DEPARTMENTS.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
						
					case "Public" :
						navigation_art.filter_mc.section_btn_PUBLIC.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
				}		
				
				
				filterRooms( "roomType", currFilter );
				
			}
			
		}
		
		
		
		
		
		private function initFilterClick( e:MouseEvent ):void
		{
			/*
			navigation_art.filter_mc.section_btn_ALL.mouseEnabled = true;
			navigation_art.filter_mc.section_btn_SHOWROOMS.mouseEnabled = true;		
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.mouseEnabled = true;			
			navigation_art.filter_mc.section_btn_DEPARTMENTS.mouseEnabled = true;
			navigation_art.filter_mc.section_btn_PUBLIC.mouseEnabled = true;
			*/
			
			switch( e.target._sliderPos )
			{
				case 1 :
					filterType = "All";
					navigation_art.filter_mc.section_btn_ALL.mouseEnabled = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, {x:457, ease:Expo.easeInOut, delay:0.1 }); 
					break;
					
				case 2 :
					filterType = "Showrooms";
					navigation_art.filter_mc.section_btn_SHOWROOMS.mouseEnabled = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, {x:730, ease:Expo.easeInOut, delay:0.1 });
					break;
					
				case 3 :
					filterType = "Conference Rooms";
					navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.mouseEnabled = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, {x:1045, ease:Expo.easeInOut, delay:0.1 });
					break;
					
				case 4 :
					filterType = "Departments";
					navigation_art.filter_mc.section_btn_DEPARTMENTS.mouseEnabled = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, {x:1332, ease:Expo.easeInOut, delay:0.1 });
					break;
					
				case 5 :
					filterType = "Public";
					navigation_art.filter_mc.section_btn_PUBLIC.mouseEnabled = false;
					TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, {x:1552, ease:Expo.easeInOut, delay:0.1 });
					break;
					
			}
			
			
			
			if( currFilter != filterType )
			{
				if( filterType == "All" ){
					
					resetRoomsFilter();
										
				} else
				{
					deselectRoomsFilter();
					
				}
								
				
				currFilter = filterType;
				resetSectionTextColor();
				
				switch( currFilter )
				{
					case "All" :
						navigation_art.filter_mc.section_btn_ALL.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
						
					case "Showrooms" :
						navigation_art.filter_mc.section_btn_SHOWROOMS.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
					
					case "Conference Rooms" :
						navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
						
					case "Departments" :
						navigation_art.filter_mc.section_btn_DEPARTMENTS.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
						
					case "Public" :
						navigation_art.filter_mc.section_btn_PUBLIC.txt.textColor = FILTER_NAME_TXT_COLOR;
						break;
				}		
				
				
				filterRooms( "roomType", currFilter );
				
			}
			
		}
		
		
		
		
		
		private function deselectRoomsFilter():void
		{
			for( var i : int = 0; i < navRoomArray.length; ++i )
			{
				TweenMax.to( navRoomArray[i].btn, 0.5, { alpha:0.3, tint:null, ease:Expo.easeOut });
				
			}
		}
		
		
		private function resetRoomsFilter():void
		{
			for( var i : int = 0; i < navRoomArray.length; ++i )
			{
				TweenMax.to( navRoomArray[i].btn, 0.5, { alpha:1, tint:null, ease:Expo.easeOut });
				
			}
		}
		
		
		
		private function resetSectionTextColor():void
		{
			navigation_art.filter_mc.section_btn_ALL.txt.textColor = 0x909497;
			navigation_art.filter_mc.section_btn_SHOWROOMS.txt.textColor = 0x909497;
			navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.txt.textColor = 0x909497;
			navigation_art.filter_mc.section_btn_DEPARTMENTS.txt.textColor = 0x909497;
			navigation_art.filter_mc.section_btn_PUBLIC.txt.textColor = 0x909497;
		}
		
		
		
		
		
		
		public function lockNavigation():void
		{
			trace( "LOCK Navigation" );
		}
		
		
		public function unlockNavigation():void
		{
			trace( "UNLOCK Navigation" );
		}
		
		
		
		
		
		
		private function contstructRoomAndNavButtons():void
		{
			for( var i : int = 0; i < navRoomArray.length; ++i )
			{
				//navRoomArray[i].room.alpha = 0.0;
				//navRoomArray[i].btn._id = navRoomArray[i].id;
				
				//trace(i);
				navRoomArray[i].btn._id = i;
				navRoomArray[i].btn._route = navRoomArray[i].route;
				navRoomArray[i].btn._floor = navRoomArray[i].floor;
				navRoomArray[i].btn._navBtnEffect = navRoomArray[i].btn.effect;
				navRoomArray[i].btn._navBtnTxt = navRoomArray[i].btn.txt;
				//navRoomArray[i].btn.buttonMode = true;
				
				navRoomArray[i].btn.mouseChildren = false;
				navRoomArray[i].btn.addEventListener( MouseEvent.CLICK, initRoomClick );

				//navRoomArray[i].room._id = navRoomArray[i].id;
				navRoomArray[i].room._id = i;
				
				navRoomArray[i].room._route = navRoomArray[i].route;
				navRoomArray[i].room._floor = navRoomArray[i].floor;
				navRoomArray[i].room._navBtnEffect = navRoomArray[i].btn.effect;
				navRoomArray[i].room._navBtnTxt = navRoomArray[i].btn.txt;
				//navRoomArray[i].room.buttonMode = true;
				navRoomArray[i].room.mouseChildren = false;
				navRoomArray[i].room.addEventListener( MouseEvent.CLICK, initRoomClick ); 
			}
			
		}
		
		
		
		
		
		
		
		//**************************************************
		//**************************************************
		// INITIATE ROUTE!
		//**************************************************
		//**************************************************
		private function initRoomClick( e:MouseEvent ):void
		{	
			_main.lockNavigation_Routing();
			
			
			// RESET SELECTION
			resetRoomSelection();
			resetHighlightedNavButton();
			
			
			// APPLY NAV BUTTON EFFECTS
			e.target._navBtnTxt.textColor = NAV_FILTER_TXT_COLOR;
			
			TweenMax.killTweensOf( e.target._navBtnEffect ); // MAY NEED TO REMOVE
			e.target._navBtnEffect.visible = true;
			TweenMax.to( e.target._navBtnEffect, 0.5, { alpha:0.75, ease:Expo.easeOut });
			
			
			// IS SHOWING ROUTE || BOOLEAN
			isRouting = true;
			
			
			// MOVE TO CURRENT FLOOR
			if( _main.currentFloor != _main.STARTING_FLOOR )
			{
				// FLOOR 1 OR 3
				_main.moveToFloor_Animate( _main.STARTING_FLOOR, true );
				setTimeout( initRoomRoute, START_ROUTE_DELAY, e.target._route, e.target._floor );
			} else
			{
				// FLOOR 2
				initRoomRoute( e.target._route, e.target._floor );
			}
			
			
			// CONTROL ROUTE TIMER
			resetRoute_Timer.reset();
			resetRoute_Timer.start();
			
			
			// RESET NAV FILTER
			if( currFilter != "All" )
			{
				currFilter = "All";
				
				resetRoomsFilter();
				resetSectionTextColor();
				
				navigation_art.filter_mc.section_btn_ALL.txt.textColor = FILTER_NAME_TXT_COLOR;				
				navigation_art.filter_mc.section_btn_ALL.mouseEnabled = false;
				navigation_art.filter_mc.section_btn_SHOWROOMS.mouseEnabled = true;		
				navigation_art.filter_mc.section_btn_CONFERENCE_ROOMS.mouseEnabled = true;			
				navigation_art.filter_mc.section_btn_DEPARTMENTS.mouseEnabled = true;
				navigation_art.filter_mc.section_btn_PUBLIC.mouseEnabled = true;

				TweenMax.to( navigation_art.filter_mc.slider_mc, SLIDER_SNAP_SPEED, { x:457, ease:Expo.easeInOut, overwrite:true });
				
			}
			
			
			// SHOW SELECTED ROOM GRADIENT
			var room = navRoomArray[e.target._id].room;
			TweenMax.to( room, 0.5, { alpha:1, ease:Expo.easeOut });
			room.gotoAndPlay( "animate" );
			
			
			// CHANGE SELECTED ROOM TEXT COLOR
			var txt = navRoomArray[e.target._id].txt;
			TweenMax.to( txt, 0.5, { tint:0x36C5F3, ease:Expo.easeOut });
			
		}		
		
		
		
		
		
		
		
		private function initRoomRoute( mc:MovieClip, floor:int ):void
		{
			if( floor != _main.STARTING_FLOOR )
			{
				_mapFloor2.route_STAIRS_TRANS.gotoAndPlay( "animate" );
				setTimeout( _main.moveToFloor_Animate, 800, floor, true );
				
				setTimeout( animateRoute, 2000 );
				function animateRoute():void
				{
					mc.gotoAndPlay( "animate" );
					
				}
				
				
			} else
			{
				mc.gotoAndPlay( "animate" );
			}
			
			
		}
		
		
		
		
		
		private function resetHighlightedNavButton():void
		{
			for( var i : int = 0; i < navRoomArray.length; ++i )
			{
				TweenMax.killTweensOf( navRoomArray[i].btn.effect );
				navRoomArray[i].btn.effect.alpha = 0;
				navRoomArray[i].btn.effect.visible = false;
				navRoomArray[i].btn.txt.textColor = 0x909497;
				
			}
			
		}
		
		
		
		
		
		private function resetRoomSelection():void
		{
			_mapFloor2.route_STAIRS_TRANS.gotoAndStop( 1 );
			
			for( var i : int = 0; i < navRoomArray.length; ++i )
			{
				TweenMax.killTweensOf( navRoomArray[i].room );
				
				//trace( i );
				navRoomArray[i].route.gotoAndStop( 1 );
				//navRoomArray[i].room.visible = false;
				navRoomArray[i].room.alpha = 0;
				navRoomArray[i].room.gotoAndStop(1);
				
				TweenMax.killTweensOf( navRoomArray[i].txt );
				TweenMax.to(navRoomArray[i].txt, 0.5, { tint:null, ease:Expo.easeOut });
			}
			
		}
		
		
		
		
		
		private function resetRoomSelection_Timer( e:TimerEvent ):void
		{
			isRouting = false;
			
			_mapFloor2.route_STAIRS_TRANS.gotoAndStop( 1 );
			
			for( var i : int = 0; i < navRoomArray.length; ++i )
			{
				TweenMax.killTweensOf( navRoomArray[i].room );
				
				navRoomArray[i].route.gotoAndStop( 1 );
				navRoomArray[i].room.alpha = 0;
				navRoomArray[i].btn.effect.visible = false;
				navRoomArray[i].btn.effect.alpha = 0;
				navRoomArray[i].btn.txt.textColor = 0x909497;
				
				
				TweenMax.killTweensOf( navRoomArray[i].txt );
				TweenMax.to(navRoomArray[i].txt, 0.5, { tint:null, ease:Expo.easeOut });
			}
			
		}
		
		
		
		
		
		
		
		//******************************************************************
		// Construct Nav Buttons
		//******************************************************************
		private function contstructNavButtons():void
		{
			var art = navigation_art;
			
			navRoomArray = new Array();
			
			navRoomArray.push({ id:0,
							    btn:art.nav_btn_ADVERTISING,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].d,
								floor:3,
								room:_mapFloor3.selected_ADVERTISING_GROUP,
								txt:_mapFloor3.txt_ADVERTISING_GROUP, 
								route:_mapFloor3.route_ADVERTISING_GROUP });
							  
			navRoomArray.push({ id:1,
							    btn:art.nav_btn_ADVERTISING_CONFERENCE,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].c,
								floor:3,
								room:_mapFloor3.selected_ADVERTISING_CONFERENCE,
								txt:_mapFloor3.txt_ADVERTISING_CONFERENCE, 
								route:_mapFloor3.route_ADVERTISING_CONFERENCE });
											
			navRoomArray.push({ id:2,
							    btn:art.nav_btn_BOYS,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_BOYS,
								txt:_mapFloor2.txt_BOYS, 
								route:_mapFloor2.route_BOYS });			
			
			navRoomArray.push({ id:3,
							    btn:art.nav_btn_CALI,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_CALI,
								txt:_mapFloor2.txt_CALI, 
								route:_mapFloor2.route_CALI });
								
			navRoomArray.push({ id:4,
							    btn:art.nav_btn_MARK_NASON,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].p,
								floor:2,
								room:_mapFloor2.selected_MARK_NASON,
								txt:_mapFloor2.txt_MARK_NASON, 
								route:_mapFloor2.route_MARK_NASON });
								
			navRoomArray.push({ id:5,
							    btn:art.nav_btn_CYBER_CAFE,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].p,
								floor:2,
								room:_mapFloor2.selected_CYBER_CAFE,
								txt:_mapFloor2.txt_CYBER_CAFE, 
								route:_mapFloor2.route_CYBER_CAFE });
																
			navRoomArray.push({ id:6,
							  	btn:art.nav_btn_FISHBOWL_SMALL,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].c,
								floor:1,
								room:_mapFloor1.selected_SMALL_FISHBOWL,
								txt:_mapFloor1.txt_SMALL_FISHBOWL, 
								route:_mapFloor1.route_SMALL_FISHBOWL });
								
			navRoomArray.push({ id:7,
							  	btn:art.nav_btn_FISHBOWL_LARGE,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].c,
								floor:1,
								room:_mapFloor1.selected_LARGE_FISHBOWL,
								txt:_mapFloor1.txt_LARGE_FISHBOWL, 
								route:_mapFloor1.route_LARGE_FISHBOWL });
								
			navRoomArray.push({ id:8,
							  	btn:art.nav_btn_GIRLS,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_GIRLS,
								txt:_mapFloor2.txt_GIRLS, 
								route:_mapFloor2.route_GIRLS });
								
			navRoomArray.push({ id:9,
							  	btn:art.nav_btn_KIDS_DESIGN,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].d,
								floor:3,
								room:_mapFloor3.selected_KIDS_DESIGN_GROUP,
								txt:_mapFloor3.txt_KIDS_DESIGN_GROUP, 
								route:_mapFloor3.route_KIDS_DESIGN });
								
			navRoomArray.push({ id:10,
							  	btn:art.nav_btn_LIFESTYLE_DESIGN,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].d,
								floor:3,
								room:_mapFloor3.selected_LIFESTYLE_DESIGN_GROUP,
								txt:_mapFloor3.txt_LIFESTYLE_DESIGN_GROUP, 
								route:_mapFloor3.route_LIFESTYLE_DESIGN });

			navRoomArray.push({ id:11,
							  	btn:art.nav_btn_MARK_NASON_LA,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_MARK_NASON_LA,
								txt:_mapFloor2.txt_MARK_NASON_LA, 
								route:_mapFloor2.route_MARK_NASON_LA });
								
			navRoomArray.push({ id:12,
							  	btn:art.nav_btn_MENS_WOMENS_ONTHEGO,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_MENS_WOMENS_ONTHEGO,
								txt:_mapFloor2.txt_MENS_WOMENS_ONTHEGO, 
								route:_mapFloor2.route_MENS_WOMENS_ONTHEGO });
								
			navRoomArray.push({ id:13, 
							  	btn:art.nav_btn_MENS_SPORT,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_MENS_SPORT,
								txt:_mapFloor2.txt_MENS_SPORT, 
								route:_mapFloor2.route_MENS_SPORT });
			
			navRoomArray.push({ id:14, 
							  	btn:art.nav_btn_MENS_SPORT_CASUAL,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_MENS_SPORT_CASUAL,
								txt:_mapFloor2.txt_MENS_SPORT_CASUAL, 
								route:_mapFloor2.route_MENS_SPORT_CASUAL });
								
			navRoomArray.push({ id:15,
							  	btn:art.nav_btn_MENS_USA,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_MENS_USA,
								txt:_mapFloor2.txt_MENS_USA, 
								route:_mapFloor2.route_MENS_USA });
								
			navRoomArray.push({ id:16,
							  	btn:art.nav_btn_MENS_USA_STREETWARE,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_MENS_USA_STREETWARE,
								txt:_mapFloor2.txt_MENS_USA_STREETWARE, 
								route:_mapFloor2.route_MENS_USA_STREETWARE });
								
			navRoomArray.push({ id:17,
							  	btn:art.nav_btn_MODERN_COMFORT,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_MODERN_COMFORT,
								txt:_mapFloor2.txt_MODERN_COMFORT, 
								route:_mapFloor2.route_MODERN_COMFORT });
								
			navRoomArray.push({ id:18,
							    btn:art.nav_btn_MODERN_COMFORT_SANDALS,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_MODERN_COMFORT_SANDALS,
								txt:_mapFloor2.txt_MODERN_COMFORT_SANDALS, 
								route:_mapFloor2.route_MODERN_COMFORT_SANDALS });
								
			navRoomArray.push({ id:19,
							  	btn:art.nav_btn_ORIGINALS,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_ORIGINALS,
								txt:_mapFloor2.txt_ORIGINALS, 
								route:_mapFloor2.route_ORIGINALS });

			navRoomArray.push({ id:20,
							  	btn:art.nav_btn_KIDS_DESIGN_2,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].d,
								floor:3,
								room:_mapFloor3.selected_KIDS_DESIGN_2,
								txt:_mapFloor3.txt_KIDS_DESIGN_2, 
								route:_mapFloor3.route_KIDS_DESIGN_2 });
			
			navRoomArray.push({ id:21,
							  	btn:art.nav_btn_PERFORMANCE,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_PERFORMANCE,
								txt:_mapFloor2.txt_PERFORMANCE, 
								route:_mapFloor2.route_PERFORMANCE });
								
			navRoomArray.push({ id:22,
							  	btn:art.nav_btn_RECEPTION_AREA,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].p,
								floor:1,
								room:_mapFloor1.selected_RECEPTION,
								txt:_mapFloor1.txt_RECEPTION, 
								route:_mapFloor1.route_RECEPTION });
								
			navRoomArray.push({ id:23,
							  	btn:art.nav_btn_RECEPTION_CONFERENCE,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].c,
								floor:1,
								room:_mapFloor1.selected_RECEPTION_CONFERENCE,
								txt:_mapFloor1.txt_RECEPTION_CONFERENCE, 
								route:_mapFloor1.route_RECEPTION_CONFERENCE });
								
			navRoomArray.push({ id:24,
							  	btn:art.nav_btn_RESTROOMS,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].p,
								floor:2,
								room:_mapFloor2.selected_RESTROOMS,
								txt:_mapFloor2.txt_RESTROOMS, 
								route:_mapFloor2.route_RESTROOMS });
								
			navRoomArray.push({ id:25,
							  	btn:art.nav_btn_SAVAAS_DINING,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].p,
								floor:1,
								room:_mapFloor1.selected_SAVAAS_DINING,
								txt:_mapFloor1.txt_SAVAAS_DINING, 
								route:_mapFloor1.route_SAVAAS_DINING });
										
			navRoomArray.push({ id:26,
							  	btn:art.nav_btn_SPORT_DESIGN,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].d,
								floor:3,
								room:_mapFloor3.selected_SPORT_DESIGN_GROUP,
								txt:_mapFloor3.txt_SPORT_DESIGN_GROUP, 
								route:_mapFloor3.route_SPORT_DESIGN });
								
			navRoomArray.push({ id:27,
							  	btn:art.nav_btn_TWINKLE_TOES,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_TWINKLE_TOES,
								txt:_mapFloor2.txt_TWINKLE_TOES, 
								route:_mapFloor2.route_TWINKLE_TOES });
													
			navRoomArray.push({ id:28,
							  	btn:art.nav_btn_WOMENS_ACTIVE,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_WOMENS_ACTIVE,
								txt:_mapFloor2.txt_WOMENS_ACTIVE, 
								route:_mapFloor2.route_WOMENS_ACTIVE });
								
			navRoomArray.push({ id:29,
							    btn:art.nav_btn_BOBS,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_BOBS,
								txt:_mapFloor2.txt_BOBS, 
								route:_mapFloor2.route_BOBS });
								
			navRoomArray.push({ id:30,
							  	btn:art.nav_btn_WOMENS_SPORT_ACTIVE,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_WOMENS_SPORT_ACTIVE,
								txt:_mapFloor2.txt_WOMENS_SPORT_ACTIVE, 
								route:_mapFloor2.route_WOMENS_SPORT_ACTIVE });
								
			navRoomArray.push({ id:31,
							  	btn:art.nav_btn_WOMENS_SPORT,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_WOMENS_SPORT,
								txt:_mapFloor2.txt_WOMENS_SPORT, 
								route:_mapFloor2.route_WOMENS_SPORT });
								
			navRoomArray.push({ id:32,
							  	btn:art.nav_btn_WOMENS_USA_BOOTS,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_WOMENS_USA_BOOTS,
								txt:_mapFloor2.txt_WOMENS_USA_BOOTS, 
								route:_mapFloor2.route_WOMENS_USA_BOOTS });
								
			navRoomArray.push({ id:33,
							  	btn:art.nav_btn_WORK,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:2,
								room:_mapFloor2.selected_WORK,
								txt:_mapFloor2.txt_WORK, 
								route:_mapFloor2.route_WORK });
			
			navRoomArray.push({ id:34,
							  	btn:art.nav_btn_MARKETING_THEATER,
								roomType:FILTER_ROOM_TYPE_ARRAY[0].s,
								floor:1,
								room:_mapFloor1.selected_MARKETING_THEATER,
								txt:_mapFloor1.txt_MARKETING_THEATER, 
								route:_mapFloor1.route_MARKETING_THEATER });
								
		}
		

	}
	
}
