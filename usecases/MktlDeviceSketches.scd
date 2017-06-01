MKtlDesc.addFolder ( "".resolveRelative +/+ ".." );
//on scvim ...
//LPD8 test
(
MKtlDesc.addFolder ("~/blacksound/VTMSketches/".standardizePath);
~lpd8 = VTMMKtlDevice('pip', (
	mktlName: "myLPD8",
	mktlDescription: "akai-lpd8-vtm"
), definition: ());
)

VTMMKtlDevice.parameterDescriptions
~lpd8.prepare;
~lpd8.description
~lpd8.attributes
~lpd8.returns
~lpd8.commands
~lpd8.signals
~lpd8.doCommand(\makeGui)

1.asStringPrec(3)
//Tascam US2400 test
(
MKtlDesc.addFolder ("~/blacksound/VTMSketches/".standardizePath);
~us2400 = VTMMKtlDevice('tasc', (
	mktlName: "myUS2400",
	mktlDescription: "tascam-us-2400",
	mktlIndex: 0
));
)
~us2400.prepare;
~us2400.description
~us2400.attributes
~us2400.returns
~us2400.commands
~us2400.signals
~us2400.doCommand(\makeGui)
