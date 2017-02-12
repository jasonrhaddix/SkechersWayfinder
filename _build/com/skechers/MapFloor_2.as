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
	
	
	
	
	
	public class MapFloor_2 extends Sprite
	{
		//*********************************************************
		// CONSTANTS
		//*********************************************************
		private static const ROOM_ANIMATION_SPEED    : Number = 0.5;
		private static const FLICKER_DELAY           : int = 60;
		
		
		//*********************************************************
		// VARIABLES
		//*********************************************************
		public var mapFloor_2_Art                    : MapFloor_2_Art;
		
		private var textAnimationArray               : Array;
		private var selectedRoomsArray               : Array;
		
		
		
		
		
		public function MapFloor_2()
		{			
			mapFloor_2_Art = new MapFloor_2_Art();
			mapFloor_2_Art.x = 0;
			mapFloor_2_Art.y = 0;
			//mapFloor_2_Art.scaleX = 0.7;
			//mapFloor_2_Art.scaleY = 1;
			//mapFloor_2_Art.rotationX = -55;
						
			mapFloor_2_Art.border_mc.gotoAndStop( "end" );
			
			
			GlobalVarContainer.vars.floor2Art = mapFloor_2_Art;
			
			
			createTextArray();
			createSelectedRoomsArray();
			disableRoomText();
			floorState_Initialize();
			
			addComponentsToStage();
			
		}
		
		
		
		
		
		public function addComponentsToStage():void
		{
			addChild( mapFloor_2_Art );
			
		}
		
		
		
		
		
		public function floorState_Initialize():void
		{
			for( var i : int = 0; i < selectedRoomsArray.length; ++i )
			{
				//trace( i );
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
			mapFloor_2_Art.border_mc.gotoAndStop( "start" );
			mapFloor_2_Art.hallway_mc.y = -300;
			mapFloor_2_Art.hallway_mc.alpha = 0;
			mapFloor_2_Art.room_outline_mc.y = -300;
			mapFloor_2_Art.room_outline_mc.alpha = 0;
			mapFloor_2_Art.YOU_Mc.alpha = 0;
			
			/*
			for( var i : int = 1; i < 37; ++i )
			{
				mapFloor_2_Art["room_" + i].alpha = 0;
			}
			*/
		}
		
		
		public function animate_FloorToFloor():void
		{
			TweenMax.to( mapFloor_2_Art.room_outline_mc, 0.75, { alpha:1, y:-12.10, ease:Expo.easeOut, delay:1.0 });
			TweenMax.to( mapFloor_2_Art.hallway_mc, 0.75, { alpha:1, y:-30.95, ease:Expo.easeOut, delay:1.25 });
			setTimeout( animate_Border, 800 );
			animateRooms();
			animateText();
			
			TweenMax.to( mapFloor_2_Art.YOU_Mc, 1, { alpha:1, ease:Expo.easeOut, delay:3.4 }); 
			
		}
		
		
		
		
		
		
		private function animate_Border():void
		{
			mapFloor_2_Art.border_mc.gotoAndPlay( "animate" );
		}
		
		
		
		
		
		private function animateRooms():void
		{
			for( var i : int = 1; i < 37; ++i )
			{   
				TweenMax.from( mapFloor_2_Art["room_" + i], ROOM_ANIMATION_SPEED, { /*y:mapFloor_2_Art["room_" + i].y - 150,*/ alpha:0 , /*ease:Back.easeOut,*/ delay:1.65 + (i * 0.02)/*, onComplete:roomFlickerOff, onCompleteParams:[mapFloor_2_Art["room_" + i]]*/ });
			}
			
		}
		
		
		
		
		
		private function animateText():void
		{
			for( var i : int = 0; i < textAnimationArray.length; ++i )
			{   
				TweenMax.from( textAnimationArray[i], ROOM_ANIMATION_SPEED, { y:textAnimationArray[i].y - 10, alpha:0 , /*ease:Back.easeOut,*/ delay:2.4 + (i * 0.02)/*, onComplete:roomFlickerOff, onCompleteParams:[mapFloor_2_Art["room_" + i]]*/ });
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
			var mc : MovieClip = mapFloor_2_Art;
			
			selectedRoomsArray = new Array();
			selectedRoomsArray.push( mc.selected_CYBER_CAFE );
			selectedRoomsArray.push( mc.selected_ORIGINALS );
			selectedRoomsArray.push( mc.selected_MODERN_COMFORT_SANDALS );
			selectedRoomsArray.push( mc.selected_CALI );
			selectedRoomsArray.push( mc.selected_MENS_USA );
			selectedRoomsArray.push( mc.selected_MENS_USA_STREETWARE );
			selectedRoomsArray.push( mc.selected_MENS_WOMENS_ONTHEGO );
			selectedRoomsArray.push( mc.selected_WORK );
			selectedRoomsArray.push( mc.selected_TWINKLE_TOES );
			selectedRoomsArray.push( mc.selected_BOBS );
			// selectedRoomsArray.push( mc.selected_PERFORMANCE );
			// selectedRoomsArray.push( mc.selected_MARK_NASON );
			// selectedRoomsArray.push( mc.selected_MARK_NASON_LA );
			selectedRoomsArray.push( mc.selected_RESTROOMS );
			selectedRoomsArray.push( mc.selected_MENS_SPORT );
			selectedRoomsArray.push( mc.selected_MENS_SPORT_CASUAL );
			selectedRoomsArray.push( mc.selected_MODERN_COMFORT );
			selectedRoomsArray.push( mc.selected_GIRLS );
			selectedRoomsArray.push( mc.selected_BOYS );
			selectedRoomsArray.push( mc.selected_WOMENS_ACTIVE );
			//selectedRoomsArray.push( mc.selected_WOMENS_SPORT_2 );
			selectedRoomsArray.push( mc.selected_WOMENS_SPORT_ACTIVE );
			selectedRoomsArray.push( mc.selected_WOMENS_USA_BOOTS );
			selectedRoomsArray.push( mc.selected_WOMENS_SPORT );
			
			
			//trace( textAnimationArray[0].name )
		}
		
		
		
		
		
		private function createTextArray():void
		{
			var mc : MovieClip = mapFloor_2_Art;
			
			textAnimationArray = new Array();
			textAnimationArray.push( mc.txt_SMOKING_AREA );
			textAnimationArray.push( mc.txt_MODERN_COMFORT_SANDALS );
			textAnimationArray.push( mc.txt_CALI );
			textAnimationArray.push( mc.txt_CYBER_CAFE );
			textAnimationArray.push( mc.txt_ORIGINALS );
			textAnimationArray.push( mc.txt_STAIRS );
			textAnimationArray.push( mc.txt_STAIRS_2 );
			textAnimationArray.push( mc.txt_MENS_USA );
			textAnimationArray.push( mc.txt_MENS_USA_STREETWARE );
			// textAnimationArray.push( mc.txt_KOI_PONDS );
			textAnimationArray.push( mc.txt_MENS_WOMENS_ONTHEGO );
			textAnimationArray.push( mc.txt_WORK );
			textAnimationArray.push( mc.txt_TWINKLE_TOES );
			textAnimationArray.push( mc.txt_BOBS );
			// textAnimationArray.push( mc.txt_MARK_NASON );
			// textAnimationArray.push( mc.txt_PERFORMANCE );
			// textAnimationArray.push( mc.txt_MARK_NASON_LA );
			textAnimationArray.push( mc.txt_RESTROOMS );
			textAnimationArray.push( mc.txt_GIRLS );
			textAnimationArray.push( mc.txt_MENS_SPORT );
			textAnimationArray.push( mc.txt_MENS_SPORT_CASUAL );
			textAnimationArray.push( mc.txt_ELEVATOR );
			textAnimationArray.push( mc.txt_STAIRS_3 );
			textAnimationArray.push( mc.txt_BOYS );
			textAnimationArray.push( mc.txt_COVERED_TERRACE );
			textAnimationArray.push( mc.txt_RESTROOMS_2 );
			//textAnimationArray.push( mc.txt_WOMENS_USA_BOOTS );
			textAnimationArray.push( mc.txt_WOMENS_ACTIVE );
			//textAnimationArray.push( mc.txt_PERFORMANCE_APPAREL );
			textAnimationArray.push( mc.txt_MODERN_COMFORT );
			textAnimationArray.push( mc.txt_WOMENS_USA_BOOTS );
			textAnimationArray.push( mc.txt_STAIRS_4 );
			textAnimationArray.push( mc.txt_WOMENS_SPORT );
			textAnimationArray.push( mc.txt_WOMENS_SPORT_ACTIVE );
			//textAnimationArray.push( mc.txt_WOMENS_SPORT_2 );
			
			//trace( textAnimationArray[0].name )
		}
		
		
		private function disableRoomText():void
		{
			for( var i : int = 0; i < textAnimationArray.length; ++i )
			{
				//trace(i);
				textAnimationArray[i].mouseEnabled = false;
				textAnimationArray[i].mouseChildren = false;
			}
		}

	}
	
}
