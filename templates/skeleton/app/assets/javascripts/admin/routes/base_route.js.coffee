Admin.BaseRoute = Ember.Route.extend Barbecue.AjaxMixin, Barbecue.FlashMixin, Barbecue.CrudMixin,
  actions:
    error: (error,transition) ->
      if error and error.status == 401
        window.location = '/users/sign_in?msg=You+have+signed+out+in+another+window'
      true

  activate: ->
    @_super()
    window.scrollTo(0,0)
