import("stdfaust.lib");

// gate = button("btn1[OWL:B1]") : float;

gate = hslider("scale[OWL:AA]",0.0,0.0,1.0,0.001); // cc75
g = *(gate * 0.25);
process = os.osc(220.0),os.osc(221.0) : g,g : _,_;