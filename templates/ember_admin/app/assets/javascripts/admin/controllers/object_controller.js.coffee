Admin.ObjectController = Ember.ObjectController.extend
  needs: ['contentLocale']
  contentLocale: Ember.computed.alias('controllers.contentLocale.current')
