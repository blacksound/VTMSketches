//trying to count upward in turn on two separate computers
(
~pingpong= VTMModule(
	name: 'pingpong',
	declaration: (),
	definition: Environment.make{
		~prepare= {
			//find receiver on network - how?
		};
		~free= {

		};
		~attributes= [
			\count -> (
				\type: \integer,
				minVal: 0, maxVal: nil,
				defaultValue: 0, clipmode: \none,
				action: {arg attr, context;
					var val= attr.value;
					val= val+rrand(1, 10);
					1.wait;
					//here reply back to sender - how?
				}
			)
		];
		~queries= [
			\currentCount -> (
				type: \integer,
				minVal: 0, maxVal: nil,
				defaultValue: 0, clipmode: \none
			)

		];
	}
)
)
