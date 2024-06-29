import { Controller } from "@hotwired/stimulus"


// constants
   const COLOR_SPACE = "black";
   const COLOR_STARS = "white";
   const STAR_NUM = 200; // number of stars in the starfield
   const STAR_SIZE = 0.005; // max star size as a fraction of screen width
   const STAR_SPEED = 0.05; // fraction of screen width per second
   function randomSign() {
            return Math.random() >= 0.5 ? 1 : -1;
   }
   var stars = [];
   var starXV = 0.0;

var canvas = undefined;
var ctx = undefined;
// create the background gradient once
var bgGrad = undefined; // initialized in connect()

// top level code
document.addEventListener('mousemove', (event) => {});
onmousemove = (event) => {
  starXV = event.movementX;
};

    function loop() {
        if (canvas && ctx){
        // // space background
        ctx.fillStyle = bgGrad;
       ctx.fillRect(0, 0, canvas.width, canvas.height);
        // draw the stars
        ctx.fillStyle = COLOR_STARS;
        for (let i = 0; i < STAR_NUM; i++) {
          ctx.beginPath();
          ctx.arc( stars[i].x, stars[i].y, stars[i].r, 0, Math.PI * 2);
          ctx.fill();

         stars[i].x += starXV  * 0.01 * stars[i].r;
          // reposition the star to the other side if it goes off screen
          if ( stars[i].x < 0 - stars[i].r) {
             stars[i].x = canvas.width + stars[i].r;
          } else if ( stars[i].x > canvas.width + stars[i].r) {
             stars[i].x = 0 - stars[i].r;
          }

         stars[i].y += .1;//starYV * timeDelta * 0.01 * stars[i].r;
          // reposition the star to the other side if it goes off screen
          if ( stars[i].y < 0 - stars[i].r) {
             stars[i].y = canvas.height + stars[i].r;
          } else if ( stars[i].y > canvas.height + stars[i].r) {
             stars[i].y = 0 - stars[i].r;
          }
          }
         // call the next frame
         //console.log( stars[0].x , stars[0].y  );
       }
         requestAnimationFrame(() => loop());
      }

loop();

export default class extends Controller {
  static targets = ["backgroundCanvas"];

  connect() {

    var fpt = document.getElementsByClassName("Fpagetext")
    if(fpt[0])
    {
      fpt[0].style.color = "#F0F8FF"
    }



    // set up the canvas and context
     canvas = this.backgroundCanvasTarget;
     ctx = canvas.getContext("2d");

     canvas.height = document.documentElement.scrollHeight;
    canvas.width = document.documentElement.scrollWidth;

     bgGrad = ctx.createLinearGradient(0,0,0,canvas.height);
     bgGrad.addColorStop(0,"#000000");
     bgGrad.addColorStop(1,"#000000");


     // Initialize resize observer object
         let resizeObserver = new ResizeObserver(() => {

           // Setting the current height & width
          // to the elements
          canvas.height = document.documentElement.scrollHeight;
          canvas.width = document.documentElement.scrollWidth;
          this.starsSetup(); // resized the document, reposition ALL stars to random initial
         });
         resizeObserver.observe(document.body);
     // set up the stars

      this.starsSetup(); // setup is called when controller connects
  }

  starsSetup() {

         this.starSpeed = STAR_SPEED * canvas.width;
         var xv = this.starSpeed * randomSign() * Math.random();
         // Using Pythagoras' theorem, yv = sqrt(starSpeed^2 - xv^2)
         var yv = Math.sqrt(Math.pow(this.starSpeed, 2) - Math.pow(xv, 2)) * randomSign();
         this.starSpeed = STAR_SPEED * canvas.width;

         // randomize star properties
         for (let i = 0; i < STAR_NUM; i++) {
            let speedMult = Math.random() * 1.5 + 0.5;
            stars[i] = {
                r: Math.random() * STAR_SIZE * canvas.width / 2,
                x: Math.floor(Math.random() * canvas.width),
                y: Math.floor(Math.random() * canvas.height),
                xv: xv * speedMult,
                yv: yv * speedMult
            }
          }
  }
}
