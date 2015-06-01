Admin.BaseRoute = Ember.Route.extend Barbecue.AjaxMixin, Barbecue.FlashMixin, Barbecue.CrudMixin, 
  activate: ->
    @_super()
    window.scrollTo(0,0)
