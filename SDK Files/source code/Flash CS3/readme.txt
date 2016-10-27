1.Setting Up Flash CS3
===================================================
Before you begin authoring a PQMultiTouch application within Flash CS3, you first need to add the PQMultiTouch API for Flash SWC component to Flash CS3. To do so:

If you have Flash CS3 currently open, quit the application.

Create a "PQLabs" directory in one of the following locations and copy the SWC file there:

(Windows) C:\Program Files\Adobe\Adobe Flash CS3\en\Configuration\Components
      or  C:\Program Files\Adobe\Adobe Flash CS3\zh_cn\Configuration\Components	
(Note that there is a separate directory for each language supported in Flash CS3. Place the SWC within whatever language directory you will be authoring Flash content.)

(Mac OS X) Macintosh HD/Applications/Adobe Flash CS3/Configuration/Components 

Restart Flash CS3.
Select Window -> Components. A Components dialog box will appear. Click on the PQLabs selector to display the PQMTLib component.

Click on the PQMTLib and drag it onto the Stage. A thin blue bounding box will appear on the blank stage. , that's OK.

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


