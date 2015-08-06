ready = ->
	$(".plan").on "click", ->
		document.location = $(this).data("target")
		return false

$(document).ready(ready)
$(document).on "page:load", ready


