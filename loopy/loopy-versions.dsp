
import("stdfaust.lib");

looplengthmax = 100000;
looplength = hslider("loop length",50000,0,looplengthmax,1) : int;

playhead = ba.sweep(looplength,1);
metrogain = playhead / looplength : *(-4.0) : +(1.0) : min(1.0) : max(0.0);
p = no.pink_noise * 0.5 * metrogain;

process = p,p;

/////



import("stdfaust.lib");

looplengthmax = 100000;
looplength = 50000; // hslider("loop length",50000,0,looplengthmax,1) : int;
recording = button("[1]Record") : int;

playhead = ba.sweep(looplength,1) : hbargraph("Playhead", 0, looplengthmax);


// metrogain = playhead / looplength : *(-4.0) : +(1.0) : min(1.0) : max(0.0);
// metro = no.pink_noise * 0.5 * metrogain;

looptable = rwtable(200000,0.0,(playhead + 1) * recording, _, playhead + 1);
p = looptable;

process = p,p;

////


import("stdfaust.lib");

// consts
tablesize = 300000;
maxbars = 4; // counld be adaptive, allow more bard if barlength is smaller
barlength = 50000; // hslider("loop length",50000,0,tablesize,1) : int;

// log
// <: attach(_, ba.countdown(10000) : hbargraph("playstart", 0, 10000));

// inputs
barstorec_input = hslider("bars to record",1,1,maxbars,1) : int;
startrec_input = button("record") : int : ba.impulsify;

// clock
barstart = ba.pulse(barlength);
progress = barstart : ba.countup(tablesize) : hbargraph("progress", 0, barlength);

// metro
metrogain = progress / barlength : *(-4.0) : +(1.0) : min(1.0) : max(0.0);
metro = no.pink_noise * 0.25 * metrogain;

// 
barstorec = barstorec_input : ba.latch(startrec_input) : hbargraph("barstorec", 0, maxbars); 
barprogress = barstart : ba.pulse_countup_loop(barstorec - 1, startrec_input : ==(0)) : hbargraph("barprogress", 0, maxbars); 
playstart = barprogress : ==(0) : ba.impulsify <: attach(_, ba.countdown(10000) : hbargraph("playstart", 0, 10000));
// ^ this resets mid bar right now if you record!
playprogress = playstart : ba.countup(tablesize) : hbargraph("playprogress", 0, tablesize);

// table
looptable = rwtable(200000,0.0,(playprogress + 1) * 0, _, playprogress + 1);

// combination
p = looptable,metro :> _;
process = p,p;


// 


import("stdfaust.lib");

// consts
tablesize = 300000;
maxbars = 4; // counld be adaptive, allow more bard if barlength is smaller
barlength = 50000; // hslider("loop length",50000,0,tablesize,1) : int;

// log
// <: attach(_, ba.countdown(10000) : hbargraph("playstart", 0, 10000));

// inputs
barstorec_input = hslider("bars to record",1,1,maxbars,1) : int;
startrec_input = button("record") : int : ba.impulsify;

// clock
barstart = ba.pulse(barlength);
progress = barstart : ba.countup(tablesize) : hbargraph("progress", 0, barlength);

// metro
metrogain = progress / barlength : *(-4.0) : +(1.0) : min(1.0) : max(0.0);
metro = no.pink_noise * 0.25 * metrogain;

// play / rec heads
barstorec = barstorec_input : ba.latch(startrec_input) : hbargraph("barstorec", 0, maxbars); 
barprogress = barstart : ba.pulse_countup_loop(barstorec, startrec_input : ==(0)) : hbargraph("barprogress", 0, maxbars); 
playprogress = (barprogress * barlength) + progress : hbargraph("playprogress", 0, tablesize);

// table
table = rwtable(200000,0.0,(playprogress + 1) * 0);
looptable = table(_, playprogress + 1);
// ^ todo add a second table reader that plays the outro bar in parallel

// combination
p = looptable,metro :> _;
process = p,p;


////
//// 


import("stdfaust.lib");

// consts
tablesize = 300000;
maxbars = 4; // counld be adaptive, allow more bard if barlength is smaller
barlength = 50000; // hslider("loop length",50000,0,tablesize,1) : int;
crossfade = 10000;

// log
// <: attach(_, ba.countdown(10000) : hbargraph("playstart", 0, 10000));

// utils
decreasing(x) = x < x';

// inputs
barstorec_input = hslider("bars to record",1,1,maxbars,1) : int;
startrec_input = button("record") : int : ba.impulsify;

// clock
barstart = ba.pulse(barlength);
progress = barstart : ba.countup(tablesize) : hbargraph("progress", 0, barlength);

// metro
metrogain = progress / barlength : *(-4.0) : +(1.0) : min(1.0) : max(0.0);
metro = no.pink_noise * 0.25 * metrogain;

// play / rec heads
barstorec = barstorec_input : ba.latch(startrec_input) : hbargraph("barstorec", 0, maxbars); 
barprogress = barstart : ba.pulse_countup_loop(barstorec - 1, startrec_input : ==(0)) : hbargraph("barprogress", 0, maxbars); 
playprogress = (barprogress * barlength) + progress : hbargraph("playprogress", 0, tablesize);
playrestart = playprogress : decreasing;
recording = ba.on_and_off(startrec_input, playrestart) : hbargraph("recording", 0, 1);
//recgain = 1; //ba.countup(crossfade,startrec_input : ==(0)) : hbargraph("recgain", 0, crossfade) : /(crossfade);

// table - select2(recording, playprogress + 1, 0)
rechead = select2(recording, 0, playprogress + 1) : hbargraph("rechead", 0, tablesize);
looptable = rwtable(tablesize + 2,0.0,rechead,_, playprogress + 1);
// ^ todo add a second table reader that plays the outro bar in parallel

// combination
p = looptable,metro :> _;
process = p,p;


