document.addEventListener("DOMContentLoaded", function() {
  const form = document.getElementById("forecast-form");
  form.addEventListener("submit", function(event) {
    event.preventDefault();
    const formData = new FormData(form);
    // Show loading state
    fetch('/loading')
      .then(response => response.text())
      .then(html => {
        document.getElementById("forecast_results").innerHTML = html;
      });
    // Submit form data to forecasts endpoint
    fetch('/forecasts', {
      method: 'POST',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: formData
    })
    .then(response => response.text())
    .then(html => {
      document.getElementById("forecast_results").innerHTML = html;
    })
    .catch(error => {
      document.getElementById("forecast_results").innerHTML = '<div class="mt-6 p-4 bg-red-50 border border-red-200 rounded-lg"><p class="text-red-800">Error: ' + error.message + '</p></div>';
    });
  });
});
