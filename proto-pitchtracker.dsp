// read: https://pdfslide.net/documents/faust-tutorial2.html
// refer: zcr in faustlibraries

import("stdfaust.lib");

SH(trig,x) = (*(1 - trig) + x * trig) ~ _;
a = hslider("n cycles", 10, 1, 100, 1);
p = hslider("pitch", 440, 40, 1000, 1);

Pitch(a,x) = a * ma.SR / max(M,1) - a * ma.SR * (M == 0)
with {
    U = (x' < 0) & (x >= 0);
    V = +(U) ~ _ %(int(a));
    W = U & (V == a);
    N = (+(1) : *(1 - W))~ _;
    M = SH(N == 0, N' + 1);
};
tracker = fi.dcblockerat(80.0) : (fi.lowpass(1) : Pitch(a)) ~ max(100);
settle = 90;
sounder(freq) = os.triangle(freq) * 0.1 * ba.if(ba.countup(settle + 1, freq != freq') > settle, 1, 0); // 
fx = tracker; // : sounder;
process = _ <: _ * 10000,fx,fx;
