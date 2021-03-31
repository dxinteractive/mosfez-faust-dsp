
import("stdfaust.lib");

// consts
tablesize = 300000;
maxbars = 4; // counld be adaptive, allow more bard if barlength is smaller
barlength = 50000; // hslider("loop length",50000,0,tablesize,1) : int;

// utils
displayimpulse = _ <: attach(_, ba.countdown(10000));
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
rechead = select2(recording, 0, playprogress + 1) : hbargraph("rechead", 0, tablesize);

// better table (handles dumping non-recorded values, will handle fadeins and outs)
table(n,w,v,r) = rwtable(n + 2,0.0,w,v,r + 1);

looptable = table(tablesize,rechead,_,playprogress);
// ^ todo add a second table reader that plays the outro bar in parallel

// combination
p = looptable,metro :> _;
process = p,p;

