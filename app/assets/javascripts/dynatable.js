function createDynatable(selector) {
  if ($(selector).length === 0) return false;

  var dynatable = {};

  var data = $(selector).dynatable({
    readers: {
      'views': function(el, record) {
        return Number(el.innerHTML) || 0;
      },
      'facebookShares': function(el, record) {
        return Number(el.innerHTML) || 0;
      },
      'engagementRating': function(el, record) {
        return Number(el.innerHTML) || 0;
      }
    }
  });

  function get_headers() {
    var headers = $(selector).find('thead th').map(function() {
      return $(this).text().trim();
    });

    return $.makeArray(headers);
  }

  function surround_with_strings(str) {
    return '"' + str + '"';
  }

  function make_exportable() {
    var export_button_id = $(selector).data('exportableById');
    var $export_button = $('#' + export_button_id);

    $export_button.click(function() {
      var $table = $(selector);

      $table.data('dynatable').records.resetOriginal();
      $table.data('dynatable').queries.run();
      $table.data('dynatable').sorts.init();
      var nodes = $table.data('dynatable').records.sort();

      var csvContent = "data:text/csv;charset=utf-8,";
      var headers_str = get_headers().map(surround_with_strings).join(',');
      csvContent += headers_str + "\n";

      nodes.forEach(function(infoArray, index){
        infoArray = $.map(infoArray, function(el) {
          if (typeof el === 'string') {
            el = '"' + el.trim() + '"';
          }

          return el;
        });

        infoArray.shift();
        dataString = infoArray.join(",");
        csvContent += index < nodes.length ? dataString+ "\n" : dataString;
      });

      var encodedUri = encodeURI(csvContent);
      window.open(encodedUri);
    });
  }

  make_exportable();

  return true;
}
