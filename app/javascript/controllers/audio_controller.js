import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static audioPlay = () => {}

  static aCtx = undefined;
  static audioT = undefined;
  static playBT = undefined;

  audioTargetConnected(element) {
    //console.log(element, "connected")
  }

  connect() {
    window.audioContext = window.AudioCtx || window.webkitAudioContext;
    this.aCtx = new AudioContext()
  }

  disconnect() {
    if (this.aCtx) {
      this.aCtx.close()
    }
  }

  restartPressed({ detail: {content} } ){
    console.log("audio restartPressed")
    this.playPressed({ detail: {content} })
    this.audioT.currentTime = 0;

    if (this.audioT.paused){
      this.playBT.classList.remove("fa-play")
      this.playBT.classList.add("fa-pause")
    }
    this.audioT.play()
  }

  playPressed({ detail: { content } }){
    var pausedBefore = false

    var audioT = content["audioTarget"]
    var playButton = content["playButton"]
    var intensity = content["intensity"]
    var sampleCount = content["count"]
    var playCallback = content["play"]
    var music = content["self"]

    const needsAudioData = intensity == undefined;

    if( this.audioT != undefined) {
      pausedBefore = ( this.audioT.paused )

      // pause audio
      this.audioT.pause()
      clearInterval(this.audioPlay);

      this.playBT.classList.remove("fa-pause")
      this.playBT.classList.add("fa-play")
    }

    // is this the same song?
    var samePiece = (this.audioT == audioT)

    // new audio
    this.audioT = audioT
    this.playBT = playButton
    this.audioPlay = playCallback

    // generate intensity map for first time
    if( intensity == undefined )
    {
      const audioContext = this.aCtx
      let audioBuffer = null
      // wish the tutorial could do this a different way !!!

      const process = audioBuffer => {
        const rawData = audioBuffer.getChannelData(0); // We only need to work with one channel of data
         const blockSize = Math.floor(rawData.length / sampleCount); // Number of samples in each subdivision
         const filteredData = Array(sampleCount).fill(0);
         for (let i = 0; i < sampleCount; i++) {
           filteredData[i] = rawData[i * blockSize];
         }
         const multiplier = Math.pow(Math.max(...filteredData), -1);
         music.aIntensity = filteredData.map(n => n * multiplier)
      }

      // dont know an alternative syntax to this based on the tutorial
      fetch(audioT.src)
        .then(response => response.arrayBuffer())
        .then(arrayBuffer => audioContext.decodeAudioData(arrayBuffer))
        .then(audioBuffer => process(audioBuffer));

    }

    if (!( !pausedBefore && samePiece )) {
      this.audioT.play()
      this.playBT.classList.remove("fa-play")
      this.playBT.classList.add("fa-pause")
    }

    if( this.audioT.currentTime >= content.duration - 1)
    {
      this.audioT.currentTime = 0; // rewind if at end
    }
    console.log("audio_controller.js pressed and connected actions")
    console.log(content)

    if( needsAudioData )
    {
      music.updateCanvas();
    }
  }
}
