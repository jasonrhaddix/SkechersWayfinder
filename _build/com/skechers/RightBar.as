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
	
	
	
	
	
	public class RightBar extends Sprite
	{
		//*********************************************************
		// CONSTANTS
		//*********************************************************
		private static const FLOOR_IND_CHANGE_SPEED         : Number = 0.45;
		private static const FLOOR_IND_SHIFT                : Number = 29;
		
		
		//*********************************************************
		// VARIABLES
		//*********************************************************
		public var rightBar_Art                             :RightBar_Art;
		
		
		
		
		
		public function RightBar()
		{
			rightBar_Art = new RightBar_Art();
			rightBar_Art.floorUp_btn.floorInd_mc.floorNum_mc.y = FLOOR_IND_SHIFT;
			rightBar_Art.floorDown_btn.floorInd_mc.floorNum_mc.y = -FLOOR_IND_SHIFT;
			
			
			addComponentsToStage();
			
		}
		
		
		
		
		
		private function addComponentsToStage():void
		{
			addChild( rightBar_Art );
		}
		
		
		
		
		
		public function selectFloor( floorNum:int ):void
		{
			//setTimeout( unlockNavButtons, ( LOCK_NAV_TIMEOUT * 1000 ) );
			
			switch( floorNum )
			{
				case 1 :
					TweenMax.to( rightBar_Art.floorUp_btn.floorInd_mc.floorNum_mc, FLOOR_IND_CHANGE_SPEED, { y:0, ease:Back.easeInOut, delay:0.0 });
					TweenMax.to( rightBar_Art.floorInd_mc.floorNum_mc, FLOOR_IND_CHANGE_SPEED, { y:-FLOOR_IND_SHIFT, ease:Back.easeInOut, delay:0.0 });
					hideButton( rightBar_Art.floorDown_btn );
					break;
				
				case 2 :
					showButton( rightBar_Art.floorUp_btn );
					showButton( rightBar_Art.floorDown_btn );
					TweenMax.to( rightBar_Art.floorUp_btn.floorInd_mc.floorNum_mc, FLOOR_IND_CHANGE_SPEED, { y:FLOOR_IND_SHIFT, ease:Back.easeInOut, delay:0.0 });
					TweenMax.to( rightBar_Art.floorInd_mc.floorNum_mc, FLOOR_IND_CHANGE_SPEED, { y:0, ease:Back.easeInOut, delay:0.0 });
					TweenMax.to( rightBar_Art.floorDown_btn.floorInd_mc.floorNum_mc, FLOOR_IND_CHANGE_SPEED, { y:-FLOOR_IND_SHIFT, ease:Back.easeInOut, delay:0.0 });
					break;
					
				case 3 : 
					hideButton( rightBar_Art.floorUp_btn );
					TweenMax.to( rightBar_Art.floorInd_mc.floorNum_mc, FLOOR_IND_CHANGE_SPEED, { y:FLOOR_IND_SHIFT, ease:Back.easeInOut, delay:0.0 });
					TweenMax.to( rightBar_Art.floorDown_btn.floorInd_mc.floorNum_mc, FLOOR_IND_CHANGE_SPEED, { y:0, ease:Back.easeInOut, delay:0.0 });
					break;
					
			}
			
		}
			
		
		private function showButton( mc:MovieClip ):void
		{
			mc.visible = true;
			TweenMax.to( mc, FLOOR_IND_CHANGE_SPEED, { alpha:1, ease:Expo.easeOut, delay:0.0 });
			
		}
		
		
		private function hideButton( mc:MovieClip ):void
		{
			TweenMax.to( mc, FLOOR_IND_CHANGE_SPEED, { alpha:0, ease:Expo.easeOut, delay:0.0, onComplete:killButton, onCompleteParams:[mc] });
			
		}
		
		
		private function killButton( mc:MovieClip ):void
		{
			mc.visible = false;
		}
		
		
		/*
		public function lockNavButtons():void
		{
			trace( "RightBar Nav : Locked" );
			rightBar_Art.floorUp_btn.mouseEnabled = false;
		}
		
		
		public function unlockNavButtons():void
		{
			trace( "RightBar Nav : Unlocked" );
			rightBar_Art.floorUp_btn.mouseEnabled = true;
		}
		*/

	}
	
}
