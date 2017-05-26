// Behringer BCF2000 specs for Verdensteatret
// this is just preset 1
/*

pr[]
tr[page][column]
kn[page][column]
bt[row][column]
sl[row][column]

MKtlDesc.addFolder( "".resolveRelative +/+ ".." );
MKtl('bcf', "behringer-bcf2000-vtm",multiIndex:0);
MKtl('bcf').gui

MKtl('bcf').elAt(\sl,0).value_(0.5)
MKtl('bcf').elAt(\sl,0).value_(0.48)

MKtl('bcf').trace;

MKtl('bcf').device.cc14helpers
MKtl('bcf').device.midiKeyToElemDict.postcs

*/


(

deviceName: "BCF2000",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \button, \encoder],
status: (
	linux: "tested and working. 25-05-2017 by nescivi",
	osx: "",
	win: "unknown"),

// assuming IO is on port 1, port 2 is ext in/out, port 3 is out only
idInfo: (deviceName: "BCF2000", srcPortIndex: 0, destPortIndex: 0),

hardwarePages: [1, 2, 3, 4],

specs: (
	fader10bit: [0, 1023, \linear, 1, 0 ].asSpec,
),

deviceInfo: (
	vendorURI: "http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/BCF2000/p/P0246",
	manualURI: "https://media.music-group.com/media/PLM/data/docs/P0246/BCF2000_BCR2000_M_EN.pdf",
	// description: "",
	features: [
		"8 motor-faders",
		"8 rotary-encoder",
		"30 Buttons"
	],
	// notes: "",
	longName: "Behringer BCF2000"
),
elementsDesc: (
	shared: ( midiChan: 0),
	elements: [
		//buttons at bottom right
		(
			key: \pr,
			shared: (elementType: \button, spec: \midiBut, ioType: \inout, midiMsgType: \cc),
			elements: [
				( midiNum: 96, \style: (row:4, column: 8),  mode: \toggle ),
				( midiNum: 97, \style: (row:4, column: 9),  mode: \toggle ),
				( midiNum: 98, \style: (row:5, column: 8),  mode: \push ),
				( midiNum: 99, \style: (row:5, column: 9),  mode: \toggle )
			]
		),
		//upper row of encoders when pressed, 4 pages, 8 rows
		(
			key: \tr,
			shared: (elementType: \button, spec: \midiBut, ioType: \in, midiMsgType: \cc),
			elements: 4.collect { |j|
				(
					elements: 8.collect { |i|
						// top knob push mode
						(midiNum: 40+(8*j)+i, page: j, \style: (row:1, column: i))
					}
				)
			}
		),
		//upper row of encoders, 4 pages, 8 rows
		(
			key: \kn,
			shared: (elementType: \encoder, spec: \midiCC, ioType: \inout, midiMsgType: \cc),
			elements: [ (80..87), (8..15), (16..23), (24..31) ].collect { |ccs,j|
				(
					elements: ccs.collect { |ccnum, i|
						( midiNum: ccnum, page: j, \style: (row:0, column: i))
					}
				)
			}
		),
		//buttons
		(
			key: \bt,
			shared: (elementType: \button, spec: \midiCC, ioType: \inout, midiMsgType: \cc),
			elements: [72,88].collect { |ccStart,j|
				(
					elements: 8.collect { |i|
						(midiNum: ccStart+i, \style: (row:2+j, column: i), \mode: [\toggle,\push].at(j) )
					}
				)
			}
		),
		//sliders
		(
			key: \sl,
			shared: (elementType: \slider, spec: \fader10bit, ioType: \inout, midiMsgType: \cc14),
			elements: 8.collect { |i| (midiNum: i, \style: (row:4, column: i)) }
		)
	]
)
)