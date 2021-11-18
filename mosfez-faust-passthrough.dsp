// mosfez-faust-passthrough.dsp
// A ~unity gain stereo passthrough test with Faust. Wizard: 3% CPU

import("stdfaust.lib");
fx = _ * 3.0;
process = fx,fx;
