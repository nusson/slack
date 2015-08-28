# ###*
#  *  Map view (or component)
#  *
#  *  @author WE_ARE
# ###
# define [
#   'cs!app/modules/gmaps',
#   'bower/markerclusterer_compiled/index',  # @toto : optional (see marketLabel in init())
#   'ractive'
# ], (GMAP)->
#   'use strict'

#   EARTH_RADIUS = 6371
#   DEG_TO_RAD   = (Math.PI / 180)

#   Map = Ractive.extend

#     template: '<div id="map"></div>'
#     events:
#       ready:    'ready'
#       created:  'created'
#       marker:   'marker-click'
#       over:     'marker-over'
#       out:      'marker-out'
#     data:
#       previous: null  # previous datas to not uncecerry update
#       # Map options (from google map - new google.maps.Map(dom, options) )
#       options:
#         mapTypeId:          google.maps.MapTypeId.ROADMAP
#         scrollwheel:        false
#         # disableDefaultUI:   true
#         zoom:               12
#         center:             null
#         resize:             false #if true, center on resize
#       # Default position to mont-royal @ montreal
#       position:
#         lat:                45.505084
#         lng:                -73.598785
#       # Auto geolocalisation ?
#       geolocation:          true
#       # center this marker on resize
#       # will be automatic, center on :
#       #   - a specified marker (if you specifie something like map.set('target', myMarker))
#       #   - the actif marker (if you open one)
#       #   - the result marker (if you search for an address)
#       #   - your position
#       target: null
#       # Some usefull features
#       features:
#         geocoder: true
#         ###*
#          * marker with label params
#          * To ignore this plugin, set this to false
#         ###
#         markerWithLabel:  false
#         # markerWithLabel:
#         #   labelClass:         'label' # the CSS class for the label
#         #   draggable:          false
#         #   raiseOnDrag:        false
#         #   clickable:          false
#         #   #icon:       {url: flag}
#         #   #labelAnchor: new google.maps.Point(22, 0)
#         #   #labelStyle: {opacity: 0.75}

#         ###*
#          * marker clusterer (group nearest markers)
#          * To ignore clusterer, set this to false
#         ###
#         markerClusterer:  false
#         # markerClusterer:
#         #   gridSize:   100
#         #   styles:     [{
#         #     url:        '/images/ui/pointer-many.png'
#         #     width:      50
#         #     height:     50
#         #     anchor:     [0, 0]
#         #     textSize:   16
#         #     textColor:  'white'
#         #   }]
#       geocoder:             null  # will be created if feature.geocoder = true
#       icons:
#         me:             '/images/ui/pointer-me.png'
#         result:         '/images/ui/pointer-result.png'
#         reserved:       '/images/ui/pointer-reserved.png'
#         available:      '/images/ui/pointer-available-off.png'
#         availableOn:    '/images/ui/pointer-available-on.png'
#         unavailable:    '/images/ui/pointer-unavailable-off.png'
#         unavailableOn:  '/images/ui/pointer-unavailable-on.png'


#     #===========/-------------------------------------------
#     #  [_PUB]  /  Public Methods
#     #=========/---------------------------------------------

#     oninit: ()->
#       @setAutoGeolocation() if @get('geolocation')
#       if @get('features.geocoder') and google?.maps?.Geocoder?
#         @set('geocoder', new google.maps.Geocoder())
#       null

#     onrender: ->
#       @dom  =
#         view: $(@el)
#         map: $('#map')
#       @handlers = {}

#       if not @get('features.markerWithLabel')
#         @create()
#       else
#         require ['bower/markerwithlabel_packed/index'], (MarkerWithLabel)=>
#           @create()

#       @addListeners()
#       null

#     ###*
#      * like jquery
#      * @param  {function} cb - callback on ready (executed now if ready then when ready)
#     ###
#     onready:(cb=->)->
#       return cb() if @get('ready')
#       @on @events.ready, cb
#       null

#     addListeners: ->
#       @observe 'position', (n,o)=>
#         @resetMap.bind(@)(n,o)
#       null

#     ###*
#      *  ResetMap
#     ###
#     resetMap:(n,o) ->
#       @center(n.lat, n.lng)
#       # @get('me')?.setMap(null)
#       @get('result')?.setMap(null)
#       # result will be hidden by default because just bellow 'me'
#       @set 'result', @addMarker n.lat, n.lng,
#         icon:     @get('icons.result')
#         cluster:  false
#         zIndex:   0
#       # @set 'me', @addMarker n.lat, n.lng,
#       #   icon:     @get('icons.me')
#       #   cluster:  false # don't use cluster nore pushed into markers
#       #   zIndex:   0

#       target  = @get('target')
#       if not target?.map
#         @set 'target', @get('result')



#     ###*
#      *  Create the map
#     ###
#     create: ->
#       new google.maps.LatLng(@get('position.lat'), @get('position.lng'))
#       @set 'map', new google.maps.Map(@dom.map.get(0), @get('options'))
#       @set 'markers', []

#       if @get('features.markerClusterer')
#         @set 'cluster', new MarkerClusterer(@get('map'), @get('markers'), @get('features.markerClusterer'))

#       @fire( @events.created )
#       google.maps.event.addListenerOnce(@get('map'), 'idle', onLoadedHandler.bind(this))


#     ###*
#      *  Add a marker
#      *  @todo : make this generic, actually work only within MarkerWithLabel
#     ###
#     addMarker: (lat, lng, markerOpts={})->
#       return if not @get('map') or _.isNaN(parseFloat(lat)) or _.isNaN(parseFloat(lng))# or not label?

#       latLng  = new google.maps.LatLng(lat, lng)
#       marker  = null
#       opts    = _.extend({
#         map:      @get('map')
#         position: latLng
#       }, markerOpts)

#       # Marker with label (plugin) or standard
#       if @get('features.markerWithLabel')
#         opts  = _.extend({}, @get('features.markerWithLabel'), opts)
#         marker = new MarkerWithLabel(opts)
#       # Generic marker
#       else
#         marker = new google.maps.Marker(opts)

#       if not (markerOpts.cluster is false)
#         @get('markers').push(marker)
#         @get('cluster')?.addMarker(marker, true)

#       marker

#     ###*
#      * Dellete all markers exept our position
#     ###
#     removeMarkers: ()->
#       return if _.isEmpty(@get('markers'))

#       # remove markers listeners
#       _.each @handlers.marker, (handlers)->
#         _.each handlers, (h)-> google.maps.event.removeListener(h)
#       @handlers.marker = []

#       @get('cluster')?.clearMarkers()
#       _.each @get('markers'), (marker, index)=> marker.setMap(null)
#       @set 'markers', []

#     ###*
#      * update all markers (usefull for filters)
#      * @param {array} datas - collection of markers
#      * @return create markers within datas infos
#      *
#      * @todo : improve by removing juste thoses that have to
#      * and add only the rest
#     ###
#     update:(datas)->
#       if datas.length is 0
#         @removeMarkers()
#         @set('previous',null)
#         return
#       return if not datas? or not _.has(datas, 'models')

#       ids = datas.pluck('_id')
#       return if JSON.stringify(ids) is JSON.stringify(@get('previous'))

#       @set 'previous', ids
#       @removeMarkers()
#       @handlers.marker = []
#       _this = @

#       markers = []
#       # console.log datas
#       datas.each? (p)=>
#         parking = p.toJSON()
#         coords  = parking.geometry?.coordinates
#         if not coords?
#         else
#           icon  = if parking.avaible then @get('icons.available') else @get('icons.unavailable')
#           marker = @addMarker coords[1], coords[0],
#             icon: icon
#             id:   parking._id
#           @handlers.marker.push
#             click: google.maps.event.addListener marker, 'click', (event)->
#               _this.set 'target', marker
#               _this.fire(_this.events.marker, @)
#             over: google.maps.event.addListener marker, 'mouseover', (event)->
#               return if @actif
#               # @setIcon @icon.replace('-off', '-on')
#               _this.fire(_this.events.over, @)
#             out: google.maps.event.addListener marker, 'mouseout', (event)->
#               return if @actif
#               # @setIcon @icon.replace('-on', '-off')
#               _this.fire(_this.events.out, @)
#           markers.push marker
#       @set 'markers', markers


#     ###*
#      *  center map
#      *  @param {number} lat
#      *  @param {number} lng
#     ###
#     center: (lat, lng)->
#       map   = @get('map')
#       return if not map

#       lat = lat or @get('position.lat')
#       lng = lng or @get('position.lng')
#       map.panTo(new google.maps.LatLng(lat, lng))


#     ###*
#      *  center map with offset
#      *  @param {google.LatLng} latlng
#      *  @param {number} offsetX=0
#      *  @param {number} offsetY=0
#     ###
#     centerWithOffset: (latlng, offsetX=0, offsetY=0)->
#       map   = @get('map')
#       return if not map

#       center  = if latlng instanceof google.maps.LatLng then latlng
#       else map.getCenter()
#       offsetCenter  = _.map { x: offsetX, y: offsetY }, (o) ->
#         (o / Math.pow(2, map.getZoom()) ) or 0

#       point1 = map.getProjection().fromLatLngToPoint(center)
#       point2 = new google.maps.Point(offsetCenter[0], offsetCenter[1])
#       map.setCenter map.getProjection().fromPointToLatLng new google.maps.Point(
#         point1.x - point2.x,
#         point1.y + point2.y
#       )

#     ###*
#      *  Update layout (for exemple, when resize window)
#     ###
#     updateLayout: ->
#       map   = @get('map')
#       return if not map

#       target  = @get('target')
#       if target?.map
#         p = target.getPosition()
#         @center p.lat(), p.lng()


#     ###*
#      *  Set client geolocation and center map here
#     ###
#     setAutoGeolocation: ->
#       if jsvars?.geoloc?.latitude?
#         @set 'position',
#           lat:  jsvars.geoloc.latitude
#           lng:  jsvars.geoloc.longitude
#       else if navigator.geolocation
#         navigator.geolocation.getCurrentPosition(
#           (datas)=> # Success
#             @set 'position',
#               lat:  datas.coords.latitude
#               lng:  datas.coords.longitude
#           ()=>  # Error
#             if google.loader.ClientLocation
#               @set 'position',
#                 lat:  google.loader.ClientLocation.latitude
#                 lng:  google.loader.ClientLocation.longitude
#         )
#       else if(google.loader.ClientLocation)
#         @set 'position',
#           lat:  google.loader.ClientLocation.latitude
#           lng:  google.loader.ClientLocation.longitude

#     ###*
#     *  Custom custom map style
#     *  @param {string} name - Name of the style
#     *  @param {string} id - id of the style (slug, lower case etc)
#     *  @param {object} style - style properties (https://developers.google.com/maps/documentation/javascript/styling)
#     ###
#     setStyle: (name, id, style)->
#       return if not (name? and typeof(id) is 'string' and typeof(style) is 'object')

#       map = @get('map')
#       styleMapType    = new google.maps.StyledMapType(style, {name: name})
#       map.mapTypes.set(id, styleMapType)
#       map.setMapTypeId(id)
#       null

#     ###*
#      * get coordonates from address
#      * @depend feature.geocoder = true
#      * @param  {string} addr
#      * @param  {function} callback
#      * @return {object} {lat}
#     ###
#     getCoordsFromAddress: (address, cb=->)->
#       return if not @get('geocoder')
#       @get('geocoder').geocode {'address': address}, (results, status)=>
#         if (status is google.maps.GeocoderStatus.OK)
#           coords  = results[0].geometry.location
#           cb(coords)
#         else

#     ###*
#      * @return {number} radius - visible radius of your map from center (in meters)
#     ###
#     getBoundsRadius: () ->
#       map   = @get('map')
#       return if not map

#       bounds      = map.getBounds()
#       center      = bounds.getCenter()
#       ne          = bounds.getNorthEast()

#       # Convert lat or lng from decimal degrees into radians (divide by 57.2958)
#       lat1 = center.lat() * DEG_TO_RAD
#       lon1 = center.lng() * DEG_TO_RAD
#       lat2 = ne.lat() * DEG_TO_RAD
#       lon2 = ne.lng() * DEG_TO_RAD

#       # distance = circle radius from center to Northeast corner of bounds
#       c = Math.acos(Math.sin(lat1) * Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
#       c * EARTH_RADIUS

#     ###*
#      *  Get distance between 2 points
#      *  @param {object || google.maps.LatLng} a - {lat:-45, lng:73} or marker.getPosition()
#      *  @param {object || google.maps.LatLng} b - 2nd point...
#      *  @return {number} distance km
#      *  @exemple getDistanceBetweenPoints({lat:40, lng:10}, {lat:-40, lng:25})
#     ###
#     getDistanceBetweenPoints : (a, b)->
#       lat1 = a.lat() or a.lat
#       lat2 = b.lat() or b.lat
#       lon1 = a.lng() or a.lng
#       lon2 = b.lng() or a.lng
#       dLat = (lat2-lat1) * DEG_TO_RAD
#       dLon = (lon2-lon1) * DEG_TO_RAD
#       lat1 = (lat1) * DEG_TO_RAD
#       lat2 = (lat2) * DEG_TO_RAD

#       diff = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2)
#       c = 2 * Math.atan2(Math.sqrt(diff), Math.sqrt(1-diff))
#       c * EARTH_RADIUS

#   #===========/-------------------------------------------
#   #  [_PRI]  /  Private Methods
#   #=========/---------------------------------------------
#   ###*
#    *  When map is ready
#    *  @param {event} event
#   ###
#   onLoadedHandler = (event)->

#     @set 'ready', true
#     @fire(@events.ready)

#     if @get('options.resize')
#       google.maps.event.addDomListener window, 'resize', (event)=>
#         @updateLayout()

#     setTimeout =>
#       @updateLayout()
#       google.maps.event.trigger(@get('map'), 'resize')
#     , 1000
#     null

#   return Map




