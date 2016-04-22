import moment from "moment"

$("#monitor-index-page").ready(() => {
  setInterval(() => {
    $('.state-updated-at').each((_, elem) => {
      $(elem).text(moment($(elem).data('time')).fromNow())
    })
  }, 1000)
  //TODO: $('input#enabled-switch').on ... push
})

const onTestPortUpdate = payload => {
  if($("#monitor-index-page").length == 0) {
    return
  }
  let row = $('tr#' + payload.identity)
  let eventState = row.find('.event-state')
  let eventStateUpdatedAt = row.find('.state-updated-at')
  let lastOkTime = row.find('.last-ok-time')
  if(payload.body == 'success') {
    eventState.html('<span class="label label-success">ACTIVE</span>')
    eventState.removeClass('text-danger')
    eventState.addClass('text-success')
    row.removeClass('danger')
  } else {
    eventState.html('<span class="label label-danger">INACTIVE</span><span class="label label-danger">' + payload.reason + "</span>")
    eventState.removeClass('text-success')
    eventState.addClass('text-danger')
    row.addClass('danger')
    $("#alert-audio")[0].play()
  }
  eventStateUpdatedAt.data('time', payload.timestamp)
  eventStateUpdatedAt.text(moment(payload.timestamp).fromNow())
  lastOkTime.text(moment(payload.last_ok_time).format("YY-MM-DD HH:mm:ss"))
}
export const callbacks = {onTestPortUpdate: onTestPortUpdate}
