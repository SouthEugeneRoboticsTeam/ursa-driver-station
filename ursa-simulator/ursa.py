import argparse
import curses
import socket
import struct
import threading
import time

parser = argparse.ArgumentParser(description='URSA Simulator')
parser.add_argument('--ip', type=str, default='0.0.0.0', help='IP address to bind to')
parser.add_argument('--port', type=int, default=2521, help='Port to bind to')


class CommandMessage:
  enabled = False
  advanced = False

  speed = 0
  turn = 0

  auxiliary = 0
  advanced = False

  angleP = 0
  angleI = 0
  angleD = 0

  speedP = 0
  speedI = 0
  speedD = 0

  saveRecallState = 1

  def __init__(self, data):
    self.enabled = data[0] == 1
    self.speed = data[1]
    self.turn = data[2]
    self.auxiliary = data[3]
    self.advanced = data[4] == 1

    if self.advanced:
      self.angleP = struct.unpack('<f', data[5:9])[0]
      self.angleI = struct.unpack('<f', data[9:13])[0]
      self.angleD = struct.unpack('<f', data[13:17])[0]

      self.speedP = struct.unpack('<f', data[17:21])[0]
      self.speedI = struct.unpack('<f', data[21:25])[0]
      self.speedD = struct.unpack('<f', data[25:29])[0]


  def __str__(self):
    return f'enabled: {self.enabled}, advanced: {self.advanced}, auxiliary: {self.auxiliary}, angleP: {self.angleP}, angleI: {self.angleI}, angleD: {self.angleD}, speedP: {self.speedP}, speedI: {self.speedI}, speedD: {self.speedD}, saveRecallState: {self.saveRecallState}'


class RobotState:
  robotId = 0
  modelNumber = 0

  enabled = False
  tipped = False

  pitch = 0 # double, degrees
  voltage = 0 # int
  leftMotorSpeed = 0 # int
  rightMotorSpeed = 0 # int

  auxLength = 0 # int
  containsPid = True

  pitchTarget = 0 # double, degrees
  pitchOffset = 0 # double, degrees

  speedP = 0.1 # double
  speedI = 0.2 # double
  speedD = 0.3 # double

  angleP = 0.4 # double
  angleI = 0.5 # double
  angleD = 0.6 # double

  addr = None


  def __init__(self, robotId=0, modelNumber=0):
    self.robotId = robotId
    self.modelNumber = modelNumber


  def get_telemetry(self):
    telemetry = b''

    telemetry += self.enabled.to_bytes(1, byteorder='little')
    telemetry += self.tipped.to_bytes(1, byteorder='little')
    telemetry += self.robotId.to_bytes(1, byteorder='little')
    telemetry += self.modelNumber.to_bytes(1, byteorder='little')

    telemetry += self.pitch.to_bytes(4, byteorder='little')
    telemetry += self.voltage.to_bytes(1, byteorder='little')
    telemetry += self.leftMotorSpeed.to_bytes(4, byteorder='little')
    telemetry += self.rightMotorSpeed.to_bytes(4, byteorder='little')
    telemetry += self.pitchTarget.to_bytes(4, byteorder='little')
    telemetry += self.pitchOffset.to_bytes(4, byteorder='little')

    telemetry += self.auxLength.to_bytes(1, byteorder='little')
    telemetry += self.containsPid.to_bytes(1, byteorder='little')

    if self.containsPid:
      telemetry += struct.pack('<f', self.angleP)
      telemetry += struct.pack('<f', self.angleI)
      telemetry += struct.pack('<f', self.angleD)

      telemetry += struct.pack('<f', self.speedP)
      telemetry += struct.pack('<f', self.speedI)
      telemetry += struct.pack('<f', self.speedD)

    return telemetry


state = RobotState()


def emit_telemetry(socket):
  while True:
    # emit at 20Hz
    time.sleep(0.05)

    if state.addr is None:
      continue

    data = state.get_telemetry()
    socket.sendto(data, state.addr)


def receive_commands(socket):
  while True:
    data, addr = socket.recvfrom(1024)
    command = CommandMessage(data)

    state.addr = addr

    handle_command(command)


def show_ui(stdscr):
  curses.curs_set(0)
  stdscr.nodelay(True)
  stdscr.timeout(100)

  while True:
    stdscr.clear()

    stdscr.addstr(0, 0, f'Enabled: {state.enabled}')
    stdscr.addstr(1, 0, f'Tipped: {state.tipped}')

    stdscr.addstr(3, 0, f'Pitch: {state.pitch}')
    stdscr.addstr(4, 0, f'Voltage: {state.voltage}')
    stdscr.addstr(5, 0, f'Left Motor Speed: {state.leftMotorSpeed}')
    stdscr.addstr(6, 0, f'Right Motor Speed: {state.rightMotorSpeed}')

    stdscr.addstr(8, 0, f'Pitch Target: {state.pitchTarget}')
    stdscr.addstr(9, 0, f'Pitch Offset: {state.pitchOffset}')

    stdscr.addstr(11, 0, f'Angle P: {state.angleP}')
    stdscr.addstr(12, 0, f'Speed P: {state.angleI}')

    stdscr.refresh()

    k = stdscr.getch()
    if k == ord('q'):
      break
    elif k == ord('o'):
      state.enabled = not state.enabled


def handle_command(command):
  state.enabled = command.enabled


def main():
  args = parser.parse_args()

  # Create the socket
  sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

  # Bind the socket to the specified IP and port
  sock.bind((args.ip, args.port))

  threading.Thread(target=emit_telemetry, args=(sock,)).start()
  threading.Thread(target=receive_commands, args=(sock,)).start()
  threading.Thread(target=curses.wrapper, args=(show_ui,)).start()


if __name__ == '__main__':
  main()
