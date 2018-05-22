// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require turbolinks
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require underscore
//= require gmaps/google
//= require materialize
//= require_tree .
//

const FADE_TIME = 200;

//Search form functions
function add_fields_click(event){
	//$('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));

    //var modalElement = document.querySelector('.modal');
    //M.Modal.init(modalElement, {opacity: 0.9});
    var selectElements = document.querySelectorAll('select');
    for (var i = 0; i < selectElements.length; i++){
        M.FormSelect.init(selectElements[i]);
    }

    return event.preventDefault();
}

function remove_fields_click(event){
    $(this).closest('.field').remove();
    //var modalElement = document.querySelector('.modal');
    //M.Modal.init(modalElement, {opacity: 0.9});
    return event.preventDefault();
}
