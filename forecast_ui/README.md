# ForecastUi
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "forecast_ui", path: "./forecast_ui"
```

And then execute:
```bash
$ bundle install
```

Mount the engine in your `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  mount ForecastUi::Engine, at: "/forecast_ui"
end
```

Import all Tailwind CSS styles in your `app/assets/stylesheets/application.tailwind.css`:
```css
@import "../../../forecast_ui/app/assets/stylesheets/forecast_ui.tailwind.css";
```js

Tell Tailwind to look into the engine for class names by adding the path to the `content` array in your `tailwind.config.js`:
```js
module.exports = {
  content: [
    './forecast_ui/app/views/**/*.{erb,haml,html,slim}'
  ]
}
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
