// mosfez-faust-tremolo.dsp
// A tremolo pedal test with Faust. Wizard: 6% CPU
// - Knob A controls speed from 0.125Hz - 2Hz - 32Hz.
// - Knob B controls depth from 0% to 100%.

import("stdfaust.lib");
speed = 2 ^ hslider("speed[OWL:A]",2.4,-3.0,5.0,0.001);
depth = hslider("depth[OWL:B]",0.5,0.0,1.0,0.001);
gain = os.osc(speed) * depth + 1.0;
fx = _ * gain * 3.0;
process = fx,fx;
