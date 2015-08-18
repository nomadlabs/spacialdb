ready = ->
    $(".plan").on "click", ->
        document.location = $(this).data("target")
        return false

    $('#new-instance-form').bootstrapValidator(fields:
      'instance[name]': validators: notEmpty: message: 'The hostname is required.'
      plan: validators: notEmpty: message: 'Please select a plan.'
      region: validators: notEmpty: message: 'Please select a region.').on 'success.form.bv', (e) ->

      token = (tok) ->
        $input = $('<input type="hidden" name="stripeToken" />').val(tok.id)
        $('form').append($input).submit()
        return

      StripeCheckout.open
        key: 'pk_test_484HmxEyToeM9CqCzEpw3Kqd'
        name: 'SpacialDB UG'
        currency: 'EUR'
        description: 'Monthly Subscription'
        email: '#{{current_user.email}}'
        panelLabel: 'Subscribe'
        amount: $('input:radio[name=plan]:checked').val()
        token: token
      false

$(document).ready(ready)
$(document).on "page:load", ready