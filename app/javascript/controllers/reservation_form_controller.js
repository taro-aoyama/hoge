import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startTime", "endTime", "totalFee"]
  static values = { hourlyRate: Number }

  calculate() {
    const startTime = this.getDateTime(this.startTimeTarget.children)
    const endTime = this.getDateTime(this.endTimeTarget.children)

    if (startTime && endTime && endTime > startTime) {
      const durationHours = Math.ceil((endTime - startTime) / (1000 * 60 * 60));
      const totalFee = durationHours * this.hourlyRateValue;
      this.totalFeeTarget.textContent = `合計料金: ${totalFee}円`;
    } else {
      this.totalFeeTarget.textContent = "合計料金: 0円";
    }
  }

  getDateTime(children) {
    const year = parseInt(children[0].value)
    const month = parseInt(children[1].value) - 1
    const day = parseInt(children[2].value)
    const hour = parseInt(children[3].value)
    const minute = parseInt(children[4].value)
    return new Date(year, month, day, hour, minute)
  }
}
