(
~mySoundfiles= VTMHardwareDevice('beagleboneSoundLooper',
	(
		\abba: (
			\jingle: "/Users/Stirling/PollySounds/scenes/mamma/jingle/mamma_jingle.wav",
			\files: [
				"/Users/Stirling/PollySounds/scenes/mamma/tune_elements/Mamma_Mia1_8beat.wav",
				"/Users/Stirling/PollySounds/scenes/mamma/tune_elements/Mamma_Mia2_8beat.wav",
				"/Users/Stirling/PollySounds/scenes/mamma/tune_elements/Mamma_Mia3_chorus_16beat.wav",
				"/Users/Stirling/PollySounds/scenes/mamma/tune_elements/Mamma_Mia4_chorus_16beat.wav",
				"/Users/Stirling/PollySounds/scenes/mamma/tune_elements/Mamma_Mia5_chorus_16beat.wav",
				"/Users/Stirling/PollySounds/scenes/mamma/tune_elements/Mamma_Mia6_chorus_16beat.wav"
			]
		),
		\beat: (
			\jingle: "/Users/Stirling/PollySounds/scenes/submarine/jingle/submarine_jingle.wav",
			\files: [
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine1-1.wav",
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine1-2.wav",
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine2-1.wav",
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine2-2.wav",
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine2-3.wav",
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine3.wav",
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine4.wav",
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine5.wav",
				"/Users/Stirling/PollySounds/scenes/submarine/tune_elements/submarine6.wav"
			]
		),
		\arvo: (
			\jingle: "/Users/Stirling/PollySounds/scenes/arvo/jingle/arvo_falsk.aiff",
			\files: [
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_bas1.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_bas2.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_bas3.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_bas4.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_blas_wagner.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_blas1.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_blas2.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_blasklang1.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_blasklang2.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_blasklang3.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_doom.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_klocka.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_kompfunk1.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_kompfunk2.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_kompfunk3.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_trummaskin1.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_trummaskin2.aiff",
				"/Users/Stirling/PollySounds/scenes/arvo/tune_elements/arvo_trummaskin3.aiff"
			]
		)
	),
	definition: Environment.make{
		~prepare= {
			SynthDef(\beagleboneSoundJingle, {|out= 0, buf, amp= 0.5, gate= 1|
				var env= EnvGen.kr(Env.asr(0.01, amp, 0.1), gate, doneAction:2);
				var snd= PlayBuf.ar(2, buf, loop:1);
				Out.ar(out, snd*env);
			}).add;
			SynthDef(\beagleboneSoundLooper, {|out= 0, buf, amp= 0.5|
				var snd= PlayBuf.ar(2, buf, doneAction:2);
				Out.ar(out, snd*amp);
			}).add;
			~self.declaration.do{|e|  //create buffers for all jingles
				e.put(\jingleBuffer, Buffer.read(s, e.jingle));
			};
		};
		~startMusic= {|music|
			s.bind{
				~freeBuffers.value;  //free any previous files
				~playJingle(music).value;  //start playing jingle
				~preloadBuffers.value(music);  //load new files
				s.sync;
				~stopJingle;  //stop jingle
				~playMusic.value;  //play files in order
				s.sync;
			};
		};
		~jingleSynth= nil;
		~filesSynth= nil;
		~buffers= [];
		~freeBuffers= {
			~buffer.do{|buf| buf.free};
		};
		~playJingle= {|music|
			~jingleSynth= Synth(\beagleboneSoundJingle, [\buf, ~self.declaration[music][\jingle]]);
		};
		~preloadBuffers= {|music|

		};
		~stopJingle= {
			~jingleSynth.release;
		};
		~playMusic= {|music|

		};
		~free= {
			~jingleSynth.release;
			~self.declaration.do{|e|  //create buffers for all jingles
				e[\jingleBuffer].free;
			};
		};
		~attributes= [
			(
				name: \scene, type: \integer,
				enum: ['abba', 'beatles', 'arvo'],
				restrictToEnum: true,
				action: {|attr, context|
					var val= attr.value;
					context.execute(\startMusic, attr.name, val);
				}
			)
		];
	}
)
)
