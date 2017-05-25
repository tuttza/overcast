
#
# Overcast has a configuration file that lives in the home directory. 
# This configuration contains a list of directories to back up.
#
import os, parsecfg

proc displayMessage(msg: string, msgType: string) =
  # Message Types: 
  #   SUCCESS
  #   FAIL
  case msgType:
    of "SUCCESS":
      echo "[SUCCESS] - ", msg
    of "FAIL":
      echo "[FAILURE] - ", msg
    of "INFO":
      echo "[INFO] - " , msg


proc createConfDir() =
  var overcastConfigDir = getHomeDir() & ".overcast"
  
  if not existsDir(overcastConfigDir):
    displayMessage("creating config directory @ " & overcastConfigDir, "INFO")
    createDir(overcastConfigDir)
  else:
    displayMessage("Overcast '.overcast' configuration directory already exists", "INFO")


proc configDirExists(): bool =
  var overcastDir = getHomeDir() & ".overcast"
  if existsDir(overcastDir):
    true
  else:
    false


proc createConfigFile() =
  if configDirExists():
    var overcastConfigLocation = getHomeDir() & ".overcast/" & "backup_locations.ini"
    var overcastConfig = newConfig()
    let BACKUP_DIRS_SECTION: string  = "BACKUP_DIRECTORIES"

    overcastConfig.setSectionKey(BACKUP_DIRS_SECTION, "home", getHomeDir())
    overcastConfig.writeConfig(overcastConfigLocation)
    
    if fileExists(overcastConfigLocation):
      displayMessage("created backup_locations.ini", "SUCCESS")
    else:
      displayMessage("failed to create backup_locations.ini", "FAIL")

  else:
    displayMessage("'.overcast' configuration directory doesn't exist", "FAIL")


