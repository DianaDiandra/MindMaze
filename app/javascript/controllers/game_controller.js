import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="game"
export default class extends Controller {
  connect() {
    console.log("Connected")
  }

  getScore() {
    console.log("Got score")
  }
}
