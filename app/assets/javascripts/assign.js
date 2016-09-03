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
	var table_open = '<table class="table" id="' + category + '-header-table">';
	var table_head = '<thead>' + $('.all-tables thead').html() + '</thead>';
	var table_body = '<tbody><tr>' + $('.bg-primary').html() + '</tr></tbody>';
	var table_close = '</table>';
	
}
