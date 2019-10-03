# Linux specific code to list available serial ports.

import os

const deviceGrepPaths = ["/dev/ttyS*", "/dev/ttyUSB*", "/dev/ttyACM*", "/dev/ttyAMA*", "/dev/rfcomm*"]

proc checkPath(path: string): bool =
  let fileName = extractFilename(path)
  let fullDevicePath = "/sys/class/tty" / filename / "device" # serial have this path
  let fullDeviceRFPath = "/sys/class/tty" / filename / "dev" #

  var subsystem: string = ""

  if symlinkExists(fullDevicePath):
    let devicePath = expandFilename(fullDevicePath)
    subsystem = extractFilename(expandFilename(devicePath / "subsystem"))

    if subsystem != "platform":
      result = true
  
  elif fileExists(fullDeviceRFPath):
    result = true

  else:
    result = false
  

iterator getPortsForPath(path: string): string =
  for f in walkPattern(path):
    if checkPath(f):
      yield f

iterator listSerialPorts*(): string =
  for path in deviceGrepPaths:
    for port in getPortsForPath(path):
      yield port
