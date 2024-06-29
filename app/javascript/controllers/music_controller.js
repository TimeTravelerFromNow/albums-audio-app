import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "playButton", "intensityCanvas", "audio", "editB" ]

  audioPlay = () => {}
  ctx = undefined;
  width = 400;
  height = 100;
  sampleCount = 80;
  aIntensity = undefined;
  randomData = undefined;

  connect() {
    console.log("controller is: ", this.identifier);
    console.log("targets are", this.targets);

    this.setupCanvas();
  }

  setupCanvas() {
    if ( !this.hasIntensityCanvasTarget ) { console.log("music_controller.js::intensity canvas not found"); return;}
    const dpr = window.devicePixelRatio || 1;
    this.ctx = this.intensityCanvasTarget.getContext("2d")

    this.ctx.scale(dpr, dpr);

    // draw the line segments
    this.randomData = this.generateNoise(this.sampleCount)
    this.updateCanvas()
  }

  updateCanvas(progress = 1, lW = 1) {
    const canvas = this.intensityCanvasTarget;

    const padding = 20;
    const sC = this.sampleCount;
    const width = canvas.offsetWidth / sC;
    // draw the stars
    var data = this.aIntensity
    if (data == undefined) {
      data = this.randomData
    }
    const midPoint = canvas.offsetHeight / 2;
    for (let i = 1; i < sC * progress; i++) {
      const x = width * i;
      const height = Math.abs(data[i] * midPoint );
      this.drawLineSegment(this.ctx, x, height, midPoint, width, (i + 1) % 2, lW);
    }
  }

  generateNoise(c) {
    let arr = Array(c).fill(0)
    for(let i = 0; i < c; i++ ) {
      arr[i] = Math.random() - 0.5;
    }
    return arr
  }

  drawLineSegment(ctx, x, y, mP, width, isEven, lW) {
    ctx.beginPath();

    ctx.lineWidth = lW; // how thick the line is
    ctx.strokeStyle = "#aeaede"; // what color our line is
    y = isEven ? y : -y;
    ctx.moveTo(x, mP);
    ctx.lineTo(x, mP + y);
    ctx.arc(x + width / 2, mP + y, width / 2, Math.PI, 0, isEven);
    ctx.lineTo(x + width, mP);
    ctx.stroke();
  };

  updateTimeBar() {
    // Get the value of what second the song is at
    let audioTime = this.audioTarget.currentTime;
    // time of song
    let audioLength = this.audioTarget.duration;
    let progress = audioTime / audioLength;
    this.updateCanvas(progress)
  }

  clearCanvas() {
      this.ctx.clearRect(0, 0, this.ctx.canvas.width, this.ctx.canvas.height);
      this.ctx.fillStyle = 'rgba(0,0,0,0)';
      this.ctx.fillRect(0, 0, this.intensityCanvasTarget.width, this.intensityCanvasTarget.height);
  }

  playButtonPressed()
  {
    this.clearCanvas()
    this.updateCanvas(1, 0.4)

    this.audioPlay = setInterval(() => this.updateTimeBar(), 1); // () => method() is NECESSARY

    this.dispatch("playButtonPressed", { detail:
      {
       content: { "audioTarget": this.audioTarget,
                  "playButton": this.playButtonTarget,
                  "intensity": this.aIntensity,
                  "count": this.sampleCount,
                  "play": this.audioPlay,
                  "self": this} } })
  }

  restartPressed() {
    this.clearCanvas()
    if( this.aIntensity != undefined ) {
      this.updateCanvas(1, 0.4)
    }
    console.log("restartPressed")
    this.audioPlay = setInterval(() => this.updateTimeBar(), 1); // () => method() is NECESSARY

    this.dispatch("restartPressed", { detail: {
      content: { "audioTarget": this.audioTarget,
               "playButton": this.playButtonTarget,
               "intensity": this.aIntensity,
               "count": this.sampleCount,
               "play": this.audioPlay,
               "self": this} } })
  }
}
