(
    ~definition = Environment.make({

    });
    ~module = VTMModule('test');
)

~module.fullPath
~module.dump

VTMUnitTest.runTestForClass(VTMData);
VTMUnitTest.runTestForClass(VTMElement);


VTMUnitTest.runTest("TestVTMElement:test_DerivedPath");

VTMValue.makeFromProperties(())
(
    VTMValue.makeFromProperties(
        VTMOrderedIdentityDictionary[
            \type -> ( 'optional': true, 'defaultValue': \none, 'type': \string )
        ]
    )
)
VTMUnitTest.runTest("TestVTMData:test_initName")
VTMUnitTest.runTest("TestVTMData:test_addToManager")
VTMUnitTest.runTest("TestVTMElement:test_DerivedPath")
VTMUnitTest.runTest("TestVTMElement:test_AttributeOSC")


