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
	
	
	
	
	
	public class MapFloor_3 extends Sprite
	{
		//*********************************************************
		// CONSTANTS
		//*********************************************************
		private static const ROOM_ANIMATION_SPEED    : Number = 0.5;
		private static const FLICKER_DELAY           : int = 60;
		
		
		//*********************************************************
		// VARIABLES
		//*********************************************************
		public var mapFloor_3_Art                    : MapFloor_3_Art;
		
		private var textAnimationArray               : Array;
		private var selectedRoomsArray               : Array;
		
		
		
		
		
		public function MapFloor_3()
		{
			mapFloor_3_Art = new MapFloor_3_Art();
			mapFloor_3_Art.x = 0;
			mapFloor_3_Art.y = 0;
			
			mapFloor_3_Art.border_mc.gotoAndStop( "end" );
			
			GlobalVarContainer.vars.floor3Art = mapFloor_3_Art;
			
			createTextArray();
			createSelectedRoomsArray();
			disableRoomText();
			floorState_Initialize();
			
			addComponentsToStage();
		}
		
		
		
		
		
		public function addComponentsToStage():void
		{
			addChild( mapFloor_3_Art );
			
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
			mapFloor_3_Art.border_mc.gotoAndStop( "start" );
			mapFloor_3_Art.hallway_mc.y = -300;
			mapFloor_3_Art.hallway_mc.alpha = 0;
			mapFloor_3_Art.room_outline_mc.y = -300;
			mapFloor_3_Art.room_outline_mc.alpha = 0;
			
			/*
			for( var i : int = 1; i < 37; ++i )
			{
				//mapFloor_3_Art["room_" + i].alpha = 0;
			}
			*/
			
		}
		
		
		public function animate_FloorToFloor():void
		{
			TweenMax.to( mapFloor_3_Art.room_outline_mc, 0.75, { alpha:1, y:-6.20, ease:Expo.easeOut, delay:1.0 });
			TweenMax.to( mapFloor_3_Art.hallway_mc, 0.75, { alpha:1, y:-45.90, ease:Expo.easeOut, delay:1.25 });
			setTimeout( animate_Border, 800 );
			animateRooms();
			animateText();
			
		}
		
		
		
		
		
		
		private function animate_Border():void
		{
			mapFloor_3_Art.border_mc.gotoAndPlay( "animate" );
		}
		
		
		
		
		
		private function animateRooms():void
		{
			for( var i : int = 1; i < 41; ++i )
			{   
				TweenMax.from( mapFloor_3_Art["room_" + i], ROOM_ANIMATION_SPEED, { /*y:mapFloor_3_Art["room_" + i].y - 150,*/ alpha:0 , /*ease:Back.easeOut,*/ delay:1.65 + (i * 0.02)/*, onComplete:roomFlickerOff, onCompleteParams:[mapFloor_3_Art["room_" + i]]*/ });
			}
			
		}
		
		
		
		
		
		private function animateText():void
		{
			for( var i : int = 0; i < textAnimationArray.length; ++i )
			{   
				TweenMax.from( textAnimationArray[i], ROOM_ANIMATION_SPEED, { y:textAnimationArray[i].y - 10, alpha:0 , /*ease:Back.easeOut,*/ delay:2.4 + (i * 0.02)/*, onComplete:roomFlickerOff, onCompleteParams:[mapFloor_3_Art["room_" + i]]*/ });
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
			var mc : MovieClip = mapFloor_3_Art;
			
			selectedRoomsArray = new Array();
			selectedRoomsArray.push( mc.selected_ADVERTISING_CONFERENCE );
			selectedRoomsArray.push( mc.selected_ADVERTISING_GROUP );
			selectedRoomsArray.push( mc.selected_KIDS_DESIGN_GROUP );
			selectedRoomsArray.push( mc.selected_KIDS_DESIGN_2 );
			selectedRoomsArray.push( mc.selected_LIFESTYLE_DESIGN_GROUP );
			selectedRoomsArray.push( mc.selected_SPORT_DESIGN_GROUP );
						
		}
		
		
		
		
		
		private function createTextArray():void
		{
			var mc : MovieClip = mapFloor_3_Art;
			
			textAnimationArray = new Array();
			textAnimationArray.push( mc.txt_ADVERTISING_CONFERENCE );
			textAnimationArray.push( mc.txt_STAIRS );
			textAnimationArray.push( mc.txt_ADVERTISING_GROUP );
			textAnimationArray.push( mc.txt_KIDS_DESIGN_GROUP );
			textAnimationArray.push( mc.txt_MENS_RESTROOM );
			textAnimationArray.push( mc.txt_ELEVATOR );
			textAnimationArray.push( mc.txt_STAIRS_2 );
			textAnimationArray.push( mc.txt_KIDS_DESIGN_2 );
			textAnimationArray.push( mc.txt_WOMENS_RESTROOM );
			textAnimationArray.push( mc.txt_LIFESTYLE_DESIGN_GROUP );
			textAnimationArray.push( mc.txt_SPORT_DESIGN_GROUP );
			textAnimationArray.push( mc.txt_STAIRS_3 );
			
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
