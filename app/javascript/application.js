import Rails from "@rails/ujs";
Rails.start();


import "./controllers";

import $ from "jquery";
window.$ = $;
window.jQuery = $;

document.addEventListener("DOMContentLoaded", () => {
  console.log("✅ Rails UJS is active");
});
