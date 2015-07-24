$(document).ready(function() {

  // Toggles advanced search in header
  $(".full-search, .search-form-actions button, .search-form-actions a").click(function() {
    $(document).trigger('toggleSearch');
  });

  $(document).on('toggleSearch', function() {
    $(".search-module").toggleClass( "is-hidden" );

    var pageHeight = $(document).height() - 164 // Header height;

    lightbox(pageHeight);
  });

  $('#search').submit(function () {
    // The full search box might be up when clicking on quick find
    // so remove the lightbox
    $("#lightbox").remove();
  })

  // Basic lightbox functionality
  var lightbox = function(height) {
    if ($("#lightbox").size() === 0) {
      var lightbox = $('<div id="lightbox"/>');
      $("body").append(lightbox);
      $("#lightbox").height(height);
    } else {
      $("#lightbox").remove();
    }
  }
});


// Handle presence of Javascript by turning off or on visibility of JS sensitive objects
$(".js-disabled-object").css({"visibility": "hidden"});
$(".js-enabled-object").css({"visibility": "visible"});

function update_collection_search_input(entry_id, sort, page, push_url) {
  var target_url = 'search';
  var query_params = 'page=' + page + '&sort=' + sort;
  if (entry_id && entry_id.length != 0)
    query_params += '&entry_id=' + entry_id ;

  if (history.pushState) {
    if (push_url) {
      var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?' + query_params;
      window.history.pushState({path: newurl}, '', newurl);
    }
  }

  $.ajax({
    type: 'GET',
    dataType: 'script',
    url: target_url,
    data: query_params
  });

  return false;
}

function getURLParameter(name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
}

// Handle "Back" button
$(window).on("popstate", function () {
  // Refresh the contents page using AJAX. Extract & use the parameters from the "backed" url
  var page = getURLParameter("page");
  if (page != null) {
    update_collection_search_input(getURLParameter("entry_id") || '', getURLParameter("sort") || '', getURLParameter("page") || '', false);
  }
});

function go_to_page(page) {
  update_collection_search_input($('#entry_id').val(), $('#sort').val(), page, true);
}
