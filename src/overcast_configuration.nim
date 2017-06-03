#
# Overcast has a configuration file that lives in the home directory. 
# This configuration contains a list of directories to back up.
#
import os, parsecfg, streams

const 
  overcastConfigurationDirectory: string = getHomeDir() & ".overcast"
  overcastConfigurationPathLocation: string = getHomeDir() & ".overcast/" & "backup_locations.ini"

proc displayMessage(msg: string, msgType: string): void =
  # Message Types: SUCCESS, FAIL
  case msgType:
    of "SUCCESS":
      echo("[SUCCESS] - ", msg)
    of "FAIL":
      echo("[FAILURE] - ", msg)
    of "INFO":
      echo("[INFO] - " , msg)

proc configurationDirectoryExists(): bool =
  if existsDir(overcastConfigurationDirectory):
    true
  else:
    false

proc configurationFileExists(): bool =
  if existsFile(overcastConfigurationPathLocation):
    true
  else:
    false

proc createConfigurationDirectory(): void =
  if not configurationDirectoryExists():
    createDir(overcastConfigurationDirectory)
    if configurationDirectoryExists():
      displayMessage("created configuration directory at: " & overcastConfigurationDirectory, "SUCCESS")
  else:
    displayMessage("configuration directory already exists at: " & overcastConfigurationDirectory , "INFO")

proc createConfigurationFile(): void =
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

proc addDirectory(iKey: string, iDir: string): void =   
  if configurationDirectoryExists() and configurationFileExists():
    var config = loadConfig(overcastConfigurationPathLocation)

    var file = newFileStream(overcastConfigurationPathLocation, fmRead)
    
    if file != nil:
      var parser: CfgParser
      open(parser, file, overcastConfigurationDirectory)
      
      while true: 
        var e = next(parser)

        case e.kind
          
          of cfgEof:
            displayMessage("backup_locations.ini has reached EOF!", "INFO")
            break
          
          of cfgSectionStart:   ## a ``[section]`` has been parsed
            if e.section != "BACKUP_DIRECTORIES":
              break
          
          of cfgKeyValuePair:
            # ensure that the key/dir doesn't already exist
            if e.key == iKey and e.value == iDir:
              echo "here"
              displayMessage("KEY: " & iKey & "DIRECTORY: " & iDir & "already exists", "FAILURE")
              break

            ## check that the provided directory exists
            if dirExists(iDir) == true:
              config.setSectionKey("BACKUP_DIRECTORIES", iKey, iDir)
              config.writeConfig(overcastConfigurationPathLocation)
              displayMessage("\n\tAdded:\t\n\t\tKEY: " & iKey & "\n\t\tDIRECTORY: " & iDir, "SUCCESS")
            else:
              displayMessage("directory: " & iDir & "either doesn't exist or is not valid", "FAILURE")
              break

          of cfgOption:
            echo("command: " & e.key & ": " & e.value)
          
          of cfgError:
            displayMessage(e.msg, "FAILURE")
      
      close(parser)
    
    else:
     echo("cannot open backup_locations.ini: " & overcastConfigurationPathLocation)

  else:
    displayMessage("neither the configuration directory and configuration file exist...", "INFO")


