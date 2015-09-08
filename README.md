# Caracara [![Build Status](https://travis-ci.org/gabrielcorado/caracara.svg)](https://travis-ci.org/gabrielcorado/caracara)
Task runner based on [Envoy](http://laravel.com/docs/5.1/envoy) and [Mina](http://mina-deploy.github.io/mina/)

# Concepts
**Task**: Everything is based on this entity, it has steps that are the commands that will be performed somewhere. *Ex: git clone*

**Group**: Group of tasks that represents an business operation. *Ex: deploy*

# Usage
How to use this crazy gem.

**Define some tasks**
```ruby
class GitCloneTask < Caracara::Task
  # Clone the repository
  step 'git clone {{repository}} {{dest}}/scm/{{version}} --recursive'

  # Run commands inside the repo folder
  dir '{{dest}}/scm/{{version}}' do
    # Checkout to the lastest tag
    step 'git checkout {{version}}'

    # Remove .git/ folder
    step 'rm -rf .git/'
  end
end

class DockerTask < Caracara::Task
  # Access new app folder
  dir '{{dest}}/scm/{{version}}' do
    # Build the image
    step 'docker build -t {{image}} .'

    # Remove  the current container
    step 'docker rm -f {{container}}'

    # Start it again
    step 'docker run -d --name {{container}} {{image}}'
  end
end
```

**Group these tasks**
```ruby
class DeployGroup < Caracara::Group
  # Clone it
  task :clone, GitCloneTask

  # Dockernize it
  task :docker, DockerTask
end
```

**Intialize the group**
```ruby
# Set the options
options = {
  repository: 'git@github.com:gabrielcorado/caracara.git',
  dest: '/home/user/apps',
  version: '0.0.0.alpha',
  image: 'caracara',
  container: 'caracara_app'
}

# Initialize the group
deploy = DeployGroup.init options
```

**Generate the commands**
```ruby
# Compile the group commands
commands = deploy.compile_all
```

**Run the command in your server**
```ruby
Caracara::SSH.exec 'user', 'localhost', commands
```

# Development
* **Generating docker image**
  * `docker build -t caracara .`
* **Running the RSpec (for shell fish)**
  * `docker run -v (pwd):/caracara --rm caracara bundle exec rspec`
