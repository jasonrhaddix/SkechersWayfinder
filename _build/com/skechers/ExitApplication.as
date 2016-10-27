package com.skechers
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import com.blacklisted.utils.GlobalVarContainer;
	
	
	
	
	
	public class ExitApplication extends Sprite
	{		
		private var _stage:Stage;
		
		
		
		
		
		public function ExitApplication()
		{
			_stage = GlobalVarContainer.stage._stage;
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
	
		}
		
		
		
		
		
		private function keyDown( e:KeyboardEvent ):void
		{
			//trace( "KEY PRESS : " + e );
			
			if  ( e.keyCode == Keyboard.ESCAPE )
			{
				_stage.nativeWindow.close();
				
			}
			
		}
		
	}
	
}