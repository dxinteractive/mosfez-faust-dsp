import("stdfaust.lib");

// midi
midigate = button("gate");
midifreq = nentry("freq[unit:Hz]", 440, 20, 20000, 1);

// oscillators
partial1 = os.osc(midifreq * 1.0)  * 1.0 * en.adsre(0.01,0.1,0.7,6.0,midigate);
partial2 = os.osc(midifreq * 6.0)  * 0.1 * en.adsre(0.01,0.1,0.7,3.0,midigate);
partial3 = os.osc(midifreq * 17.0) * 0.02 * en.adsre(0.01,0.1,0.7,2.0,midigate);
partial4 = os.osc(midifreq * 34.0) * 0.02 * en.ar(0.001,0.0002,midigate);

fx = partial1,partial2,partial3,partial4 :> fi.dcblocker : _ * 0.3;
process = fx <: _,_;
