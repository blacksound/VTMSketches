(
~myMaxParm = VTMModule.new( \maxparameters, ( // declaration
	// if context definition exists, then we can use the filename here;
	// context definition does not exist yet, so we create it here and store it in a file later; Context definition is an Environment
	definition:
	Environment.make({
		~prepare = {
			~oscFunc = OSCFunc.new( { |msg|
				~self.queries[ \param1 ].value_( msg[1] );
			}, '/max/param1' ).add;
		};
		~free = {
			~oscFunc.free;
		};
		~queries = [
			(
				name: 'param1',
				minValue: 0, maxValue: 1.0,
				type: \float
			)
		];
	});
));
);

// /maxparameters/param1