
import $ from "jquery";
window.$ = $;
window.jQuery = $;

// ✅ Bootstrap import (keep as-is)
import * as bootstrap from "bootstrap";

// ✅ Optional debug log
document.addEventListener("DOMContentLoaded", () => {
  console.log("✅ jQuery + Bootstrap loaded (no Turbo, no UJS)");
});
