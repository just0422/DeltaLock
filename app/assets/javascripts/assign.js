var assign_key;

$(document).on("turbolinks:load", () => {
	$(".assign-title").click(function(){
		$(this).toggle()
        var id = $(this).attr('id').split('-')[0];
		$("#" + id + "-assign-new-or-search").toggle();
	})
});

function check_assign_ready(){
    var count = 0;
    var assign_params = ["purchaseorders", "purchasers", "endusers", "keys"];
    
    for (var i = 0; i < assign_params.length; i++){
        if ($("input[name=" + assign_params[i] + "]").val() != "")
            count++;
    }

    if (count > 1){
        $("#assign-button").show();
    }
}

function change_assign_entry(type){
    $("input[name=" + type + "]").val("")
    $("#" + type + "-assign-selected").hide();
    $("#" + type + "-assign-new-or-search").show();

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
    
    check_assign_ready();
}

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

function addMapMarker(lat, lng, name, address, id, icon, map){
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
    let markerinfo = new google.maps.InfoWindow({ 
        content: '<div><strong>' + name + '</strong></div><div>' + address + '</div>'
    });

    marker.addListener('click', function() { 
        markerinfo.open(map, marker); 

        let collapsibles = document.querySelectorAll(".assign-map-key-entry");

        for(let i = 0; i < collapsibles.length; i++){
            if (collapsibles[i].dataset.enduser === id && !collapsibles[i].classList.contains("active")){
                let header = collapsibles[i].querySelector(".collapsible-header");
                header.classList.add("assign-map-enduser-selected-keys");
            }
        }
    } );

    markerinfo.addListener('closeclick', function(){
        $(".assign-map-key-entry .collapsible-header").removeClass("assign-map-enduser-selected-keys");
    } );
    return marker
}

function set_assign_selected(css_class){
    $("#" + css_class + "-assign-selected").html(
        '<a class="assign-change-button btn btn-flat delta-btn-flat" ' + 
        'onclick="change_assign_entry(\'' + css_class + '\')">' +
        'Change' + 
        '</a>' +
        '<ul></ul>'
    );
}

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
