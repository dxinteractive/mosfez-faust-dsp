let faust = require('./harpy.node');

console.log('hi');

var dspFaustNode = new faust.DspFaustNode(44100,512);
dspFaustNode.start();

setTimeout(() => {
    console.log('stop');

    dspFaustNode.stop();
}, 10000);