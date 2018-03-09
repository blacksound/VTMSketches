VTM.activate(true); VTM.makeView.front;
VTM.discover;

VTM.nodes


NetAddr.localEndPoint
NetAddr("192.168.1.101", 57120).sendMsg('/ahehe', 33);

NetAddr("192.168.1.100", 57120).sendMsg('/ahehe', 33);

OSCFunc.trace;


VTM.local.dump
VTM.local.localNetworks[0].dump
VTM.local.localNetworks[1].dump
VTM.local.localNetworks[0].isIPPartOfSubnet("1.2.3.123");
VTM.local.localNetworks[0].isIPPartOfSubnet("192.168.1.13");
VTM.local.localNetworks[0].netmask.asInteger



VTM.local.localNetworks[0].dump
VTM.local.localNetworks[1].dump

VTM.local.networkNodeManager.dump;
VTM.local.networkNodeManager.items[0].description.keys

VTM.local.networkNodeManager.freeItem("imac1");

VTM.local.networkNodeManager.free;

VTM.makeView.front;






(
~other = NetAddr("1.2.3.255").addr;
// ~other = NetAddr("192.168.1.100").addr;
~me = NetAddr("1.2.3.123").addr;
~mask = NetAddr("255.255.255.0").addr.bitNot.bitOr(~me);


~result = ~mask.bitOr(~other).postln;
~result.asBinaryString(32).postln;,
~result.asHexString(8).postln;
"TEST: %".format(~result == ~mask).postln;

"";
)

Main.shut

