/****

Running into an issue with noteOnOff:
https://github.com/ModalityTeam/Modality-toolkit/issues/296

The device is sending out midiVel = 100 for both, which creates a problem.
I am defining the elements separately now.

There is an issue that this means the noteOn will never be turned off by a noteOff.
A solution would be to change the microcontroller code.


MKtlDesc.addFolder( "".resolveRelative +/+ ".." );

a = MKtl( 'knobs', "magnificent-knob-twister" );

a.gui;

a.elAt( \bt, 1, 2, \on ).elemDesc
a.elAt( \bt, 1, 2, \off ).elemDesc

a.elAt( \bt, 1, 2 ).action = { |el| el.value.postln }

a.rebuild( "magnificent-knob-twister", false );

MKtlDesc.allDescs



****/

(
deviceName: "Teensy MIDI", // gonna change
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [\knob, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "Teensy MIDI", // gonna change in the microcontroller code

specs: (
	magButton: [0,100,\linear,1].asSpec;
),

//hardwarePages: [1, 2, 3, 4],

 deviceInfo: (
 vendorURI: 'https://niklasadam.oddodd.org',
 //manualURI: 'https://',
	// description: ,
	 features: [
        "20 Knobs",
		"10 Buttons",
		"4 Pages"
    ],
	// notes: ,
    longName: "Magnificent Knob Twister" // is a longName needed ? - it is descriptive
	// hasScribble: false
),
elementsDesc: (
    shared: ( 'midiChan': 0 ),
    elements: [
        (
            key: \kn,
            shared: ( 'midiMsgType': 'cc', 'elementType': 'knob', 'spec': 'midiCC' ),
            elements: 4.collect{ arg pg;
				(
					key: pg,
                    elements: ((1..20)+(pg*20)).collect{ arg item, i;
                        ( key: i, midiNum: item, page: pg,
                            style: ( row: (i/5).floor, column: i%5, height: 1 )
                        )
                    };
                )
            }
        ),
        (

            key: \bt,
            shared: ( elementType: 'button',  mode: \push ),
            elements: 4.collect{ arg pg;
				(
					key: pg,
					shared: ( page: pg ),
					elements: ((48..57)+(pg*10)).collect{ arg item, i; // (48..87)
						(
							key: i,
							shared: (
								// groupType: \noteOnOff, // see note above
								midiNum: item, spec: 'magButton'
							),
							elements: [
								(
									key: \on, midiMsgType: \noteOn,
									style: ( row: (i/5).floor + 4, column: i%5, height: 0.65 )
								),
								(
									key: \off, midiMsgType: \noteOff,
									style: ( row: (i/5).floor + 4.5, column: i%5, height: 0.65 )
								)
							]
						)
					};
				);
			};
        )
	]
)
);