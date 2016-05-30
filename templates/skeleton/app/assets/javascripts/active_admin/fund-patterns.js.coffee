variantSelect = ->
  select = $('#fund_code')
  return if select.length isnt 1
  preview = select.parents('li').find('.fund-pattern-preview')

  handleChange = ->
    preview.removeAttr('class').addClass("fund-pattern-preview r-fund-style-#{select.val()}")

  select.on 'change', handleChange
  handleChange()

$ variantSelect
