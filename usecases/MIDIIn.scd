/*
An on-stage performer triggers the playback of a sound file into a steel plate speaker

- The performer has only a MIDI controller, and no sound output, connected to its RPi.
- The sound is to be played from the sound spatialization computer.
- The sound is played from one speaker. Mono soundfile and mono output.
When the sound is triggered the performer can forget about the sound file, everything is cleaned up after playback has finished.
- One-shot playback


*/

(
// could be a VTMModule
~midiController = VTMHardwareDevice.new( \midiControlButton, ( // declaration
	definition:
	Environment.make({
		~prepare = {
			// init MIDI
			// select MIDI device
			~midiFunc = MIDIFunc.cc( { |val|
				if ( val > 0, {
					~self.queries[ \trigger ].value_( 1 );
				},{
					~self.queries[ \trigger ].value_( 0 );
				}
				);
			}, 6, 12 ); // cc 6 on channel 12
		};
		~free = {
			~midiFunc.free;
			// close MIDI device ?
		};
		~queries = [
			// ~returns = [ // was query; this is the thing that the module outputs
			( name: \trigger, type: \integer,
				minValue: 0, maxValue: 1, defaultValue: 0,
			)
		];
	});
));
);
