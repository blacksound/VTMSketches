/*
 - Connect a microphone audio input to two speakers
   * Mono input
   * Stereo output
   * Flanger filter on the signal.
*/

(
~FlangeMeUp = VTMModule.new( \micFlanger, ( // declaration
	// if context definition exists, then we can use the filename here;
	// context definition does not exist yet, so we create it here and store it in a file later; Context definition is an Environment
	definition:
	Environment.make({
		~prepare = {
            SynthDef( \flange, {arg micBus=17;
                var input, effect;
                input = SoundIn.ar(micBus) // In.ar(17,1);
                input = input + LocalIn.ar(1);
                effect = DelayN.ar(input, 0.04, SinOsc.kr(\flangerfreq.kr(0.4), 0, 0.007, 0.007)); // 40 ms mx del
                LocalOut.ar(\feedback.kr(0.5) * RLPF.ar(effect, \cutoff.kr(5000), \rq.kr(0.5)));
                Out.ar( \out.kr(0), Pan2.ar(effect, \pan.kr(0), \amp.kr(0.1)));
            }).add;
            ~synth = Synth.new( \flange, [ \out, 0, \amp, 0 ] );
            ~setPan = { arg messageName, value;
                ~synth.set( \pan, value );
            };
        };
        ~run = {
            ~synth.set( \amp, 0.1 );
		};
		~free = {
			~synth.free;
		};
		~attributes = [
			( name: \flangerfreq,
				minValue: 0.00001, maxValue: 200, defaultValue: 0.04,
				type: \float,
				clipmode: \both,
				action: { arg attr, context;
					context.execute( \setFlangerFreq, attr.name, attr.value );
				}
			),
            ( name: \feedback,
				minValue: 0.0, maxValue: 1.0, defaultValue: 0.5,
				type: \float,
				clipmode: \both,
				action: { arg attr, context;
					context.execute( \setFeedback, attr.name, attr.value );
				}
			),
            ( name: \cutoff,
				minValue: 100, maxValue: 22e3, defaultValue: 5000,
				type: \float,
				clipmode: \both,
				action: { arg attr, context;
					context.execute( \setCutoff, attr.name, attr.value );
				}
			),
            ( name: \rq,
				minValue: 0.0, maxValue: 1.0, defaultValue: 0.5,
				type: \float,
				clipmode: \both,
				action: { arg attr, context;
					context.execute( \setRq, attr.name, attr.value );
				}
			),
                ( name: \pan,
				minValue: -1.0, maxValue: 1.0, defaultValue: 0.0,
				type: \float,
				clipmode: \both,
				action: { arg attr, context;
					context.execute( \setPan, attr.name, attr.value );
				}
			)
		];
	});
));
);



















