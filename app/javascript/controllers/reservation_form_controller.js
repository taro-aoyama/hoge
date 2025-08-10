import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["facility", "startTime", "endTime", "totalFee"]

  connect() {
    // facilityRatesはビューで定義されたグローバル変数
    if (typeof facilityRates === 'undefined') {
      console.error('facilityRates is not defined. Make sure it is available in the view.');
      this.facilityRates = {};
    } else {
      this.facilityRates = facilityRates;
    }
  }

  calculateFee() {
    const facilityId = this.facilityTarget.value;
    const startTime = this.startTimeTarget.value;
    const endTime = this.endTimeTarget.value;

    if (!facilityId || !startTime || !endTime) {
      this.totalFeeTarget.textContent = '¥0';
      return;
    }

    const hourlyRate = this.facilityRates[facilityId];
    if (hourlyRate === undefined) {
      console.error(`Hourly rate for facility ID ${facilityId} not found.`);
      this.totalFeeTarget.textContent = '料金計算不可';
      return;
    }

    const start = new Date(startTime);
    const end = new Date(endTime);

    if (end <= start) {
      this.totalFeeTarget.textContent = '終了時間は開始時間より後である必要があります';
      return;
    }

    const durationHours = Math.ceil((end - start) / (1000 * 60 * 60));
    const totalFee = durationHours * hourlyRate;

    if (isNaN(totalFee)) {
      this.totalFeeTarget.textContent = '料金を計算できません';
    } else {
      this.totalFeeTarget.textContent = `¥${totalFee.toLocaleString()}`;
    }
  }
}
