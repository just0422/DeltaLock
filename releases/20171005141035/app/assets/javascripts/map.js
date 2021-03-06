// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

//With JQuery
var red_slider, yellow_slider;
var MILE = 1609.34;
$(document).ready(function(){
	red_slider =  $("#red-slider").slider();
	yellow_slider =  $("#yellow-slider").slider();

	$('#yellow-slider').slider({
		formatter: function(value) {
			return 'Current value: ' + value;
		}
	});
	$("#yellow-slider").on('slide', function(slider){
		yellow_circle.setRadius(parseInt(slider.value) * MILE);
		$("#yellow-slider-value").val(slider.value);

		red_slider.slider("setAttribute", "max", slider.value);

		if (red_slider.val() >= slider.value)
		{
			red_slider.slider('setValue', slider.value);//yellow_slider.value);
			red_circle.setRadius(slider.value * MILE);
			$('#red-slider-value').val(slider.value);
		}
		else{
			red_slider.slider('setValue', parseInt($('#red-slider').val()));
			$('#red-slider-value').val(parseInt($('#red-slider').val()));
		}
		
		resetMarkerColors();
	});
	$('#red-slider').slider({
		formatter: function(value) {
			return 'Current value: ' + value
		}
	});
	$('#red-slider').on('slide', function(slider){
		red_circle.setRadius(parseInt(slider.value) * MILE);
		$('#red-slider-value').val(slider.value);

		resetMarkerColors();
	});
});

function setRedSliderValue(value){
	var sliderVal = parseInt(value);
	
	if (sliderVal > red_slider.slider("getAttribute", "max")){
		red_slider.slider('setValue', red_slider.slider("getAttribute", "max"));
		red_circle.setRadius(red_slider.slider("getAttribute", "max") * MILE);
	}
	else{
		red_circle.setRadius(parseInt(sliderVal) * MILE);
		red_slider.slider('setValue', sliderVal);
	}
	resetMarkerColors();
}
function setYellowSliderValue(value){
	var sliderVal = parseInt(value);

	if (sliderVal > yellow_slider.slider("getAttribute", "max")){
		yellow_slider.slider('setValue', yellow_slider.slider("getAttribute", "max"));
		yellow_circle.setRadius(yellow_slider.slider("getAttribute", "max") * MILE);
	}
	else{
		yellow_circle.setRadius(sliderVal * MILE);
		yellow_slider.slider('setValue', sliderVal);
	}
	resetMarkerColors();
}
function setYellowMax(value){
	var maxValMeters = Math.floor(parseInt(value) * MILE);
	var maxValMiles = parseInt(value);
	var currentYellowValue = parseInt(yellow_slider.val());
	var currentRedValue = parseInt(yellow_slider.val());

	yellow_slider.slider('setAttribute', 'max', maxValMiles);

	if (currentYellowValue >= maxValMiles){
		yellow_slider.slider('setValue', maxValMiles);
		yellow_circle.setRadius(maxValMeters);
		$("#yellow-slider-value").val(maxValMles);
	}
	else
		yellow_slider.slider('setValue', currentYellowValue);

	if (currentRedValue >= maxValMiles){
		red_circle.setRadius(maxValMeters);
		$('#red-slider-value').val(maxValMiles);
		red_slider.slider("setAttribute", "max", maxValMiles);
		red_slider.slider('setValue', maxValMiles);
	}
}

function resetMarkerColors(){
	for (var i = 0; i < red_markers.length; i++)
		checkMarker(red_markers[i]);
	for (var i = 0; i < yellow_markers.length; i++)
		checkMarker(yellow_markers[i]);
	for (var i = 0; i < green_markers.length; i++)
		checkMarker(green_markers[i]);
}
function checkMarker(marker){
		if (checkCircle(marker, red_circle))
			marker.setIcon(red_icon);
		else if (checkCircle(marker, yellow_circle))
			marker.setIcon(yellow_icon);
		else
			marker.setIcon(green_icon);
}
function checkCircle(marker, circle){
	return google.maps.geometry.spherical.computeDistanceBetween(circle.getCenter(), marker.position) <= circle.getRadius();
}
