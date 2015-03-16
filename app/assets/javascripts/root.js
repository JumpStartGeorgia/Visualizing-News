$(function ()
{

  $(document).on('submit', '#new_message', function ()
  {
    $.post($(this).attr('action'), $(this).serialize(), function (data)
    {
      $('#contact').html(data);
    });
    return false;
  });

});
