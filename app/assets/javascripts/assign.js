var assign_key;

// When document loads add function to each assign quad to show buttons on click
$(document).on("turbolinks:load", () => {
	$(".assign-title").click(function(){
		$(this).toggle()
        var id = $(this).attr('id').split('-')[0];
		$("#" + id + "-assign-new-or-search").toggle();
	})
});

/*
 * Checks whether the assign page is ready for an assignment. If there are a least 2
 *  categories that are searched for or created, then the assign button should appear
 */
function check_assign_ready(){
    var count = 0;
    var assign_params = ["purchaseorders", "purchasers", "endusers", "keys"];
    
    // Check for a value in the hidden form elements
    for (var i = 0; i < assign_params.length; i++)
        if ($("input[name=" + assign_params[i] + "]").val() != "")
            count++;

    // Show the assign button
    if (count > 1)
        $("#assign-button").show();
    else
        $("#assign-button").hide();
}

/*
 * If an element is erroneously selected / created, the user can change the entry by simply
 *  clicking the change button. Upon click, the current entry will be erased and hidden. The
 *  create and search buttons will reappear
 *
 * Params:
 *      type - type of element to erase
 */
function change_assign_entry(type){
    // Remove the entry and show the search/create buttons
    $("input[name=" + type + "]").val("")
    $("#" + type + "-assign-selected").hide();
    $("#" + type + "-assign-new-or-search").show();
    
    // If it's an end user store it in the current backend session (for mapping purposes)
    if (type === "endusers"){
        var elementValue = $.trim($(this).find(type + "-id").html());
        $.ajax({
            method: "POST",
            url: "/assign/enduser",
            data: {
                enduser: elementValue
            }
        })
    }
    
    // Check if the assignment can still be created/updated 
    check_assign_ready();
}

/*
 * Initialize map circle
 *
 * Params:
 *      color - color of the circle
 *      radius - radius of the circle ( in miles )
 *      position - latitude , longtude associative dictionary
 *      map - map object to draw on
 *
 * Returns: map circle
 */
function initCircle(color, radius, position, map){
    return new google.maps.Circle({
        strokeColor: color,
        strokeWeight: 5,
        fillColor: color,
        fillOpacity: '0.1',
        radius: radius, // radius * MILE
        center: position,
        map: map,
        clickable: false
    });
}

/*
 * Add a marker to the map
 *
 * Params:
 *      lat - latitude
 *      lng - longitude
 *      name - string to display in the marker's info window
 *      address - address to display in the marker's info window
 *      id - End User ID
 *      icon - marker icon
 *      map - map object to draw on
 * 
 * Returns: map marker
 */
function addMapMarker(lat, lng, name, address, id, icon, map){
    // Create new google marker
    let marker = new google.maps.Marker({
        position: {
            lat: lat, 
            lng: lng
        },
        map: map,
        icon: icon,
        title: name,
        animation: google.maps.Animation.DROP
    })

    // Create marker info
    let markerinfo = new google.maps.InfoWindow({ 
        content: '<div><strong>' + name + '</strong></div><div>' + address + '</div>'
    });
    
    // When the marker is clicked...
    marker.addListener('click', function() { 
        // Attach the info window and open it up
        markerinfo.open(map, marker); 
    
        // Find the collapsible elements (below the map)
        let collapsibles = document.querySelectorAll(".assign-map-key-entry");
        
        // And highlight the associated one
        for(let i = 0; i < collapsibles.length; i++){
            if (collapsibles[i].dataset.enduser === id && !collapsibles[i].classList.contains("active")){
                let header = collapsibles[i].querySelector(".collapsible-header");
                header.classList.add("assign-map-enduser-selected-keys");
            }
        }
    } );
    
    // When the marker info window closes, remove highlight from any of the collapsibles
    markerinfo.addListener('closeclick', function(){
        $(".assign-map-key-entry .collapsible-header").removeClass("assign-map-enduser-selected-keys");
    } );
    return marker
}

/*
 * Create an element for the assignment quad
 *
 * Params:
 *      css_class - type of element to create selection for
 */
function set_assign_selected(css_class){
    // Create a 'change' button and empty list (to be populated later)
    $("#" + css_class + "-assign-selected").html(
        '<a class="assign-change-button btn btn-flat delta-btn-flat" ' + 
        'onclick="change_assign_entry(\'' + css_class + '\')">' +
        'Change' + 
        '</a>' +
        '<ul></ul>'
    );
}

/*
 * Insert element into the list created for the assign quad
 *
 * Params:
 *      element - the row (or collapsible item) to be selected
 *      css_class - the type of element to be selected
 *      title - the column being added to the selection
 *      title_pretty - human-readable version of the title argument
 */
function add_element_to_assign_selected(element, css_class, title, title_pretty){
    let xPlaceholder = '<span class="col push-s1 s1" style="color: red">X</span>';
    let elementValue = $.trim($(element).find("." + css_class + "-" + title).html());

    if (title.includes("bitting")){
        if (elementValue.length == 0)
            elementValue = "//////";
        bits = elementValue.split('/');

        elementValue = "";
        for (let i = 0; i < bits.length; i++){
            if(bits[i].length == 0)
                elementValue += xPlaceholder;
            else
                elementValue += '<span class="col push-s1 s1">' + bits[i] + '</span>'
        }
        $("#" + css_class + "-assign-selected ul li ul").append(
            '<li class="row">'+
                '<strong class="col push-s1 s3">' + title_pretty + ': </strong>' +
                elementValue + 
            '</li>');
    }
    else{
        if (elementValue != ""){
            // Add it to the list
            $("#" + css_class + "-assign-selected ul").append(
                '<li class="delta-collection-item">' +
                    '<div class="" + css_class + "-label">' +
                        '<strong>' + title_pretty + ': </strong>' +
                        '<span class="' + css_class + "-" + title + '">' +
                           elementValue +
                        '</span>' +
                    '</div>' +
                '</li>'
            );
        }
    }
    if(title === "reference_code"){
        $("#" + css_class + "-assign-selected ul").append(
            '<li class="delta-collection-item"><strong>Bitting:</strong>' +
                '<ul>')
    }
    if(title === "bitting_bottom"){
        $("#" + css_class + "-assign-selected ul").append(
                '</ul>' +
            '</li>');
    }
}
