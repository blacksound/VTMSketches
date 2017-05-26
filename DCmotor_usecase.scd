(
~myRobot = VTMHardwareDevice.new(
	name: 'alufoil',
	declaration: (
	   	serialPortPath: '/dev/ttys8'
	),
	definition: Environment.make({
		//My Contextdefinition to be store to a file later
		~prepare = {
			var serialPortPath;
			serialPortPath = ~self.get(\serialPortPath);
			try{
//				~serialPort = SerialPort(
//					serialPortPath,
//					115200
//				).doneAction_({
//					~self.return(\robotState, \serialPortClosed);
//				}.inEnvir);
				~serialPort = serialPortPath;
				~serialPort.addUniqueMethod(\putAll, {arg ...args;
					"serial port:put all %".format(args).postln;
				});
				~serialPort.addUniqueMethod(\close, {
					"serial port:closing %".format(serialPortPath).postln;
					~self.emit(\serialPortClosed);
				}.inEnvir);
			} {
				VTMError("Did not find serial port path: '%'".format(serialPortPath)).throw;
			};

			~self.onSignal(\serialPortClosed, {
				~parser.stop;
				~sendMsgToRobot = nil;
				"Serial port was closed, parser stopped".postln;
			}.inEnvir);

			~sendMsgToRobot = {arg messageName ...args;
				var msg = [];
				//serialize into bytes that the Arduino sketch
				//understands
				~serialPort.putAll(*msg);
			};
			~parser = Routine{
				var parserState;
				var newStateValue = Pseq(
					[\goingForward, \goingBackwards, \stopped, \stoppedAtMax, \stoppedAtMin], inf
				).asStream;
				inf.do{
					//byte parsing code here....
					"new robot state: %".format(newStateValue.next).postln;
					~self.return(\robotState, newStateValue.next);
					1.wait;
				};
				//spoof serial port got disconnected
				~serialPort.close;

				5.do{
					//byte parsing code here....
					"should not come here: %".format(newStateValue.next).postln;
					~self.return(\robotState, newStateValue.next);
					1.wait;
				};
			};
			//
			~self.on(\didPrepare, {
				//start parser
				~parser.play;
			});
		};
		~free = {
			//~parser.stop;
			~serialPort !? {~serialPort.close;};
			~self.on('didFree', {
				"Im doooone".postln;
			});
		};
		~parameters = [
			\serialPortPath -> (type: \string, optional: false);
		];
		~attributes = [
			\speed -> (
				type: \integer,
				minVal: 0, maxVal: 1023,
				defaultValue: 0, clipmode: \both,
				action: {arg attr, context;
					var val = attr.value;
					"attr name '%' val %".format(attr.name, val).postln;
					context.execute(\sendMsgToRobot, attr.name, val);
				}
			),
			\direction -> (
				type: \integer,
				enum: ['forward', 'backwards'],
				restrictValueToEnum: true,
				action: {arg attr, context;
					var val = attr.value;
					"attr name '%' val %".format(attr.name, val).postln;
					context.execute(\sendMsgToRobot, attr.name, val);
				}
			)
		];
		~commands = [
			\stopListening -> (type: \integer, action: {arg cmd, context;
				"stopinng listenining: % - %".format(cmd, context).postln;
			   	~serialPort.close; });
		];
//		~presets = [
//			\fullSpeedAhead -> (speed: 0, direction: 'forward'),
//			\fullSpeedBehind -> (speed: 1023, direction: 'backward')
//		];
		~returns = [
			\robotState -> (type: \integer,
				enum: ["goingForward", "goingBackward", "stoppedAtMax"]
			)
		];
		~signals = [
			\serialPortClosed -> (type: \integer)
		];
	});
);
)
VTM.local.moduleHost;
VTM.local.hardwareSetup.items[\alufoil].fullPath
VTM.local.hardwareSetup.items[\alufoil].isUnmanaged
VTM.local.hardwareSetup.items
~myRobot.manager;
~myRobot.name;
~myRobot.free;
~myRobot.parameters
~myRobot.attributes
~myRobot.signals;
~myRobot.free;
~myRobot.commands;
~myRobot.returns
~myRobot.cues
~myRobot.envir[\self];
~myRobot.prepare;
~myRobot.set(\speed, 1023.rand)
~myRobot.set(\direction, 0.5.coin.asInteger)
~myRobot.get(\speed)
~myRobot.query(\robotState)
~myRobot.doCommand(\stopListening)
~myRobot.description;
~myRobot.fullPath;

a = VTMAttribute.new(\hei, (type: \integer));
a.addForwarding('home', NetAddr.localAddr, '/testing/iheg', true)
a.addForwarding('toMax', NetAddr.localAddr, '/toMax/iheg', false)
OSCFunc.trace
a.value_(10.rand);
a.removeAllForwardings;
a.disable;
a.enable;
a.free
