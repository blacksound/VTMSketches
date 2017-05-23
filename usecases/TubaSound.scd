/*
Map a ribbon sensor from the tuba-sensor-jacket to the frequency of an audio oscillator

* Module making sound
  - output to running synth
  - Has input for frequency


*/

(
~myTubaSound = VTMModule.new( \tubasound, ( // declaration
	// if context definition exists, then we can use the filename here;
	// context definition does not exist yet, so we create it here and store it in a file later; Context definition is an Environment
	definition:
	Environment.make({
		~prepare = {
			SynthDef( \sine, { Out.ar( \out.kr(0), SinOsc.ar( \freq.kr( 1000 ), 0, \amp.kr(0.1) ) ) }).add;
			~synth = Synth.new( \sine, [ \out, 0, \amp, 0 ] );
			~setFreq = { arg messageName, value;
				~synth.set( \freq, value );
			};
		};
		~run = {
			~synth.set( \amp, 0.1 );
		};
		~free = {
			~synth.free;
		};
		~attributes = [
			( name: \freq,
				minValue: 400, maxValue: 5000, defaultValue: 1000,
				type: \float,
				clipmode: \both,
				action: { arg attr, context;
					context.execute( \setFreq, attr.name, attr.value ); // where is the mapping to the range happening?
				}
			)
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
