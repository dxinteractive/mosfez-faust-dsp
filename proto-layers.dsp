import("stdfaust.lib");

changed(x) = x != x';

layerIsAwake(l,x,t) = return with {
    layerChange = l : changed;
    startPos = x : ba.sAndH(layerChange);
    nudged = abs(x - startPos) > t;
    return = layerChange,nudged : ba.on_and_off : _ == 0;
};

layerValue(l,i,x) = return with {
    return = x : ba.sAndH((l == i) & layerIsAwake(l,knob,0.1));
};

layer = hslider("layer", 0.0, 0.0, 2.0, 1.0);
knob = hslider("knob", 0.0, 0.0, 1.0, 0.001);

// e.g.
process = (layerValue(layer,0,knob): hbargraph("value 0", 0.0, 1.0)), (layerValue(layer,1,knob) : hbargraph("value 1", 0.0, 1.0));
