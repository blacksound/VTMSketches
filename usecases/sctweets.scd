//how to deal with 'dirty' code
(
~myTweets= VTMModule(
	name: 'some tweets',
	declaration: (),
	definition: Environment.make{
		~run= {
			~snd.release;  //stop previous ~snd  if any
			//pick a random tweet and play it
			//note: must locally declare a-z and save play{} synth in ~snd

			[
				{
					var b, c, d;
					~snd= play{RecordBuf.ar(BPF.ar(Saw.ar((d=LFSaw.ar(1/9))>0+1/3*99)+c=GrainBuf.ar(2,d,24,b=LocalBuf(3e4).clear,-2),99,4).mean,b);c}// #SuperCollider
				},
				{
					var a, b;
					~snd= play{a=Formant;Splay.ar(a.ar(a.ar(b=(1..12)/8,b/3.5+80,999-b/9)+3*50,a.ar(b/3,2.5,5)>0+1*300,a.ar(b/5,2,3)>0*1200)/3).tanh}// #SuperCollider
				},
				{
					var a;
					~snd= play{a=Pulse;Splay.ar({|i|i=2**i;Formant.ar(*{|j|j+5.5**a.ar(j+0.75/i).lag(0.12)+a.ar(1.3/i,1/3)*99}!3)*a.ar(4/i)}!8).tanh}// #SuperCollider
				},
				{
					var a, b;
					~snd= play{a=LFSaw;Splay.ar(Formant.ar(*[2**round(a.ar(b=1/(1..12)),a.ar(8,b)<0/4+1),4**a.ar(b/12)+2,3**a.ar(b/4)*3]*99)/2).tanh}// #SuperCollider
				},
				{
					var a, c;
					~snd= play{a=SinOscFB;AllpassN ar:a.ar(midicps(Duty.ar(c=a.ar(1/[12,8])+3/24,0,Dseq([0,8,5,1,5,4,5]*round(c*18),inf))+60),c*2)/2}// #SuperCollider
				},
				{
					var a, e;
					~snd= play{a=LFTri;e=a.ar(2**a.ar(1/5)).round(a.ar(1/8)/3);GVerb.ar(HPF.ar(SinOsc.ar(e**[99,150],BPF.ar(e%1,500))/6,9),99,5,0.1)}// #SuperCollider
				}
			].choose.value;

		};
		~free= {
			~snd.release;
		};
		~attributes= [];
	}
)
)

/*
~myTweets.envir[\run].value
~myTweets.envir[\free].value
*/
