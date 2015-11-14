Admin.Router.map () ->

  @resource 'tags', ->
    @resource 'tag', {path: ':tag_id'}
    @route 'new'

  # @resource 'places', ->
  #   @resource 'place', {path: ':place_id'}, ->
  #     @route 'media'
  #     @route 'text'
  #   @route 'new'
