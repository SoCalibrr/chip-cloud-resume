/*jshint esversion: 8 */

const p = document.querySelector("#visit-counter");
VISITORS_ENDPOINT =
  "https://iud19izzn8.execute-api.us-east-1.amazonaws.com/dev";

const updateCounter = async (event) => {
  const response = await fetch(VISITORS_ENDPOINT, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
  });
  const visitors = await response.json();
  p.textContent = `This page has been visited ${visitors.visits} times`;
};

window.addEventListener("DOMContentLoaded", updateCounter);
