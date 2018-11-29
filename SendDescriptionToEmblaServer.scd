TestVTMElement.run

TestVTMData.run
TestVTMControl.run

TestVTMOrderedIdentityDictionary.run

TestVTMContext.run

VTMModule.controlDescriptions
VTM.debugLevel_(4)
m = VTMModule('lenny')
m.fullPath;
m.manager.fullPath

(
m = VTMModule('lenny', definition: Environment.make({
	~controls = [
		\aaa -> [
			\mode -> \attribute,
			\type -> \integer,
			\value -> 22,
			\action -> {|...args| "Iam args: %".format(args).postln;}
		]
	]
}));
)
m.set(\aaa, 10.0.rand)
m.get(\aaa)

VTM.local.controls.path
m.dump
m.parameters
m.fullPath
m.controls.fullPath
.items;
m.controls.parent
m.definition.controls.keys;
m.definitionControls.keys;

m.description[\controls].keys
m.manager.items.collect(_.fullPath);
m.controls[\aaa].value


a = VTMControl.makeFromDescription(\aaa, (mode: \attribute, type: \integer, action: {|...args|"BAKAK: %".format(args).postln;}));
a.action
a.valueAction_(3)


(
a = VTMOrderedIdentityDictionary.newFromAssociationArray([
	\aaa -> [
		\mode -> \attribute,
		\type -> \integer
	],
	\bbb -> 22,
	\ccc -> [
		\gunner -> 333,
		\bingo -> \bjarne
	],
	\kjukken -> \hange,
	\fff -> [
		\haope -> [ \je, \aja, \rrr ],
		\tinig -> 3,
		\guing -> [
			\sokke -> [
				\giigie -> [ 1111,2222,3333]
			]
		]
	]
], true);
)

a.keys
a[\aaa]
a[\fff][\tinig]
a[\fff][\guing][\sokke][\giigie]

JSON.stringify(a)

a = VTMOrderedIdentityDictionary.newFrom([aaa: 2])
a = VTMOrderedIdentityDictionary.newFromAssociationArray([\aaa -> 2])


[aaa: 2].isAssociationArray
[\aaa -> 2, 2].isTrulyAssociationArray
[\aaa -> 2, \bbb -> 2].isTrulyAssociationArray
(
[
	\aaa -> [
		\class -> \attribute,
		\type -> \integer
	],
	\bbb -> 22,
	\ccc -> [
		\gunner -> 333,
		\bingo -> \bjarne
	],
	\kjukken -> \hange,
	\fff -> [
		\haope -> [ \je, \aja, \rrr ],
		\tinig -> 3,
		\guing -> [
			\sokke -> [
				\giigie -> [ 1111,2222,3333]
			]
		]
	]
].isAssociationArray
)