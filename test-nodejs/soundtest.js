let faust = require('./soundtest.node');

var dspFaustNode = new faust.DspFaustNode(44100,512);
dspFaustNode.start();

setTimeout(() => {
    console.log('stop');

    dspFaustNode.stop();
}, 100000);