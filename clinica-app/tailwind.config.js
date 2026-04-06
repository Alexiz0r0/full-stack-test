/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,ts}"],
  theme: {
    extend: {},
  },
  plugins: [require("daisyui")],
  // Configuración de DaisyUI
  daisyui: {
    themes: ["light", "dark"], // Esto activará los temas que intentabas poner en el CSS
  },
};
