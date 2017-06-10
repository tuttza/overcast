#
# Overcast has a configuration file that lives in the home directory. 
# This configuration contains a list of directories to back up.
#
import os, parsecfg

const 
  overcastConfigurationDirectory: string = getHomeDir() & ".overcast"
  overcastConfigurationPathLocation: string = getHomeDir() & ".overcast/" & "backup_locations.ini"


proc displayMessage*(msg: string, msgType: string): void =
  # Message Types: SUCCESS, FAIL
  case msgType:
    of "SUCCESS":
      echo("[SUCCESS] - ", msg)
    of "FAIL":
      echo("[FAILURE] - ", msg)
    of "INFO":
      echo("[INFO] - " , msg)

proc configurationDirectoryExists*(): bool =
  if existsDir(overcastConfigurationDirectory):
    true
  else:
    false

proc configurationFileExists*(): bool =
  if existsFile(overcastConfigurationPathLocation):
    true
  else:
    false

proc createConfigurationDirectory*(): void =
  if not configurationDirectoryExists():
    createDir(overcastConfigurationDirectory)
    if configurationDirectoryExists():
      displayMessage("created configuration directory at: " & overcastConfigurationDirectory, "SUCCESS")
  else:
    displayMessage("configuration directory already exists at: " & overcastConfigurationDirectory , "INFO")

proc createConfigurationFile*(): void =
  if configurationDirectoryExists():
    var overcastConfig = newConfig()

    if not fileExists(overcastConfigurationPathLocation):
      overcastConfig.setSectionKey("BACKUP_DIRECTORIES", "home", getHomeDir())
      overcastConfig.writeConfig(overcastConfigurationPathLocation)
      if configurationFileExists():
        displayMessage("created backup_locations.ini", "SUCCESS")
    else:
      displayMessage("backup_locations.ini exists at: " & overcastConfigurationPathLocation ,"INFO")

  else:
    displayMessage("configuration directory doesn't exist", "FAIL")

proc addEntry*(iKey: string, iDir: string): bool =
  var added = false
  if configurationDirectoryExists() and configurationFileExists():
    var config = loadConfig(overcastConfigurationPathLocation)
    
    if dirExists(iDir):
      config.setSectionKey("BACKUP_DIRECTORIES", iKey, iDir)
      config.writeConfig(overcastConfigurationPathLocation)
      added = true
    else:
      displayMessage(iDir & " is an invalid path", "FAIL")

  added

proc removeEntry*(iKey: string): bool =
  var removed: bool = false
  if configurationDirectoryExists() and configurationFileExists():
    var config = loadConfig(overcastConfigurationPathLocation)
    config.delSectionKey("BACKUP_DIRECTORIES", iKey)
    config.writeConfig(overcastConfigurationPathLocation)
    removed = true

  removed





