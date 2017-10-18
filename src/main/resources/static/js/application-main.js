$(document).ready(function() {

//	submit form with 'enter' press
	$("input, textarea").keypress(function(event) {
	    if (event.which == 13) {
	        event.preventDefault();
	        $("form").submit();
	    }
	});
	
//	Make ajax call to update input area
    $("#region-name").change(function() {
        
    	var regionName = $(this).val();
    	
        $.ajax ({
            url: "/region-name?region-name=" + regionName,
            method: "GET", 
            dateType: "text"
       /*     dataType: "json"*/
        })
        
        // Do the work here	
        .done(function(data){

        	$('#output-column').append('<h1>' + regionName + '</h1>');
        	console.log(regionName);

        })
/*        .done(function(data) {
        	$("#crop-variety").empty();
            $.each(data, function(index, cropType) {
            	var option = document.createElement("option");
            	$(option).attr("value", cropType.variety);
            	$(option).text(cropType.variety);
                $("#crop-variety").append(option);
            });
            
            if ($("#crop-variety").children().length === 1) {
            	
        		$("#pricePerPound").val("");
        		
            	$.ajax ({
            		url: "noVarietyPriceGetter?cropType=" + cropType,
            		method: "GET",
            		dataType: "json"            		
            	})
            	.done(function(subData) {
            		$("#pricePerPound").val("$" + subData);
            	})
            	.fail(function(xhr, status, error) {
            		console.log(error);
            	});
        	};
           
        })*/
        .fail(function(xhr, status, error) {

            console.log(error);
        });
    });
    
//    $("#crop-variety").change(function() {
//       	
//        $.ajax ({
//            url: "priceGetter?cropType=" + $("#crop-type").val() + "&cropVariety=" + $("#crop-variety").val(),
//            method: "GET", 
//            dataType: "json"
//        })
//        .done(function(data) {
//        	$("#pricePerPound").val("");
//        	$("#pricePerPound").val("$" + data);
//        })
//        .fail(function(xhr, status, error) {
//            console.log(error);
//        });
//    });
});
 