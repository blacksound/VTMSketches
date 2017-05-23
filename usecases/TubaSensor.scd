/*
Map a ribbon sensor from the tuba-sensor-jacket to the frequency of an audio oscillator

* Module reading tuba sensor
  - Outputs the sensor value

*/

(
~myRobot = VTMHardwareDevice.new( \tubasensor, ( // declaration
	serialPortPath: '/dev/tty.usbserial440', // path is not part of definition as it may be different in each instance
	// if context definition exists, then we can use the filename here;
	// context definition does not exist yet, so we create it here and store it in a file later; Context definition is an Environment
	definition:
	Environment.make({
		~prepare = {
			~serialPort = SerialPort.new(
				~self.parameters[ \serialPortPath ], // get this from the declaration
				115200 );
			// ~serialPort.sync; // wait for serial port to be open??
			// set up parser, that sets the 'return' motorState
			~parser = Routine({
				var parserState, newSensorValue;
				loop{
					// byteparsing code here
					// ~serialPort.read ...
					~self.queries[ \ribbonSensor ].value_( newSensorValue );
					0.1.wait;
				}
			});
			~serialPort.doneAction_( {
				~parser.stop;
				~self.queries[ \ribbonState ].value_( \serialPortClosed );
			}.inEnvir ) ;
			~self.on( \prepared, {
				~self.queries[ \ribbonState ].value_( \sensorOnline );
				// start parser
				~parser.play;
			} );
		};
		~free = {
			~serialPort.close;
		};
		~commands = [
			( name: \openSerialPort, action: { "open serial port again".postln; } )
		];
		~queries = [
			// ~returns = [ // was query; this is the thing that the module outputs
			( name: \ribbonSensor, type: \integer,
				minValue: 0, maxValue: 1023, defaultValue: 0,
				clipMode: \both
			),
			( name: \ribbonState, type: \integer,
				enum: [ \sensorOnline, \serialPortClosed ],
				restrictToEnum: false // in case additional states are added in arduino, it is still reported to the outside world
			);

		];
	});
));
);
