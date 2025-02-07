// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"
// import { start } from "@rails/ujs"
// start()
document.addEventListener("DOMContentLoaded", function() {
    // Trigger the form submission when users are selected
    const form = document.querySelector("form");
    const select = form.querySelector("select[name='project[user_ids][]']");
  
    select.addEventListener("change", function() {
      form.submit();  // Automatically submit form when selection changes
    });
  });
  