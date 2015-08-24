// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrapValidator.min
//= require_tree .

var ready;

ready = function() {
  $(".plan").on("click", function() {
    document.location = $(this).data("target");
    return false;
  });

  $('#new-instance-form').bootstrapValidator({
    fields: {
      'instance[name]': {
        validators: {
          notEmpty: {
            message: 'The hostname is required.'
          }
        }
      },
      plan: {
        validators: {
          notEmpty: {
            message: 'Please select a plan.'
          }
        }
      },
      region: {
        validators: {
          notEmpty: {
            message: 'Please select a region.'
          }
        }
      }
    }
  });
};

$(document).ready(ready);

$(document).on("page:load", ready);
