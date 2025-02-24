// mosfez-alchemist.dsp
//
//   B
// A   C
//   D

import("stdfaust.lib");
gtr = _ <: _,_;
bass = _ <: _,_;
amp = *(3.0);
process = gtr,bass :> amp,amp;