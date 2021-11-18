import("stdfaust.lib");

// midi
midigate = button("gate");
midifreq = nentry("freq[unit:Hz]", 440, 20, 20000, 1);
midigain = nentry("gain", 1, 0, 1, 0.01);

// enva
volA = hslider("A[midi:ctrl 73]",0.01,0.01,4,0.01);
volD = hslider("D[midi:ctrl 76]",2.6,0.01,8,0.01);
volS = hslider("S[midi:ctrl 77]",0.2,0,1,0.01);
volR = hslider("R[midi:ctrl 72]",2.0,0.01,8,0.01);

// osc
pmGain = hslider("pm gain",0.0,0.0,1000.0,1.0) : si.smoo;
pmMulti = hslider("pm multi",4.0,1.0,24.0,1.0) : si.smoo;
pmDenom = hslider("pm denom",4.0,1.0,24.0,1.0) : si.smoo;

envelop = en.adsre(volA,volD,volS,volR,midigate);
vol = envelop;

osc(f) = os.osc(f + (pmGain * envelop * os.osc(f * pmMulti / pmDenom))) : fi.dcblocker;

fx = osc(midifreq) * vol * 0.3;

process = fx <: _,_;
