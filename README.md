# OrCad Install and License Guide

**Install**
- Download SmartStart.zip and unpack in a directory of your choosing
- As administrator run SmartStartCompany.bat
- When prompted to set up license, close the windows and press enter in the terminal to finish installation

**License**
- Locate folder called "Cadence Release 17.2-2016" in start menu
- As administrator run "License Client Configuration Utility"

**Check if License is Installed Properly**
- In file explorer, right click on "This PC" and select "properties"
- Open "advanced system settings"
- Click on "environment variables"
- Under "system variables" select "CDS_LIC_FILE"
- If the value of "CDS_LIC_FILE" is "5280@dkcph1-ccsserv" you are all set, if not, click "edit" to change the "variable value".

**Using the License**\
There is currently only one available license. If the license was recently used on a different PC the server license manager can sometimes take a while to release it for an other user. If this happens,
- Open "CheckOrcadLicenseManager" (located in "\\\winserv\OrCAD\\")
- Log in using your DHI credentials
- Click "restart orcad license manager"

Good Luck!
