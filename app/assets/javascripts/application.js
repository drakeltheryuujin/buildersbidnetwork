//= require jquery
//= require jquery_ujs
//= require nested_form
//= require bootstrap/dropdown
//= require bootstrap/tabs
//= require bootstrap/modal
//= require jquery.lightbox
//= require jquery.calculation
//= require jquery.tools.min
      
$(document).ready(function() {
  activatePlaceholders();
});  
 /* To Generate placeholders on non-modern browsers */
function activatePlaceholders() {
  var detect = navigator.userAgent.toLowerCase();
  if (detect.indexOf("safari") > 0) return false;
  var inputs = document.getElementsByTagName("input");

  for (var i = 0; i < inputs.length; i++) {
    if (inputs[i].getAttribute("type") == "text") {
      if (inputs[i].getAttribute("placeholder") && inputs[i].getAttribute("placeholder").length > 0) {
        inputs[i].value = inputs[i].getAttribute("placeholder");
        inputs[i].onclick = function () {
          if (this.value == this.getAttribute("placeholder")) {
            this.value = "";
          }
          return false;
        }
        inputs[i].onblur = function () {
          if (this.value.length < 1) {
            this.value = this.getAttribute("placeholder");
          }
        }
      }
    }
  }
}