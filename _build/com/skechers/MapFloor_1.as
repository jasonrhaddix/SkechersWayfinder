package com.skechers
{
	//********************************************************************
	// Flash Imports
	//********************************************************************
	import flash.display.*;
	import flash.events.*;
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
	
	
	
	
	
	public class MapFloor_1 extends Sprite
	{
		//*********************************************************
		// CONSTANTS
		//*********************************************************
		private static const ROOM_ANIMATION_SPEED    : Number = 0.5;
		private static const FLICKER_DELAY           : int = 60;
		
		
		//*********************************************************
		// VARIABLES
		//*********************************************************
		public var mapFloor_1_Art                    : MapFloor_1_Art;
		
		private var textAnimationArray               : Array;
		private var selectedRoomsArray               : Array;
		
		
		
		
		
		public function MapFloor_1()
		{			
			mapFloor_1_Art = new MapFloor_1_Art();
			mapFloor_1_Art.x = 0;
			mapFloor_1_Art.y = 0;
			mapFloor_1_Art.scaleY = 1.1;
			
						
			mapFloor_1_Art.border_mc.gotoAndStop( "end" );
			
			
			GlobalVarContainer.vars.floor1Art = mapFloor_1_Art;
			
			
			createTextArray();
			createSelectedRoomsArray();
			disableRoomText();
			floorState_Initialize();
			
			addComponentsToStage();
			
		}
		
		
		
		
		
		public function addComponentsToStage():void
		{
			addChild( mapFloor_1_Art );
			
		}
		
		
		
		
		
		public function floorState_Initialize():void
		{
			for( var i : int = 0; i < selectedRoomsArray.length; ++i )
			{
				selectedRoomsArray[i].alpha = 0;
			}
			
			
			for( var j : int = 0; j < createTextArray.length; ++j )
			{
				//createTextArray[j].alpha = 0;
				createTextArray[j].mouseEnabled = false;
				createTextArray[j].mouseChildren = false;
			}
			
		}
		
		
		
		
		
		public function animate_Intro():void
		{
			//
		}
		
		
		
		
		
		public function animate_Ambient():void
		{
			//
		}
		
		
		
		
		
		public function set_FloorToFloor():void
		{
			mapFloor_1_Art.border_mc.gotoAndStop( "start" );
			mapFloor_1_Art.hallway_mc.y = -300;
			mapFloor_1_Art.hallway_mc.alpha = 0;
			mapFloor_1_Art.room_outline_mc.y = -300;
			mapFloor_1_Art.room_outline_mc.alpha = 0;
			
			/*
			for( var i : int = 1; i < 18; ++i )
			{
				mapFloor_1_Art["room_" + i].alpha = 0;
			}
			*/
			
		}
		
		
		public function animate_FloorToFloor():void
		{
			TweenMax.to( mapFloor_1_Art.room_outline_mc, 0.75, { alpha:1, y:-11.75, ease:Expo.easeOut, delay:1.0 });
			TweenMax.to( mapFloor_1_Art.hallway_mc, 0.75, { alpha:1, y:-8.90, ease:Expo.easeOut, delay:1.25 });
			setTimeout( animate_Border, 800 );
			animateRooms();
			animateText();
			
		}
		
		
		
		
		
		
		private function animate_Border():void
		{
			mapFloor_1_Art.border_mc.gotoAndPlay( "animate" );
		}
		
		
		
		
		
		private function animateRooms():void
		{
			for( var i : int = 1; i < 18; ++i )
			{   
				TweenMax.from( mapFloor_1_Art["room_" + i], ROOM_ANIMATION_SPEED, { /*y:mapFloor_1_Art["room_" + i].y - 150,*/ alpha:0 , /*ease:Back.easeOut,*/ delay:1.65 + (i * 0.02)/*, onComplete:roomFlickerOff, onCompleteParams:[mapFloor_1_Art["room_" + i]]*/ });
			}
			
		}
		
		
		
		
		
		private function animateText():void
		{
			for( var i : int = 0; i < textAnimationArray.length; ++i )
			{   
				TweenMax.from( textAnimationArray[i], ROOM_ANIMATION_SPEED, { y:textAnimationArray[i].y - 10, alpha:0 , /*ease:Back.easeOut,*/ delay:2.0 + (i * 0.02)/*, onComplete:roomFlickerOff, onCompleteParams:[mapFloor_1_Art["room_" + i]]*/ });
			}
			
		}
		
		
		
		
		
		private function roomFlickerOff( mc:MovieClip ):void
		{
			mc.visible = false;
			setTimeout( roomFlickerOn, FLICKER_DELAY, mc );
			
		}
		
		
		private function roomFlickerOn( mc:MovieClip ):void
		{
			mc.visible = true;
			
		}
		
		
		
		private function createSelectedRoomsArray():void
		{
			var mc : MovieClip = mapFloor_1_Art;
			
			selectedRoomsArray = new Array();
			selectedRoomsArray.push( mc.selected_RECEPTION );
			selectedRoomsArray.push( mc.selected_RECEPTION_CONFERENCE );
			selectedRoomsArray.push( mc.selected_LARGE_FISHBOWL );
			selectedRoomsArray.push( mc.selected_SMALL_FISHBOWL );
			/*selectedRoomsArray.push( mc.selected_MARKETING_THEATER );*/
			selectedRoomsArray.push( mc.selected_SAVAAS_DINING );
			
		}
		
		
		
		
		
		private function createTextArray():void
		{
			var mc : MovieClip = mapFloor_1_Art;
			
			textAnimationArray = new Array();
			//textAnimationArray.push( mc.txt_SEPULVEDA );
			textAnimationArray.push( mc.txt_PARKING_GARAGE_ENTRANCE );
			textAnimationArray.push( mc.txt_LOWER_LEVEL_PARKING );
			textAnimationArray.push( mc.txt_ELEVATOR );
			textAnimationArray.push( mc.txt_RECEPTION_CONFERENCE );
			textAnimationArray.push( mc.txt_RECEPTION );
			textAnimationArray.push( mc.txt_STAIRS );
			textAnimationArray.push( mc.txt_LARGE_FISHBOWL );
			textAnimationArray.push( mc.txt_ENTRANCE );
			textAnimationArray.push( mc.txt_SMALL_FISHBOWL );
			/*textAnimationArray.push( mc.txt_MARKETING_THEATER );*/
			textAnimationArray.push( mc.txt_SAVAAS_DINING );
			textAnimationArray.push( mc.txt_MENS_RESTROOM );
			textAnimationArray.push( mc.txt_WOMENS_RESTROOM );
			textAnimationArray.push( mc.txt_PARKING_GARAGE_ENTRANCE_2 );
			textAnimationArray.push( mc.txt_STAIRS_2 );

		}
		
		
		
		private function disableRoomText():void
		{
			for( var i : int = 0; i < textAnimationArray.length; ++i )
			{
				textAnimationArray[i].mouseEnabled = false;
				textAnimationArray[i].mouseChildren = false;
			}
		}
		
	}
	
}
