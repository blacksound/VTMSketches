~myTubaSensor.queries[\ribbonSensor];
~myTubaSound.attributes[\freq];

(
~myTubaMapping = VTMMapping('tubaSineMap',
	(
		source: ~myTubaSensor.queries[\ribbonSensor], // /tubasensor/ribbonSensor
		destination: ~myTubaSound.attributes[\freq]// /tubasound/freq
		destinationHost: "192.168.10.2:57120",
		inMinVal: 100,
	   	outMaxVal: 2300,
		warp | curve | function: 
	)
)
)

//more consise
~myTubaSensor.queries[\ribbonSensor].map( ~myTubaSound.attributes[\freq], 'tubaSineMap'); //return a VTMMapping
