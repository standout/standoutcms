function MemberSearch() {
  var form = $('#member_search');
  var order          = form.find("input[name=order]");
  var orderBy        = form.find("input[name=order_by]");
  var orderByButtons = form.find('th[data-order-by]');

  form.on('submit', formOnSubmit);
  orderByButtons.on('click', orderByButtonsOnClick);

  function formOnSubmit(event) {
    $(this).find('input, select').each(eachFieldDisableIfBlank);
  }

  function eachFieldDisableIfBlank() {
    // Dont bother sending blank params to server
    if (!$(this).val()) { $(this).disable(); }
  }

  function orderByButtonsOnClick(event) {
    // Update hidden order fields and then trigger submit
    var newOrderByVal = $(event.target).data('orderBy');
    if (newOrderByVal === orderBy.val()) {
      order.val(order.val() == 'asc' ? 'desc' : 'asc');
    } else {
      order.val('asc');
      orderBy.val(newOrderByVal);
    }
    form.submit();
  }
}
