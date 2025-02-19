import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  submit(event) {
    const query = this.inputTarget.value
    const messageId = new Date().getTime()

    const html = `<div class="chat-message self-start max-w-[90%] bg-emerald-500 px-4 py-2 rounded-md text-white mb-6" id="message_${messageId}">
      <p>${query}</p>
    </div>`

    document.getElementById("chat-messages").insertAdjacentHTML("beforeend", html)
  }
}
