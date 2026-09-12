document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".toc-item").forEach(function(item) {
    const btn = item.querySelector(".toc-toggle");
    const summary = item.querySelector(".toc-summary");
    if (!btn || !summary) return;

    btn.addEventListener("click", function() {
      const open = summary.style.display === "block";
      summary.style.display = open ? "none" : "block";
      btn.textContent = open ? "▶" : "▼";
    });
  });
});
