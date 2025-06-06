import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="game"
export default class extends Controller {
  static targets = ["score", "lastScore", "percentage"]
  // static values = {
  //   score: Number
  // }

  connect() {
    // window.addEventListener("load", () => {
    //   const iframe = document.getElementById("game-frame");

    //   iframe.onload = () => {
    //     const frameDocument = iframe.window.document;
    //     console.log(frameDocument)
    //     const button = frameDocument.getElementById("restart-button");

    //     if (button) {
    //       button.click();
    //     } else {
    //       console.log("no button found")
    //     }

    //   }
    // });

    console.log("Connected")
    // console.log(this.scoreTarget)
    // console.log(this.lastScoreTarget)
    const TARGET = this.scoreTarget;
    const LASTTARGET = this.lastScoreTarget
    const PERCENTAGE = this.percentageTarget
    window.addEventListener("message", (event) => {
    console.log("Message received:", event);

    if (event.data.type === "bestScore") {
      // console.log(`Best score ${event.data.value}`)

      // THIS IS THE RIGHT ACTION WE WANT BUT BCZ WE HAVE THE LAST SCORE AND NOT THE FINAL SCORE WE WANT TO HARDCODE IT
      // this.scoreValue = event.data.value
      // HARDCODED FOR NOW
      this.scoreValue = 10000;
      // console.log(TARGET)
      TARGET.value = event.data.value;
      // console.log(TARGET.value)
    }

    if (event.data.type === "lastScore") {
      this.lastScoreValue = event.data.value;
      LASTTARGET.value = event.data.value;
      // console.log(LASTTARGET.value);
    }

    if (this.scoreValue && this.scoreValue > 0) {
      const accuracy = (this.lastScoreValue / this.scoreValue) * 100;
      PERCENTAGE.value = accuracy.toFixed(2);
    }

    });

  }
}

// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["score", "lastScore", "finalScore", "percentage"]

//   connect() {
//     console.log("🎮 Game controller connected")

//     this.bestScoreValue = 0
//     this.lastScoreValue = 0

//     window.addEventListener("message", (event) => {
//       const { type, value } = event.data
//       const parsedValue = parseInt(value)

//       if (type === "bestScore" && this.hasScoreTarget) {
//         this.bestScoreValue = parsedValue
//         this.scoreTarget.value = parsedValue
//         this.scoreTarget.dispatchEvent(new Event("input", { bubbles: true }))
//         console.log("✅ Best score set:", parsedValue)
//       }

//       if (type === "score" && this.hasLastScoreTarget) {
//         this.lastScoreValue = parsedValue
//         this.lastScoreTarget.value = parsedValue
//         this.lastScoreTarget.dispatchEvent(new Event("input", { bubbles: true }))
//         console.log("✅ Current score (last_score) set:", parsedValue)
//       }

//       if (this.hasFinalScoreTarget && this.bestScoreValue && this.lastScoreValue) {
//         const final = Math.round((this.bestScoreValue + this.lastScoreValue) / 2)
//         this.finalScoreTarget.value = final
//         this.finalScoreTarget.dispatchEvent(new Event("input", { bubbles: true }))
//         console.log("🎯 Final score set:", final)
//       }

//       if (this.hasPercentageTarget && this.bestScoreValue && this.lastScoreValue) {
//         const accuracy = (this.lastScoreValue / this.bestScoreValue) * 100
//         this.percentageTarget.value = accuracy.toFixed(2)
//         this.percentageTarget.dispatchEvent(new Event("input", { bubbles: true }))
//         console.log("📊 Accuracy set to:", accuracy.toFixed(2))
//       }
//     })
//   }
// }
