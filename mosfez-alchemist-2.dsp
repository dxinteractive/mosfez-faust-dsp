// mosfez-alchemist.dsp
//
//   B
// A   C
//   D

import("stdfaust.lib");

// utils

lerp(a, b, x) = a + (b - a) * x;

constantPowerPan(p, x) = x*gainLeft, x*gainRight
with {
    theta = ma.PI*p/2.;
    gainLeft = cos(theta)/sqrt(2.);
    gainRight = sin(theta)/sqrt(2.);
};

reject_noise(slack, move_time, x) = return with {
  loop(prev_out, prev_timer, x) = loop_return with {
    trig = abs(prev_out - x) > slack;
    timer = ba.if(trig, 0, prev_timer + 1);
    out = ba.if(trig | timer < ma.SR * move_time, x, prev_out);
    loop_return = out,timer;
  };
  return = x : loop ~ (_,_) : (_,!);
};

// consts

voice_count = 5;
spread_count = 7;

max_delay = ma.SR * 5.0;

del_table = waveform{
  0.,0.,0.,0.,0.,
  0.,0.,0.,0.,0.,
  0.,1.,0.,0.,0.,
  0.,.5,1.,0.,0.,
  0.,.33,.66,1.,0.,
  0.,.25,.5,.75,1.,
  0.,.23,.384,.62,1.
};


vol_table = waveform{
  1.,0.,0.,0.,0.,
  1.,0.,0.,0.,0.,
  1.,1.,0.,0.,0.,
  1.,.9,.8,0.,0.,
  1.,.8,.7,.6,0.,
  1.,.9,.7,.5,.3,
  1.,.8,.7,.5,.3
};

pan_table = waveform{
  .5,.5,.5,.5,.5,
  0.,.5,.5,.5,.5,
  0.,1.,.5,.5,.5,
  .5,0.,1.,.5,.5,
  0.,1.,.8,.2,.5,
  .2,.3,.5,.75,1.,
  0.,1.,.2,.7,.4
};

// input

lag_param = hslider("lag[OWL:A]", 0.5, 0.0, 1.0, 0.001) : reject_noise(0.05, 1.0) : si.smoo;
modspeed_param = hslider("modspeed[OWL:C]", 0.5, 0.0, 1.0, 0.001) : reject_noise(0.05, 1.0) : si.smoo;
moddepth_param = hslider("moddepth[OWL:D]", 0.5, 0.0, 1.0, 0.001) : reject_noise(0.05, 1.0) : si.smoo;
spread_param = hslider("spread[OWL:B]", 0, 0, spread_count, 1) : int; // edited
width_button = checkbox("width[OWL:B1]");

// fx
read_table(table,i) = table,(spread_param  * voice_count) + i : rdtable;

del_value(i) = read_table(del_table, i);
vol_value(i) = read_table(vol_table, i);
pan_value(i) = read_table(pan_table, i);

lp(v) = fi.lowpass(1, lerp(4000., 20000., v * v));
hp(v) = fi.highpass(1, lerp(1000., 20., v * v));

del(i) = de.delay(max_delay, del_value(i) * lag_param * lag_param * max_delay);
vol(i) = *(vol_value(i)) : hp(vol_value(i)) : lp(vol_value(i));
pan(i) = constantPowerPan(pan_value(i));
trem(i) = *(1.5 - (os.osc(modspeed_param * modspeed_param * (20. - i)) * .5 + .5) * moddepth_param);

flip(a,b) = ba.if(width_button, a, b),ba.if(width_button, b, a); // edited
bass_pan = _,ba.if(spread_param == 1, 0, _);

voice(i) = _ : del(i) : vol(i) : trem(i) : pan(i) : flip : _,_;
gtr = _ <: par(i, voice_count, voice(i)) :> _,_;
bass =  _ <: bass_pan : _,_;

amp = *(3.0);
process = gtr,bass :> amp,amp;