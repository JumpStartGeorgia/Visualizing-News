function createDynatable(selector) {
  if ($(selector).length === 0) return false;

  var dynatable = {};

  var data = $(selector).dynatable();

  return true;
}
