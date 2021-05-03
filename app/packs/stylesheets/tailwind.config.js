module.exports = {
  mode: "jit",
  purge: {
    content: [
      "./app/packs/**/*.{js,css,scss}",
      "./app/helpers/**/*.rb",
      "./app/views/**/*.erb",
    ],
    options: {
      whitelist: [],
    },
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
