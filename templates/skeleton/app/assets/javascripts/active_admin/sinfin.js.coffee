variantSelect = ->
  selects = $('.variant-select')
  return if selects.length < 1
  selects.parent('li').addClass('variant-select-li')

  handleChange = ($el) ->
    isNotDefault = $el.val() isnt 'default'
    $el.parents('.has_many_fields').toggleClass('variant-not-default', isNotDefault)

  selects.on 'change', -> handleChange($(this))
  selects.each -> handleChange($(this))

$ variantSelect
