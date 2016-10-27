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
	//import eyeblaster.videoPlayer.controls.Timer;
	
	
	
	
	
	public class InfoBar extends Sprite
	{
		//*********************************************************
		// CONSTANTS
		//*********************************************************
		private static const WEATHER_XML           : String = "http://xml.weather.yahoo.com/forecastrss?p=USCA1024&u=f"; // YAHOO! Weather
		
		
		//*********************************************************
		// VARIABLES
		//*********************************************************
		public var infoBar_Art                     : InfoBar_Art;
		private var infoBar_Container              : InfoBar_Container;
		
		
		//********************
		// Date | Time
		//********************		
		private var dateTimer                      : Timer;
		private var dateMc                         : Date = new Date();
		private var date_Hour                      : String;
		private var date_Minutes                   : String;
		private var date_Seconds                   : String;
		private var date_Day                       : String;
		private var date_Month                     : String;
		private var date_Date                      : String;
		private var date_Merridian                 : String;
		
		
		//********************
		// Weather
		//********************
		//private var weather_loader                 :Loader;
		private var weatherTimer                   : Timer;
		private var yweather                       : Namespace;
		private var weather_xml                    : XMLParser;
		
		
		
		
		
		public function InfoBar()
		{
			infoBar_Art = new InfoBar_Art();
			

			infoBar_Container = new InfoBar_Container();
			infoBar_Container.x = 1900;
			infoBar_Container.y = 20;
			
			
			weatherTimer = new Timer( 1800000, 0 );
			weatherTimer.addEventListener( TimerEvent.TIMER, getWeather );
			weatherTimer.start();

			
			dateTimer = new Timer( 1000, 0 );
			dateTimer.addEventListener( TimerEvent.TIMER, constructTime );
			dateTimer.addEventListener( TimerEvent.TIMER, constructDate );
			dateTimer.start();
			
			
			constructDate( null );
			getWeather( null );
			
			
			addComponentsToStage();
			
		}
		
		
		
		
		
		private function getWeather( e:TimerEvent ):void
		{
			weather_xml = new XMLParser( WEATHER_XML );
			weather_xml.urlLoader.addEventListener( IOErrorEvent.IO_ERROR, xmlLoad_ERROR );
			weather_xml.urlLoader.addEventListener( Event.COMPLETE, xmlLoad_COMPLETE );
			
		}
		
		
		
		
		
		public function addComponentsToStage():void
		{
			addChild( infoBar_Art );
			addChild( infoBar_Container );
			
		}
		
		
		
		
		
		private function constructTime( e:TimerEvent ):void
		{
			dateMc = new Date();
			
			date_Hour = getCurrentHour( dateMc.getHours() );
			date_Minutes = getCurrentMinutes( dateMc.getMinutes() );
			date_Seconds = getCurrentSeconds( dateMc.getSeconds() );
			date_Merridian = getCurrentMerridian( dateMc.getHours() );

			//trace( date_Hour, date_Minutes, date_Seconds, date_Merridian );
			
			infoBar_Container.time_txt.text = date_Hour + ":" + date_Minutes + ":" + date_Seconds + " " + date_Merridian;
			
		}
		
		
		
		
		
		private function getCurrentHour( hourCode:int ):String
		{
			var hour;
			
			if( hourCode > 12 )
			{
				hour = String( hourCode - 12 );
			}
			else if( hourCode == 0 )
			{
				hour = String( 12 );
			} 
			else
			{
				hour = String( hourCode );
			}
			
			return hour;
		}
		
		
		
		
		
		private function getCurrentMinutes( minutesCode:int ):String
		{
			var minutes;
			
			if( minutesCode < 10 )
			{
				minutes = "0" + String( minutesCode );
			}
			else
			{
				minutes = String( minutesCode );
			}
			
			return minutes;
		}
		
		
		
		
		
		private function getCurrentSeconds( secondsCode:int ):String
		{
			var seconds;
			
			if( secondsCode < 10 )
			{
				seconds = "0" + String( secondsCode );
			}
			else
			{
				seconds = String( secondsCode );
			}
			
			return seconds;
		}
		
		
		
		
		
		private function getCurrentMerridian( hoursCode:int ):String
		{
			var merridian;
			
			
			if( hoursCode < 12 )
			{
				merridian = "AM";
			}
			else
			{
				merridian = "PM";
			}
			
			
			return merridian;
			
		}
		
		
		
		
		
		private function constructDate( e:TimerEvent ):void
		{		
			date_Day = getCurrentDay( dateMc.day );
			date_Month = getCurrentMonth( dateMc.month );
			date_Date = String( dateMc.date );
			
			infoBar_Container.date_txt.text = date_Day + ", " + date_Month +  " " + date_Date;
			
		}
		
		
		
		
		
		private function getCurrentDay( dayCode:int ):String
		{
			var day;
			
			switch( dayCode )
			{
				case 0 :
					day = "SUNDAY";
					break;
					
				case 1 :
					day = "MONDAY"
					break;
					
				case 2 :
					day = "TUESDAY";
					break;
					
				case 3 :
					day = "WEDNESDAY";
					break;
					
				case 4 :
					day = "THURSDAY";
					break;
					
				case 5 :
					day = "FRIDAY";
					break;
					
				case 6 :
					day = "SATURDAY";
					break;				
				
			}
			
			return day;
			
		}
		
		
		
		private function getCurrentMonth( monthCode:int ):String
		{
			var month;
			
			switch( monthCode )
			{
				case 0 :
					month = "JANUARY";
					break;
					
				case 1 :
					month = "FEBRUARY";
					break;
					
				case 2 :
					month = "MARCH";
					break;
					
				case 3 :
					month = "APRIL";
					break;
					
				case 4 :
					month = "MAY";
					break;
					
				case 5 :
					month = "JUNE";
					break;
					
				case 6 :
					month = "JULY";
					break;
					
				case 7 :
					month = "AUGUST";
					break;
					
				case 8 :
					month = "SEPTEMBER";
					break;
					
				case 9 :
					month = "OCTOBER";
					break;
					
				case 10 :
					month = "NOVEMBER";
					break;
					
				case 11 :
					month = "DECEMBER";
					break;
					
			}
			
			return month;
			
		}
		
		
		
		
		//************************************************************************
		// WEATHER
		//************************************************************************
		private function xmlLoad_ERROR(e:IOErrorEvent):void {
			
			trace( "ERROR: " + e );
			
		}
		
		
		
		
		
		
		
		private function xmlLoad_COMPLETE(e:Event):void {
			
			yweather = weather_xml.xmlData.namespace( "yweather" );		

			infoBar_Container.temp_txt.text = String( weather_xml.xmlData.channel.children()[12].yweather::condition.@temp );
			//infoBar_Container.condition_txt.text = String( weather_xml.xmlData.channel.children()[12].yweather::condition.@text );
			//trace( weather_xml.xmlData.channel.children()[12].yweather::condition.@temp );
		}
		
	}
	
}
