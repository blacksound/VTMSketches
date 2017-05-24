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
			serialPortPath = ~self.parameters[\serialPortPath];
			try{
//				~serialPort = SerialPort(
//					serialPortPath,
//					115200
//				).doneAction_({
//					~self.queries[\robotState].value_(\serialPortClosed);
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
				5.do{
					//byte parsing code here....
					"new robot state: %".format(newStateValue.next).postln;
					//~self.queries[\robotState].value_(newStateValue.next);
					1.wait;
				};
				//spoof serial port got disconnected
				~serialPort.close;
			};
			//
			~self.on(\didPrepare, {
				//start parser
				~parser.play;
			});
		};
		~free = {
			~parser.stop;
			~serialPort.close;
			~self.on('didFree', {
				"Im doooone".postln;
			});
		};
		~attributes = [
			(
				name: \speed, type: \integer,
				minVal: 0, maxVal: 1023,
				defaultValue: 0, clipmode: \both,
				action: {arg attr, context;
					var val = attr.value;
					context.execute(\sendMsgToRobot, attr.name, val);
				}
			),
			(
				name: \direction, type: \integer,
				enum: ['forward', 'backwards'],
				restrictToEnum: true,
				action: {arg attr, context;
					var val = attr.value;
					context.execute(\sendMsgToRobot, attr.name, val);
				}
			)
		];
		~queries = [
			(name: \robotState, type: \integer,
				enum: ["goingForward", "goingBackward", "stoppedAtMax"]
			)
		];
	});
);
)

a = VTMOrderedIdentityDictionary.newFrom([\hei -> (type: \integer)])
~myRobot.name;
~myRobot.parameters
~myRobot.attributes.items;
~myRobot.signals.items;
~myRobot.commands.items;
~myRobot.queries.items[\state].fullPath;
~myRobot.cues;
~myRobot.envir[\self];
~myRobot.signal(\serialPortClosed);
~myRobot.prepare;
