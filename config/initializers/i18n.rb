Rails.application.config.after_initialize do
  require "i18n-js/listen"
  I18nJS.listen(
    config_file: "config/i18n.yml",
    locales_dir: ["config/locales", "app/views"],
    options: { only: %r{.yml$} },
    run_on_start: false
  )
end
