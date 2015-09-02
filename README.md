# Caracara
Task runner based on [Envoy](http://laravel.com/docs/5.1/envoy) and [Mina](http://mina-deploy.github.io/mina/)

# Concepts
**Task**: Everything is based on this entity, it has steps that are the commands that will be performed somewhere. ~~Ex: git-clone~~
**Group**: Group of tasks that represents an business operation. ~~Ex: deploy~~

# Usage
How to use this crazy gem.

**Define a task**
```ruby
class GitCloneTask < Caracara::Task
  # Clone the repository
  step 'git clone {{repository}} {{dest}} --recursive'

  # Run commands inside the repo folder
  dir '{{dest}}' do
    # Checkout to the lastest tag
    step 'git checkout {{version}}'

    # Remove .git/ folder
    step ''
  end
end
```

# Development
* **Generating docker image**
  * `docker build -t caracara .`
* **Running the RSpec (for shell fish)**
  * `docker run -v (pwd):/caracara --rm caracara bundle exec rspec`
