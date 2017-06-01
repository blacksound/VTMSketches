(
b = VTMHardwareDevice.new( \test, definition:
 Environment.make({
		~rel2floatDict = \hello;
		~returns = [\a -> ( type: \integer )];
		~attributes = [\e -> ( type: \integer )];
		~rel2floatDict.postln;
		~returns.postln;
		~prepare = { "hello custom prepare".postln; };
})
))
)

b.returns

(
// simple example to show that returns are not added
a = VTMMKtlDevice.new( \test, ( mktlName: \lpd, mktlDescription: "akai-lpd8" ),
	definition: Environment.make({
		~rel2floatDict = \hello;
		~returns = [\a -> ( type: \integer )];
		~attributes = [\e -> ( type: \integer )];
		~rel2floatDict.postln;
		~returns.postln;
		~prepare = { "hello custom prepare".postln; };
	})
)
);

a.returns.includes( \a  )
a.prepare



// functional version:
// returns are not added yet - actions are set fine
(
a = VTMMKtlDevice.new( \tas, ( mktlName: \tascam, mktlDescription: "tascam-us-2400", mktlIndex: 0 ),
	definition: Environment.make({
		var encoders, jog, virtualMKtl;
		virtualMKtl = MKtl.new( \virtualTascam, "tascam-us-2400", multiIndex: 0, tryOpenDevice: false );
		~rel2floatDict = ();
		encoders = virtualMKtl.elementsOfType(\encoder);
		jog = virtualMKtl.elementsOfType(\jogWheel);

		// encoders.postln;

		~returns = (encoders ++ jog).asArray.collect{ |el|
			var absName = (el.name++"_abs").asSymbol;

			~rel2floatDict.put( el.name, MIDIRelative2AbsoluteFloat.new( 0, 1024 ) );

			( absName -> ( type: \float, minVal: 0, maxVal: 1.0 ) );
			// absName
		};
		~returns.postln;
		virtualMKtl.free;

		~prepare = {
			var encoders, jog;
			~mktl.postln;
			~mktl.elementsOfType(\encoder);
			encoders = ~mktl.elementsOfType(\encoder);
			jog = ~mktl.elementsOfType(\jogWheel);
			(encoders ++ jog).do{ |el|
				var rel2fl;
				var absName = (el.name++"_abs").asSymbol;
				rel2fl = ~rel2floatDict.at( el.name );
				// add a named element with encoder absolute value
				~mktl.addNamed( absName, MKtlElement(absName, ( spec: [0,1.0,\linear].asSpec, type: \knob ) ) );
				~mktl.elAt( absName ).valueAction_( rel2fl.value );
				el.action = { |el|
					var rel2fl = ~rel2floatDict.at( el.name );
					rel2fl.midiDelta_( el.value );
					~mktl.elAt( absName ).valueAction_( rel2fl.value );
				}.inEnvir;
				~mktl.elAt( absName ).action = { |el|
					~self.return( absName, el.value );
				}.inEnvir;
			};
		};
	})
)
);
);

a.returns.postcs
.includes( 'sec_0_enc_1_abs' )

a.prepare

a.doCommand( \makeGui );

a.get( \mktlDescription )
a.get( \mktlName )
a.get( \mktlIndex )


a.returns.do{ |it| it.postcs }
a.attributes

a.query( 'sec_2_enc_7_abs' )

a.query( 'sec_2_sl_7' )


// meters

// These have a particular way of using the bits:
(
~levelSpec = [0,15,\linear,1].asSpec;
~meterVal = { |level, showPeak=false, resetOverload = false, overload=false|
	level = ~levelSpec.map( level );
	level = level.asInteger & 0x0F;
	if ( showPeak ){
		level = level | 0x10;
	};
	if ( resetOverload ){
		level = level | 0x40; // reset the overload
		if ( overload ){
			level = level | 0x20; // there is an overload
		};
	};
	level.postln;
};
);

~meterVal.value( 1 ); // no peak
~meterVal.value( 1, true ); // with peak
~meterVal.value( 1, true, true, true ); // with peak, and overload

~meterVal.value( 1, true, true, false ); // with peak, and no overload
~meterVal.value( 1, true, false ); // with peak, and no overload

MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 0.8, false ) ); // don't set peak
MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 0.8, true ) ); // set peak
MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 1, true, true, true ) ); // set overload
MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 0.5, true, false ) ); // don't change overload
MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 0.5, true, true, false ) ); // clear overload



(
~levelSpec = [0,15,\linear,1].asSpec;
~ringVal = { |level, mode=1, center=false|
	level = ~levelSpec.map( level );
	level = level.asInteger & 0x0F;
	if ( center ){
		level = level | 0x40;
	};
	switch( mode,
		// 1, { },    // data & 0x30 = 0
		// \dot, { }, // data & 0x30 = 0
		2, { level = level | 0x10; }, // data & 0x30 = 0x10
		\cutBoost, { level = level | 0x10; }, // data & 0x30 = 0x10
		3, { level = level | 0x10; }, // data & 0x30 = 0x20
		\spread, { level = level | 0x20; }, // data & 0x30 = 0x20
		4, {
			level = level | 0x10;
			level = level | 0x20;
		}, // data & 0x30 = 0x20
		\width, {
			level = level | 0x10;
			level = level | 0x20;
		} // data & 0x30 = 0x20
	);
	level.postln;
};
);

~ringVal.value( 0.5, \dot, true ); // no peak

MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.3, \dot ) ); // dot mode, no center

MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.7, \cutBoost ) ); // cut Boost mode, no center // mapping a little weird

MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.2, \width ) ); // width mode, no center // only goes up to 0.5

MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.2, \spread ) ); // spread mode, no center
MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.8, \spread ) ); // spread mode, no center
MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.2, \spread ) ); // spread mode, no center
MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.8, \spread, true ) ); // spread mode, center
MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.3, \spread, false ) ); // spread mode, no center
