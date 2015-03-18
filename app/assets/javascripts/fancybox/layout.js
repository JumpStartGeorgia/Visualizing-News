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
    checkAllText: gon.multiselect_checkall,
    uncheckAllText: gon.multiselect_uncheckall,
    noneSelectedText: gon.multiselect_noneselected,
    selectedText: gon.multiselect_selected
  });

