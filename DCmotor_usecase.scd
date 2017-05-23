(
~myRobot = VTMHardwareDevice.new('alufoil', 
	( serialPortPath: '/dev/tty.usbserial440'),
	definition: Environment.make{
		//My Contextdefinition to be store to a file later
		~prepare = {
			~serialPort = SerialPort(
				~self.parameters[\serialPortPath],
				115200
			).doneAction_({
				~self.queries[\robotState].value_(\serialPortClosed);
			}.inEnvir);

			~self.onSignal(\serialPortClose, {
				~parser.stop;
			}.inEnvir);

			~sendMsgToRobot = {arg messageName ...args;
				var msg = [];
				//serialize into bytes that the Arduino sketch
				//understands
				~serialPort.putAll(*msg);
			};
			~parser = Routine{
				var parserState;
				var newStateValue = \goingForward;
				loop{
					//byte parsing code here....
					~self.queries[\robotState].value_(newStateValue);
				};
			};
			//
			~self.on(\prepared, {
				//start parser
				~parser.play;
			});
		};

		~free = {
			~parser.stop;
			~serialPort.close;
			~self.on("freed", {
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
		~return = [
			(name: \robotState, type: \integer,
				enum: ["goingForward", "goingBackward", "stoppedAtMax"]
			)
		];
	}
);
)


Environment
