//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/
var eu = "End User";
var k = "Key Codes";
var po = "Purchase Orders";
var p = "Purchasers";

var rows = 0;

var table_columns = {
    "End User"        : ["Name", "Address", "Email", "Phone", "Department", "Store Number"],
    "Key Codes"       : ["Key Code", "Master Key", "Control Key", "Stamp Code"],
    "Purchase Orders" : ["S.O. Number", "P.O. Number", "Date Ordered"],
    "Purchasers"      : ["Name", "Address", "Email", "Phone", "Fax"],
}
var original_tc = table_columns;

var query_row = '\
        <div class="row" id="query-row-NUMBER">\
            <div class="col-xs-2">\
                <select class="form-control" onchange="activate_list_two(this.value, this.id)" id="first-parameter-NUMBER">\
                    <option value="NULL"> -- </option>\
                    <option value="End User">End User</option>\
                    <option value="Key Codes">Key Codes</option>\
                    <option value="Purchase Orders">Purchase Orders</option>\
                    <option value="Purchasers">Purchasers</option>\
                </select>\
            </div>\
            <div class="col-xs-2">\
                <select class="form-control" id="second-parameter-NUMBER" disabled>\
                </select>\
            </div>\
            <div class="col-xs-7">\
                <input type="text" class="form-control" id="input-NUMBER" placeholder name onchange="change_name_of_input_field(this.id)">\
            </div>\
            <div class="col-xs-1">\
                <div class="btn btn-danger" onclick="remove_row(\'query-row-NUMBER\')">\
                  <i class="">AA</i>\
                </div>\
            </div>\
        </div>';


$(document).ready(function(){
    add_new_row();


})
// var searchbar_template = 

// $(document).ready(function(){
//  $('.dropdown li').on('click', show_dropdown_selected_text);
// });

function activate_list_two(column, identity){
    // $($(this)+ " button").html($(this).html() + '<span class="caret pull-right"></span>');

    var new_id = '#second-parameter-' + identity.split('-')[2]

    $(new_id).prop("disabled", false);
    $(new_id).empty();
    // activate second list
    // split ID # from first ID
    //   remove old list2 options
    //   add new list2 options
    // call functin to return html of new options
    for (i = 0; i < table_columns[column].length; i++){
        var opt = table_columns[column][i];
        $(new_id).append('<option value="' + opt + '">' + opt + '</option>');
    }
    // var 
}

function add_new_row(){

    var query_row_complete = query_row
                        .replace("NUMBER", rows)
                        .replace("NUMBER", rows)
                        .replace("NUMBER", rows)
                        .replace("NUMBER", rows)
                        .replace("NUMBER", rows);
    $(".searchbars-list").append(query_row_complete);
    rows++;


    // $('#add-another-field').prop("disabled", true);
}

// function enable_add_more(value){
//  if (value.length > 0)
//      $('#add-another-field').prop("disabled", false);
// }

function change_name_of_input_field(second_select_id){
    console.log(second_select_id);
    var number = second_select_id.split("-")[1];
    var new_id = "#input-" + number;
    var new_name = $("#first-parameter-" + number).val() + "--" + $("#second-parameter-" + number).val();
    console.log("#first-parameter-" + number);
    console.log($("#first-parameter-" + number));
    $(new_id).prop("name", new_name);
}

function remove_row(row_id){
    $('#' + row_id).remove();
}