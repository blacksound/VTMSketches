
//No path specified, no type
~myAttr = VTMAttribute(\hallo);
~myAttr.action = {|attr| "Got it!: % - %".format(attr.name, attr.value).postln; };
~myAttr.fullPath;
~myAttr.enableOSC;

NetAddr.localAddr.sendMsg(~myAttr.fullPath, 100.rand);


//Path manually defined, no type
~myAttr = VTMAttribute('heisann', (path: '/myPath'));
~myAttr.action = {|attr| "Got it!: % - %".format(attr.name, attr.value).postln; };
~myAttr.fullPath; //
~myAttr.enableOSC;
NetAddr.localAddr.sendMsg(~myAttr.fullPath, 100.rand);

//Unmanaged context
(
~myContext = VTMModule('trumper',
	declaration: ( characteristics: 'insane'),
	definition: Environment.make
	{
		~attributes = [
			'strength' -> (
				type: 'float',
				minVal: 0, maxVal: 100,
				defaultValue: 50,
				clipmode: 'both',
				action: { |attr, context|
					format("attr name: %, attr val: %",
						attr.name, attr.value).postln;
				}
			)
		];
		~commands = [];
		~returns = [];
	};
)
)

~myContext.fullPath;//should return '/:modules/trumper'
~myContext.isUnmanaged; //should be true
~myContext.description
~myContext.enableOSC();
~myContext.getChildren();

NetAddr.localAddr.sendMsg('/:modules/trumper:attributes/strength', 3.3234);

// try learning from i-score
NetAddr.localAddr.port_(9997).sendMsg('/modules/trumper/attributes/strength', 3.3234);
OSCFunc.trace();
OSCFunc.trace(false);
