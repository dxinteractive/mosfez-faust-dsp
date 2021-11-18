// mosfez-faust-gate.dsp
// A gate pedal test with Faust. Wizard: 6% CPU
// - Knob A controls threshold from -90dB - -45dB - 0dB.
// - Knob B controls attack time from 0.01ms - 1ms - 100ms.
// - Knob C controls hold time from 0.01ms - 1ms - 100ms.
// - Knob D controls release time from 0.1s - 1s - 10s.

import("stdfaust.lib");
threshold = hslider("depth[OWL:A]",-60.0,-90.0,0.0,0.001);
attack = 10 ^ hslider("attack[OWL:B]",-4.0,-5.0,-1.0,0.001);
hold = 10 ^ hslider("hold[OWL:C]",-4.0,-5.0,-1.0,0.001);
release = 10 ^ hslider("release[OWL:D]",0.0,-1.0,1.0,0.001);
boost = _ * 3.0;
process = ef.gate_stereo(threshold, attack, hold, release) : boost,boost;
