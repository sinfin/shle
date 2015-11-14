#= require jquery
#= require moment
#= require bootstrap-sprockets
#= require jquery.cookie
#= require handlebars
#= require ember
#= require ember-data
#= require barbecue
#
#= require_self
#= require_tree ./adapters
#= require_tree ./mixins
#= require_tree ./serializers
#= require_tree ./adapters
#= require_tree ./models
#= require ./controllers/object_controller
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./components
#= require_tree ./templates
#= require ./routes/base_route
#= require_tree ./routes
#= require ./router

$ ->
  # HACK - all template names will lose its /admin prefix
  Barbecue.removeTemplatePrefix /^admin\//

Barbecue.CONTENT_LOCALES = ['cs','en']

window.Admin = Ember.Application.create(
#  LOG_TRANSITIONS: true,
#  LOG_TRANSITIONS_INTERNAL: true
  LOG_VIEW_LOOKUPS: true
#  LOG_ACTIVE_GENERATION: true
#  LOG_RESOLVER: true
)

# quite slow, enable when desperate
# Ember.run.backburner.DEBUG = true;

# turn on promise failure debugging
Ember.RSVP.on 'error', (error) ->
  Ember.Logger.assert(false, error);
