let faust = require('./soundtest.node');

var dspFaustNode = new faust.DspFaustNode(44100,512);
dspFaustNode.start();



let on = false;
let toggle = () => {
    on = !on;
    dspFaustNode.setParamValue("freq", Math.random() * 440 + 440);
    dspFaustNode.setParamValue("gate", on ? 1 : 0);
    setTimeout(() => {
        toggle();
    }, 120);
};

toggle();

setTimeout(() => {
    console.log('stop');

    dspFaustNode.stop();
}, 100000);