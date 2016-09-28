var assign_key;

$(document).ready(function(){
	assign_key = $("#assign-key").clone();
});

function create_list_and_table(id){
	$('<div id="' + id + '-searchbar-list" style="display:none;"></div>').insertAfter($("#assign-" + id));
	$('<div id="' + id + '-table" style="display:none;"></div>').insertAfter($("#" + id + "-searchbar-list"));
}

function create_form(id){
	$('<div id="' + id + '-form" style="display:none;"></div>').insertAfter($("#assign-"+id));
}

function getHighlightedRow(category){
	var table_open = '<table class="table" id="' + category + '-header-table">';
	var table_head = '<thead>' + $('.all-tables thead').html() + '</thead>';
	var table_body = '<tbody><tr>' + $('.bg-primary').html() + '</tr></tbody>';
	var table_close = '</table>';

	return table_open + table_head + table_body + table_close;
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
