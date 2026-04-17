// postcss.config.js

module.exports = {
  // Specify the syntax if needed (e.g., postcss-scss)
  // syntax: 'postcss-scss',

  plugins: [
    // Autoprefixer with custom browsers
    require('autoprefixer')({
      overrideBrowserslist: ['> 1%', 'last 2 versions', 'Firefox ESR'],
      flexbox: 'no-2009',
      logo: require('./public/BJimages/logo.svg'),
    }),

    // PostCSS Nested plugin for nested rules
    require('postcss-nested'),
    
    // CSSNano for minification in production
    // Conditionally include for production build
    ...(process.env.NODE_ENV === 'production'
      ? [require('cssnano')({ preset: 'default' })]
      : []),

    // Custom plugin example: adding a plugin with a transform
    function (css) {
      css.walkRules(rule => {
        if (rule.selector.includes('.special')) {
          rule.walkDecls(decl => {
            if (decl.prop === 'color') {
              decl.value = 'red';
            }
          });
        }
      });
    },
  ],
  
};
