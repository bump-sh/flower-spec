class Flower::Railtie < Rails::Railtie
  rake_tasks do
    load "lib/tasks"
  end
end
