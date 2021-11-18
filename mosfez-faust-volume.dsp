// mosfez-faust-volume.dsp
// A volume pedal test with Faust. Wizard: 3% CPU
// - Knob A controls volume from 0% to 100%.

import("stdfaust.lib");
volume = hslider("volume[OWL:A]",1.0,0.0,1.0,0.001);
fx = _ * volume * 3.0;
process = fx,fx;
