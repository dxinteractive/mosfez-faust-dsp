let faust = require('./saw.node');
let readline = require('readline');

console.log('hi');

var dspFaustNode = new faust.DspFaustNode(44100,512);
dspFaustNode.start();

for(i=0; i < dspFaustNode.getParamsCount(); i++){
  console.log("ID: " + i + " Address: " + dspFaustNode.getParamAddress(i));
}

let freq = 0;

readline.emitKeypressEvents(process.stdin);
process.stdin.setRawMode(true);
process.stdin.on('keypress', (str, key) => {
  if (key.ctrl && key.name === 'c') {
    process.exit();
  } else {
    console.log(`You pressed the "${str}" key`);
    freq = 100;
    dspFaustNode.setParamValue("gate",1);
    dspFaustNode.setParamValue("freq",freq);

    setTimeout(() => {
        dspFaustNode.setParamValue("gate",0);
    }, 250);
  }
});

let wee = () => {
    freq -= 10;
    if(freq > 0) {
        dspFaustNode.setParamValue("freq",freq);
    }
    setTimeout(wee, 100);
};

wee();

setTimeout(() => {
    console.log('stop');

    dspFaustNode.stop();
}, 100000);