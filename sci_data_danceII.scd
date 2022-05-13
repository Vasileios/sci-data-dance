/*
	11 May 2022 17:34

*/

//:Path of the data files
~files = "/Users/vasilis/Documents/Projects/Research/sonification/SonifyingCOVID2/data/*.fasta".pathMatch;
//:
~files[0];
//:
~file = 0;
//:Read from data files the first one
~file1data = CSVFileReader.read(~files[~file])[1..];

//:
//~file1data[0][0].class;

//://run this class first to eval granular sound and Pbindef(\grain)
//:
BASynthGrainAn()
//:

{
	~freqs;
	~freqs = (C: 60.midicps, A: 63.midicps, G: 67.midicps, T: 69.midicps);//freqs that corresponds to genome letters
 	~freqs.postln;
	~file1data[1..] do: { | row |
		row.postln;
		//0.1.wait;
		row[0] do: { | char |
			char.asSymbol.postln;

~oscGlove = OSCdef(\oscTest,
	{
		| ... msg |
		~dur = msg[0][1].asFloat.linlin(-9.0, 9.0, 2.0, 0.01);//data duration, sounds duration
		~freqOsc = msg[0][1].asFloat.linlin(-9.0, 9.0, 1.0, 2.0);//sound1 frequency
		~freqOsc2 = msg[0][1].asFloat.linlin(-9.0, 9.0, 1.0, 2.0);//sound 2 frequency
		~ampOsc2 = msg[0][1].asFloat.linlin(-9.0, 9.0, 0.0, 0.9);//sound 2 amp
		~trigOsc = msg[0][1].asFloat.linlin(-9.0, 9.0, 1.0, 100.0);
		~rateOsc = msg[0][1].asFloat.linlin(-9.0, 9.0, 1, 2);//sound 2 rate
		~ampOsc = msg[0][1].asFloat.linlin(-9.0, 9.0, 0.0, 0.1);//sound 1 amp

		(freq: ~freqOsc*~freqs[char.asSymbol].postln, dur: ~dur, amp:~ampOsc ).play;//default SC sound - freq from data and alter from glove, amp, dur control from glove

		Pbindef(\grain, \rate, ~rateOsc, \trig, 1,\carfreq, ~freqs*~freqOsc2, \amp, ~ampOsc2,  \vol, ~ampOsc, \envbuf, ~rect, \trig, 10, \dur, ~dur, \shape, ~dur).play;//granular sound - glove controls rate, carrfreq, amp, vol, dur and evelope - carrfreq from data - and alter from glove

},
	'/accelX'
);


			~dur.wait;//this is where glove manipulates data dur

		};

	};

}.fork;

//:this is the live coding session for grains
~oscGlove2 = OSCdef(\oscTest2,
	{
		| ... msg |
		~dur = msg[0][1].asFloat.linlin(-9.0, 9.0, 0.01, 2.0);
		~freqOsc2 = msg[0][1].asFloat.linlin(-9.0, 9.0, 1.0, 2.0);
		~ampOsc2 = msg[0][1].asFloat.linlin(-9.0, 9.0, 0.0, 0.7);
		~trigOsc = msg[0][1].asFloat.linlin(-9.0, 9.0, 1.0, 100.0);
		~rateOsc = msg[0][1].asFloat.linlin(-9.0, 9.0, -2, 4);

		Pbindef(\grain,  \trig, ~trigOsc,\shape, ~dur, \dur, ~dur).play;//glove controls trig, envelope and grain duration
},
	'/accelY'
);
