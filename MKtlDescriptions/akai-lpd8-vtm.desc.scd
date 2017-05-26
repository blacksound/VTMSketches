/* AKAI LPD8 Laptop Pad controller */

// custom mapping used by Verdensteatret

/*

MKtlDesc.addFolder( "".resolveRelative +/+ ".." );
m = MKtl( \lpd8, "akai-lpd8-vtm" );
m.gui;

m.elementGroup
m.elAt( 0, \pad, \1, \on ).value_( 1 ); //turns led on
m.elAt( 0, \pad, \1, \on ).value_( 0 ); //turns it off
m.elAt( 0, \pad, \1, \off ).value_( 1 ); //does not turn it on
m.elAt( 0, \pad, \1, \on ).value_( 1 ); //turns led on
m.elAt( 0, \pad, \1, \off ).value_( 0 ); // turns it off


m.elAt( 0, \padCC, \1 ).value_( 1 ); // turns it on
m.elAt( 0, \padCC, \1 ).value_( 0 ); // turns it off

// LED state is not remembered after program change
// it is remembered on switch between pad and cc

m.free;

*/

(
deviceName: "LPD8",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \knob],
status: (
	osx: "unknown",
	linux: "tested and working 2017_05_26, nescivi",
	win: "unknown"
),

idInfo: "LPD8",

deviceInfo: (
	vendorURI: "http://www.akaipro.com/product/lpd8",
	manualURI: "http://www.akaipro.com/product/lpd8#downloads",
	description: "a basic drumpad controller", // one line text
	features: [
		"8 velocity-sensitive pads",
		"8 knobs",
		"4 mode-switching buttons" // these do not actually send any data, but change modes
	],
	notes: "Custom mapping made by Verdensteatret",
	longName: "AKAI LPD8"
),

elementsDesc: (
	key: \pg,
	elements: 4.collect{ |pg|
		(
			key: pg,
			'shared': ( midiChan: pg, page: pg ),
			elements: [
				(
					key: \kn,
					shared: ( elementType: \knob, midiMsgType: \cc, ioType: \in, spec: \midiCC
					),
					elements: (9..16).collect { |num, i|
						(
							key: (i+1).asSymbol, \midiNum: num,
							style: (row: i div: 4, column: i % 4 + 4)
						)
					}
				),
				(
					key: \pad,
					shared: ( elementType: \pad, groupType: \noteOnOff, ioType: \inout ),
					elements: [64,66,68,69, 57,59,60,62].collect { |num, i|
						(
							key: (i+1).asSymbol,
							shared: ( midiNum: num, style: (row: 1 - (i div: 4), column: i % 4))
						);
					}
				),
				(
					key: \padCC,
					shared: ( elementType: \pad, midiMsgType: \cc, spec: \midiCC, ioType: \inout ),
					elements: (1..8).collect { |num, i|
						(
							key: (i+1).asSymbol,
							midiNum: num,
							style: (row: (3 - (i div: 4)).post;, column: (i % 4).postln; )
						);
					}
				)
			]
		)
}
);
);
