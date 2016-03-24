function to_snake_case(str) {
  return str.toLowerCase().split(' ').join('_');
}

function date_stamp() {
  return new Date().toJSON().slice(0,10);
}
