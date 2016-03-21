function createDynatable(selector) {
  if ($(selector).length === 0) return null;

  var dynatable = {};

  dynatable.init = function() {
    $(selector).dynatable();
  }

  return dynatable;
}
