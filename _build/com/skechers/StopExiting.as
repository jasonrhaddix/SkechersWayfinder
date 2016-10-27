package com.skechers  
{  
     import flash.display.MovieClip;  
     import flash.events.Event;  
     import flash.desktop.NativeApplication;  
     import flash.display.Stage;
	 import flash.display.NativeWindow;  
     import flash.display.NativeWindowInitOptions;  
     import flash.display.NativeWindowSystemChrome;  
     import flash.display.NativeWindowType;
	 
	 import com.blacklisted.utils.GlobalVarContainer;
	 
     
	 
	 
	 
	 
     public class StopExiting extends MovieClip  
     {  
	 	  var _stage : *;
		 
		  
          public function StopExiting()  
          {  
               _stage = GlobalVarContainer.stage._stage;
			   
			   _stage.nativeWindow.addEventListener(Event.CLOSING, closeApplication, false, 0, true);   
          }  
            
			
			
			
			
          public function closeApplication(e:Event):void  
                {        
              //trace("don't exit");  
              e.preventDefault();  
  
                    //here is where i can add my prompt  
  
              var windowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();  
              windowOptions.systemChrome = NativeWindowSystemChrome.STANDARD;  
              windowOptions.type = NativeWindowType.NORMAL;  
  
               var newWin:NativeWindow = new NativeWindow(windowOptions);  
              newWin.width = 300;  
              newWin.height = 200;  
              newWin.title = "Are you sure?";  
              newWin.activate();  
              newWin.addEventListener(Event.CLOSING, exitAll);  
          }  
           
		   
		   
		   
		   
          public function exitAll(e:Event):void  
          {  
                 NativeApplication.nativeApplication.exit();  
                 
           }  
                 
     }  
	 
}  
