/*jshint esversion: 8 */

const p = document.querySelector("#visit-counter");
VISITORS_ENDPOINT =
  "https://iud19izzn8.execute-api.us-east-1.amazonaws.com/dev";

const updateCounter = async (event) => {
  const response = await fetch(VISITORS_ENDPOINT, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    },
  });
  const visitors = await response.json();
  p.textContent = `This page has been visited ${visitors.visitors} times`;
//   p.textContent = `This page has been visited ${visitors.visit_count} times`;
};
// The py response is the problem here. I need to update my code to give a better response in a json format
window.addEventListener("DOMContentLoaded", updateCounter);
