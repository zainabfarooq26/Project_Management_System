document.addEventListener("DOMContentLoaded", function() {
    const chartDataElement = document.getElementById("chart-data");
    if (!chartDataElement) return; 
    const labels = JSON.parse(chartDataElement.dataset.months);
    const earningsData = JSON.parse(chartDataElement.dataset.earnings);
    const hoursData = JSON.parse(chartDataElement.dataset.hours);
    const ctx = document.getElementById('earningsChart').getContext('2d');
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Earnings ($)',
            data: earningsData,
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
          },
          {
            label: 'Hours Logged',
            data: hoursData,
            backgroundColor: 'rgba(255, 99, 132, 0.5)',
            borderColor: 'rgba(255, 99, 132, 1)',
            borderWidth: 1
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { position: 'top' }
        }
      }
    });
  });
  