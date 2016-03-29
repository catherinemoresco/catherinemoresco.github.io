#!/bin/sh
if [ $1 = "clean" ]; then 
	rm FFT.js
	rm GraphDemo.js
	rm SquareWave.js
	rm FourierSeries.js
	rm ImpulseDemo.js
	rm SquareFreq.js
else
	elm-make FFTDemo.elm --output=FFT.js
	elm-make GraphDemo.elm --output=GraphDemo.js
	elm-make SquareWave.elm --output=SquareWave.js
	elm-make FourierSeries.elm --output=FourierSeries.js
	elm-make ImpulseDemo.elm --output=ImpulseDemo.js
	elm-make SquareFreq.elm --output=SquareFreq.js
fi
