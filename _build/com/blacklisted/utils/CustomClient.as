package com.blacklisted.utils
{	
	import com.blacklisted.utils.GlobalVarContainer;
	
	
	
	
	
	public class CustomClient
	{
		private var _main                  : *;
		private var videoBg_IsComplete     : Boolean;
		
		public var videoWidth              : int;
		public var videoHeight             : int;
		
		
		
		
		
		public function CustomClient()
		{
			_main = GlobalVarContainer.vars._main;
			videoBg_IsComplete = true;
			
		}
		
		
		
		
		
		public function onPlayStatus( infoObject:Object ):void
		{
			for( var prop in infoObject )
			{
				//trace("\t"+prop+":\t"+infoObject[prop]);
				
				if( prop == "code" && infoObject[prop] == "NetStream.Play.Complete" )
				{
					videoBg_IsComplete = true;
					_main.replayVideoBackground();
					
				}
					
			}
				
		}
		
		
		
		
		
		public function onMetaData( infoObject:Object ):void
		{
			//trace( "MetaData: duration=" + infoObject.duration + " width=" + infoObject.width + " height=" + infoObject.height + " framerate=" + infoObject.framerate );
			
			GlobalVarContainer.vars._videoLength = infoObject.duration;
			
			videoWidth = infoObject.width;
			videoHeight = infoObject.height;
			
		}
		
		
		
		
		
		public function onXMPData( infoObject:Object):void
		{
			//trace("XMPData");
				
		}
		
		
		
		
		
		public function onCuePoint( infoObject:Object ):void
		{
			//trace( "Cuepoint: time=" + infoObject.time + " name=" + infoObject.name + " type=" + infoObject.type );
				
		}
		
	}
	
}