import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  submit(event) {
    const query = this.inputTarget.value
    const messageId = new Date().getTime()

    const html = `<div class="chat-message" id="message_${messageId}">
      <p><strong>You:</strong> ${query}</p>
    </div>`

    document.getElementById("chat-messages").insertAdjacentHTML("beforeend", html)
  }
}
