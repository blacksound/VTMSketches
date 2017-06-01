(
	~myScene = VTMScene.new('horgan');
	~myScene2 = VTMScene.new('bing');
)


~myScene.manager;
~myScene.name;
~myScene.free;


~myScene.isUnmanaged;

VTM.local.sceneOwner.items
VTM.local.sceneOwner.free
VTM.local.sceneOwner.context


OSCFunc.trace

\sk


MIDIClient.init;
MIDIIn.connectAll;

MIDIFunc.trace;

(
~midimix = MIDIDevice("MIDI Mix", "MIDI Mix", "MIDI Mix", "MIDI Mix", 'midimix');
~mappings = IdentityDictionary.new;
[19,23,27,31,49,53,57,61].do({arg ccNum, i;
	var faderKey = "fader.%".format(i + 1).asSymbol;
	~mappings.put(faderKey, (number: ccNum, chan: 0, msgType: \control));
});
~mappings.put('fader.master', (number: 62, chan: 0, msgType: \control));
~mappings.put('solo/push', (number: 27, chan: 0, msgType: \noteOn));
~mappings.put('solo/release', (number: 27, chan: 0, msgType: \noteOff));
~mappings.put('bankRight/push', (number: 26, chan: 0, msgType: \noteOn));
~mappings.put('bankRight/release', (number: 26, chan: 0, msgType: \noteOff));
~mappings.put('bankLeft/push', (number: 25, chan: 0, msgType: \noteOn));
~mappings.put('bankLeft/release', (number: 25, chan: 0, msgType: \noteOff));
[16,20,24,28,46,50,54,58].do({arg ccNum, i;
	~mappings.put(
		"knob.%".format(i + 1).asSymbol,
		(number: ccNum, chan: 0, msgType: \control)
	);
});
[17,21,25,29,47,51,55,59].do({arg ccNum, i;
	~mappings.put(
		"knob.%".format(i + 1 + 8).asSymbol,
		(number: ccNum, chan: 0, msgType: \control)
	);
});
[18,22,26,30,48,52,56,60].do({arg ccNum, i;
	~mappings.put(
		"knob.%".format(i + 1 + 16).asSymbol,
		(number: ccNum, chan: 0, msgType: \control)
	);
});
[1,4,7,10,13,16,19,22].do({arg ccNum, i;
	~mappings.put(
		"mute.%/push".format(i + 1).asSymbol,
		(number: ccNum, chan: 0, msgType: \noteOn)
	);
	~mappings.put(
		"mute.%/release".format(i + 1).asSymbol,
		(number: ccNum, chan: 0, msgType: \noteOff)
	);
});
[3,6,9,12,15,18,21,24].do({arg ccNum, i;
	~mappings.put(
		"recArm.%/push".format(i + 1).asSymbol,
		(number: ccNum, chan: 0, msgType: \noteOn)
	);
	~mappings.put(
		"recArm.%/release".format(i + 1).asSymbol,
		(number: ccNum, chan: 0, msgType: \noteOff)
	);
});
~mappings.keysValuesDo({arg compKey, data;
	~midimix.addComponent(compKey, data[\chan], data[\number], data[\msgType]);
});
~midimix.trace;
)

(
~mappings.keysValuesDo({arg knobKey, ccNum;
	"knobKey: % cc: %".format(knobKey, ccNum).postln;
});
)
