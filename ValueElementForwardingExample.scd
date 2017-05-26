
a = VTMAttribute.new(\hei, (type: \integer));
a.addForwarding('home', NetAddr.localAddr, '/testing/iheg', true)
a.addForwarding('toMax', NetAddr.localAddr, '/toMax/iheg', false)
OSCFunc.trace
a.value_(10.rand);
a.removeAllForwardings;
a.disable;
a.enable;
a.free
