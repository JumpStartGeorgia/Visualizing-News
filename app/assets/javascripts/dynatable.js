function createDynatable(selector) {
  var $table = $(selector);
  if ($table.length === 0) return false;

  var columns_sort_by_integer = [
    'views',
    'facebookShares',
    'facebookEngagementRating',
    'feradiLikes',
    'feradiEngagementRating',
    'overallEngagementRating'
  ]

  function sort_by_integer(el, record) {
    return Number(el.innerHTML) || 0;
  }

  function init() {
    var readers = {}

    columns_sort_by_integer.forEach(function(str) {
      readers[str] = sort_by_integer;
    })

    $table.dynatable({
      readers: readers
    });
  }

  function get_headers() {
    var headers = $table.find('thead th').map(function() {
      return $(this).text().trim();
    });

    return $.makeArray(headers);
  }

  function surround_with_strings(str) {
    return '"' + str + '"';
  }

  function export_table() {
    $table.data('dynatable').records.resetOriginal();
    $table.data('dynatable').queries.run();
    $table.data('dynatable').sorts.init();
    var nodes = $table.data('dynatable').records.sort();

    var csvContent = "data:attachment/csv;charset=utf-8,";
    var headers_str = get_headers().map(surround_with_strings).join(',');
    csvContent += headers_str + "\n";

    nodes.forEach(function(infoArray, index){
      infoArray = $.map(infoArray, function(el) {
        if (typeof el === 'string') {
          el = surround_with_strings(el.trim());
        }

        return el;
      });

      infoArray.shift();
      dataString = infoArray.join(",");
      csvContent += index < nodes.length ? dataString+ "\n" : dataString;
    });


    var a = document.createElement('a');
    a.href = csvContent;
    a.target = '_blank';
    var date_stamp = new Date().toJSON().slice(0,10);
    a.download = 'feradi-visuals-analytics-' + date_stamp + '.csv';

    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  function make_exportable() {
    var export_button_id = $table.data('exportableById');
    var $export_button = $('#' + export_button_id);

    $export_button.click(export_table);
  }

  init();
  make_exportable();

  return true;
}
