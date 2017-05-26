
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
~myContext = VTMModule('trumper', definition: Environment.make{
	~attributes = [];
	~commands = [];
	~returns = [];
});
~myContext.fullPath;//should return '/:modules/trumper'
~myContext.isUnmanaged; //should be true
~myContext.description
