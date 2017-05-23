(
~myVideoControl = VTMModule.new( \videoControl, ( // declaration
	// if context definition exists, then we can use the filename here;
	// context definition does not exist yet, so we create it here and store it in a file later; Context definition is an Environment
	definition:
	Environment.make({
		~prepare = {
			~addr = NetAddr.new( "1.2.3.123", 7000 ); // host and port of video machine
			~sendOSC = { arg msgName,val;
				~addr.sendMsg( msgName, val );
			};
		};
		~attributes = [
			( name: \lampLevel,
				minValue: 0, maxValue: 255, defaultValue: 0,
				type: \integer,
				clipmode: \both,
				action: { arg attr, context;
					context.execute( \sendOSC, '/lamp.1/level', attr.value );
				}
			)
		];
	});
));
);


//   /videoControl/lampLevel
