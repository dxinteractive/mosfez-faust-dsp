
import("stdfaust.lib");

// consts
tablesize = 300000;
maxbars = 4; // could be adaptive, allow more bars if barlength is smaller?
barlength = 50000; // hslider("loop length",50000,0,tablesize,1) : int;

// utils
displayimpulse = _ <: attach(_, ba.countdown(10000));
decreased(x) = x < x';

// inputs
barstorec_input = hslider("bars to record",1,1,maxbars,1) : int;
startrec_input = button("record") : int;
metronome_input = hslider("metronome level",1.0,0.0,1.0,0.01);
startrec_pulse = startrec_input : ba.impulsify;
barstorec_state = barstorec_input : ba.latch(startrec_pulse); 

// clock
barstart_pulse = ba.pulse(barlength);
progress = barstart_pulse
  : ba.countup(tablesize)
  : hbargraph("progress", 0, barlength);

get_sample(bar) = (bar * barlength) + progress;

// metronome
metronome_gain = progress / barlength
  : *(-4.0)
  : +(1.0)
  : min(1.0)
  : max(0.0);

metronome_audio = no.pink_noise * 0.25 * metronome_gain * metronome_input;

// play
play_current_bar = barstart_pulse
    : ba.pulse_countup_loop(barstorec_state - 1, startrec_pulse : ==(0))
    : hbargraph("current play bar", 0, maxbars); 

play_current_sample = get_sample(play_current_bar)
    : hbargraph("current play sample", 0, tablesize);

play_current_sample_tail_active = play_current_sample + (barstorec_state * barlength)
    : select2(play_current_bar == 0, -1, _)
    : hbargraph("current play tail sample", -1, tablesize);

// rec
rec_current_bar = barstart_pulse
    : ba.pulse_countup_loop(barstorec_state, startrec_pulse : ==(0))
    : hbargraph("current rec bar", 0, maxbars); 

rec_current_sample = get_sample(rec_current_bar);

rec_active_state = ba.on_and_off(startrec_pulse, rec_current_sample : decreased);

rec_current_sample_active = rec_current_sample
    : select2(rec_active_state, -1, _)
    : hbargraph("current rec sample", -1, tablesize);

// tables
table(size,write_pos,write_value,read_pos,read_active) = rwtable(size + 2,0.0,write_pos + 1,write_value,read_pos + 1)
    : select2(read_pos == -1, _, 0);

looptable = table(tablesize,rec_current_sample_active,_);

// combine
looper = _
    <: looptable(play_current_sample),looptable(play_current_sample_tail_active)
    :> _,metronome_audio
    :> _;

process = looper,looper;
