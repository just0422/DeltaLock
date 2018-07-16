//= require turbolinks
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require underscore
//= require gmaps/google
//= require materialize
//= require nouislider
//= require_tree .

const FADE_TIME = 200;
const RED_ICON = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";
const YELLOW_ICON = "http://maps.google.com/mapfiles/ms/icons/yellow-dot.png";
const GREEN_ICON = "http://maps.google.com/mapfiles/ms/icons/green-dot.png";

/*
 * Add fields to Ransack search form
 *
 * Params:
 *  event - click event
 */
function add_fields_click(event){
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));

    var selectElements = document.querySelectorAll('select');
    for (var i = 0; i < selectElements.length; i++){
        M.FormSelect.init(selectElements[i]);
    }

    return event.preventDefault();
}

/*
 * Remove fields from Ransack search form
 *
 * Params:
 *  event - click event
 */
function remove_fields_click(event){
    $(this).closest('.field').remove();
    return event.preventDefault();
}
