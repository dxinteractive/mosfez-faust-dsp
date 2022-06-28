import("stdfaust.lib");

q = hslider("q", 100.0, 0.1, 1000.0, 0.1);
gain = hslider("gain", 0.1, 0.0, 1.0, 0.1);

notelane(hz) = fi.resonhp(hz,q,gain) : an.amp_follower(0.1) : hbargraph("%hz", 0.0, 1.0);
each(hz) = notelane(hz);

process = _ <: par(i, 12, each(ba.midikey2hz(i + 69))) : maxvalue : _ <: _,_;
