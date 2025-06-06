import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["info"]

  initialize() {
    console.log("🛠️ Initializing controller...");
    document.addEventListener("turbo:load", () => this.connect());
  }

  connect() {
    console.log("🔌 Controller connected to:", this.element);
    console.log("🔍 Found info targets:", this.infoTargets.length);

    this.infoTargets.forEach(card => {
      card.style.display = 'none';
      card.classList.add('hidden');
      console.log(`📦 Initialized card for game ${card.dataset.gameId}`);
    });
  }

  showInfo(event) {
    console.log("🖱️ Button clicked:", event.currentTarget);
    event.preventDefault();
    const gameId = event.currentTarget.dataset.gameId;
    this.hideAllInfo();

    const infoCard = this.infoTargets.find(info => info.dataset.gameId === gameId);
    if (infoCard) {
      console.log("🔼 Showing card for game:", gameId);
      infoCard.style.display = 'block';
      infoCard.classList.remove('hidden');
    }
  }

  hideInfo(event) {
    console.log("🔽 Hiding card");
    event.preventDefault();
    const infoCard = event.currentTarget.closest(".description-card");
    if (infoCard) {
      infoCard.style.display = 'none';
      infoCard.classList.add('hidden');
    }
  }

  hideAllInfo() {
    console.log("🗑️ Hiding all cards");
    this.infoTargets.forEach(info => {
      info.style.display = 'none';
      info.classList.add('hidden');
    });
  }
}
