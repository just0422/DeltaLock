var assign_key;

var assign_params = {
    "purchasers" : "",
    "purchaseorders": "",
    "endusers" : "",
    "keys" : ""
}

$(document).on("turbolinks:load", () => {
	$(".assign-title").click(function(){
		$(this).toggle()
        var id = $(this).attr('id').split('-')[0];
		$("#" + id + "-assign-new-or-search").toggle();
	})
});

function check_assign_ready(){
    var count = 0;
    
    for (param in assign_params)
        if (assign_params[param] != "")
            count++;

    if (count > 1){
        $("#assign-button").show();
    }
}

function create_assignment(){
    $.ajax({
        url: "/assign/assignment",
        method: 'post',
        data: assign_params,
        success: function(response){
            console.log("Did it!");
        }
    });
}

function create_list_and_table(id){
	$('<div id="' + id + '-searchbar-list" style="display:none;"></div>').insertAfter($("#assign-" + id));
	$('<div id="' + id + '-table" style="display:none;"></div>').insertAfter($("#" + id + "-searchbar-list"));
}

function create_form(id){
	$('<div id="' + id + '-form" style="display:none;"></div>').insertAfter($("#assign-"+id));
}

function getHighlightedRow(category){
	var id = parseInt($(".bg-primary ." + category + "-id").html());
	var selected = '<h3 data-toggle="collapse" data-target="#' + category + '-info">' + category + '</h3>';
//	var id = ;
//	var group_id = ;
	$.ajax({
		type: "GET",
		url: category + "/show_" + category  + "/" + id,
		async: false
	}).success(function(response){
		selected += '<div id="' + category + '-info" class="collapse">' + response  + '</div>';
	});

	return selected;
//	var table_open = '<table class="table" id="' + category + '-header-table">';
//	var table_head = '<thead>' + $('.all-tables thead').html() + '</thead>';
//	var table_body = '<tbody><tr>' + $('.bg-primary').html() + '</tr></tbody>';
//	var table_close = '</table>';

//	return table_open + table_head + table_body + table_close;
}

function getNewRow(){
	return '<tr>' + $('.bg-primary').html() + '</tr>'; 
}

function selectPurchaser(){
	var selected_row = getHighlightedRow("purchaser");
	$("#purchaser-table").fadeOut(FADE_TIME, function(){
		$("#header-information").append(selected_row);
		$("#assign-enduser").fadeIn(FADE_TIME);
		destroy("purchaser");
	});
}

function selectEndUser(){
	var selected_row = getHighlightedRow("enduser");
	$("#enduser-table").fadeOut(FADE_TIME, function(){
		$("#header-information").append(selected_row);
		$("#assign-key").fadeIn(FADE_TIME);
		destroy("enduser");
	});
}

function selectKey(){
	$("#key-map").fadeOut(FADE_TIME);
	$("#key-table").fadeOut(FADE_TIME, function(){
		if ($("#header-information").find("#key-header-table").length > 0)
			$("#key-header-table").append(getNewRow());
		else
			$("#header-information").append(getHighlightedRow("key"));
		$("#assign-purchaseorder").fadeIn(FADE_TIME);
		destroy("key");
	});
}

function reset_keys(){
	$("#assign-purchaseorder").fadeOut(FADE_TIME, function(){
		assign_key.insertAfter("#assign-purchaseorder");
		$("#assign-key").fadeIn(FADE_TIME);
	});
}

function destroy(elements){
	$("#" + elements + "-table").remove();
	$("#" + elements + "-form").remove();
	$("#" + elements + "-searchbar-list").remove();
	$("#assign-" + elements).remove();
}

function generate_new_purchase_order(){
	var labels = $("form li label");
	var inputs = $("form li input");

	var table_open = '<table class="table" id="purchaseorder-header-table">';
	
	var table_head = '<thead><tr>';
	for (var i = 0; i < labels.length; i++)
		table_head += '<th><strong>' + $(labels[i]).text().toLowerCase().replace(" ", "_") + '</strong></th>';
	table_head += '</tr></thead>';
	
	var table_body = '<tbody><tr>';
	for (var i = 0; i < inputs.length; i++)
		table_body += '<td>' + $(inputs[i]).val() + '</td>';
	table_body += '</tr></tbody>';

	var table_close = '</table>';

	$("#purchaseorder-form").fadeOut(FADE_TIME, function(){
		$("#header-information").append(table_open + table_head + table_body + table_close);
		$("#are-you-sure").fadeIn(FADE_TIME);
	});
}

function fade_confirmation(fade_in, fade_out){

	$("#" + fade_out + "are-you-sure").fadeOut(FADE_TIME, function(){
	});
		$("#" + fade_in + "are-you-sure").fadeIn(FADE_TIME);
}


function table_to_hash(id){
	var headings = [];
	var elements = [];
	var hash = {};

	$("#" + id + " tr").each(function(){
		$("th", this).each(function(){
			headings.push($(this).text());
		});
		$("td", this).each(function(){
			elements.push($(this).text());
		});
	});

	for(var x = 0; x < headings.length; x++)
		hash[headings[x]] = elements[x];
	console.log(hash);
	console.log(JSON.stringify(hash));
	
	var full_list = [];
	full_list[0] = headings.length;
	full_list = full_list.concat(headings).concat(elements);

	$("#" + id + "-information").val(JSON.stringify(hash));
}

//With JQuery
var red_slider, yellow_slider;
var MILE = 1609.34;
function initialize_map(){
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
}

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
		$("#yellow-slider-value").val(maxValMiles);
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
