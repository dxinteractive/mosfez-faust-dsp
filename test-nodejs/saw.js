let faust = require('./saw.node');
var easymidi = require('easymidi');

let devicename = easymidi.getInputs()[0];
console.log('devicename: ', devicename);
if(!devicename) {
  throw new Error('NO MIDI!');
}
var input = new easymidi.Input(devicename);
var i = 0;

input.on('noteon', (msg) => {
  dspFaustNode.setParamValue("freq",msg.velocity * 4 + 100);
  dspFaustNode.setParamValue("gate",1);
  i++;
  var ii = i;
  
  console.log(msg);

  setTimeout(() => {
    if(ii == i) {
      console.log('off');
      dspFaustNode.setParamValue("gate",0);
    }
  }, 10);
});
// input.on('noteoff', (msg) => {
//   dspFaustNode.setParamValue("gate",0);
//   console.log(msg);
// });
// input.on('cc', (msg) => {
//   dspFaustNode.setParamValue("freq",msg.value * 4 + 100);
//   console.log(msg);
// });

var dspFaustNode = new faust.DspFaustNode(44100,64);
dspFaustNode.start();

for(i=0; i < dspFaustNode.getParamsCount(); i++){
  console.log("ID: " + i + " Address: " + dspFaustNode.getParamAddress(i));
}

let freq = 0;

let wee = () => {
    freq -= 10;
    if(freq > 0) {
        dspFaustNode.setParamValue("freq",freq);
    }
    setTimeout(wee, 500);
};

wee();

setTimeout(() => {
    console.log('stop');

    dspFaustNode.stop();
}, 100000);