Setting Up Flash CS4
===================================================
It is much more convenient to add the PQMultiTouch API for Flash SWC component to Flash CS4. To do so:

From the main menu, select File > Publish Settings and select the Flash tab.

Next, click the Settings button next to the Script drop down menu to display the Advanced ActionScript 3.0 Settings dialog box. Click the Library path tab.

Add the path of PQMultiTouch API for Flash SWC component to Library path, that's OK.


===================================================
NOTE:  to gain enough trust for security, you need to do the following things.
(Windows)   Run FlashPlayerTrust.cmd 

(Mac OS X) 
1. Create a folder named "FlashPlayerTrust" on the following directories: 
<app support>/Macromedia/FlashPlayerTrust
(e.g. /Library/Application Support/Macromedia/FlashPlayerTrust)

2. Create a cfg file that contains the path to the folder containing the resource, 
you can create the cfg file using the "Notepad"/"Textedit". In that file specify 
the path of the folder and save it using a your_custom_name.cfg (eg myFlashTrust.cfg)
You must place the cfg file to the FlashPlayerTrust folder that you created.


