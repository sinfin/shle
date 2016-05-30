$ ->
  wrap = $('#new_lead').parent()
  wrap.on 'submit', 'form', (e) ->
    e.preventDefault()
    $this = $(this)
    $.post $this.attr('action'), $this.serialize(), (data) -> wrap.html data
