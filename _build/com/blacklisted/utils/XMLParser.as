package com.blacklisted.utils
{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	
	
	
	
		
	public class XMLParser
	{
		private var urlReq            :URLRequest;
		public var urlLoader          :URLLoader;
		public var xmlData            :XML;
				
		
		
		
		
		public function XMLParser( url:String )
		{
			urlReq = new URLRequest( url );
			urlLoader = new URLLoader( urlReq );
			urlLoader.addEventListener( Event.COMPLETE, xmlLoaded );
			urlLoader.load( urlReq ); // LOAD
			
		}
		
		
		
		
		
		public function xmlLoaded( event:Event ):void
		{
			xmlData = new XML( urlLoader.data );
			
		}
	}
}