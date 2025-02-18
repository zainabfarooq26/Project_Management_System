import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"
import "./charts"
document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form");
    const select = form.querySelector("select[name='project[user_ids][]']");
    select.addEventListener("change", function() {
      form.submit(); 
    });
});