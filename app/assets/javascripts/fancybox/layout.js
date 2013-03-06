//= require i18n
//= require i18n/translations
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require fancybox
//= require fancybox2
//= require vendor
//= require visualizations
//= require ideas

  // register jquery multi select
  // - category list in ideas form
  $('select#idea_category_ids_edit').multiselect({
    header: false,
    noneSelectedText: ''
  });

