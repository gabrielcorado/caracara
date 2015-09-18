# Include the helper
require 'spec_helper'

class SharedTask < Caracara::Task
  step 'echo "Im doing some tasks with Caracara"'
end

# Class definitions
class TaskSpec < Caracara::Task
  step SharedTask

  step 'mkdir {{folder.name}}/'
  step 'chown -R {{user}} {{folder.name}}', user: 'forcedUser'
  step 'chmod -R {{folder.permission}} {{folder.name}}/'

  dir '{{folder.name}}' do
    step SharedTask
    step 'echo "{{text}}" > file.txt'
  end
end

class AnotherTaskSpec < Caracara::Task
  step 'docker -d run {{image}}'
  step 'echo "{{#times}}{{.}}{{/times}}"'
end

# Tests
describe 'Task' do
  # Initialize the task
  let(:task) {
    TaskSpec.init user: 'ubuntu',
                  folder: {
                    name: 'niceFolder',
                    permission: 755
                  },
                  text: 'Some nice text!'
  }

  # Initialize the task
  let(:another_task) {
    AnotherTaskSpec.init project: 'app',
                         version: '1.5.0',
                         image: '{{project}}-{{version}}',
                         times: ['one ', 'two ', 'three']
  }

  it 'should return the steps' do
    # Get the steps
    steps = task.steps

    # Assertions
    expect(steps[0]).to eq("echo \"Im doing some tasks with Caracara\"")
    expect(steps[1]).to eq('mkdir {{folder.name}}/')
    expect(steps[2]).to eq('chown -R {{user}} {{folder.name}}')
    expect(steps[3]).to eq('chmod -R {{folder.permission}} {{folder.name}}/')
    expect(steps[4]).to eq("(cd {{folder.name}} && (echo \"Im doing some tasks with Caracara\"\\necho \"{{text}}\" > file.txt))")
  end

  it 'should compile the steps' do
    # Get the steps
    steps = task.compile

    # Assertions
    expect(steps[0]).to eq("echo \"Im doing some tasks with Caracara\"")
    expect(steps[1]).to eq('mkdir niceFolder/')
    expect(steps[2]).to eq('chown -R forcedUser niceFolder')
    expect(steps[3]).to eq('chmod -R 755 niceFolder/')
    expect(steps[4]).to eq("(cd niceFolder && (echo \"Im doing some tasks with Caracara\"\\necho \"Some nice text!\" > file.txt))")
  end

  it 'should compile the steps from AnotherTask' do
    # Compile the steps
    steps = another_task.compile

    # Assertions
    expect(steps[0]).to eq('docker -d run app-1.5.0')
    expect(steps[1]).to eq("echo \"one two three\"")
  end

  it 'should compile the steps using specific args' do
    # Get the steps
    steps = task.compile user: 'root',
                         folder: {
                           name: 'argsFolder',
                           permission: 655
                         }

    # Assertions
    expect(steps[0]).to eq("echo \"Im doing some tasks with Caracara\"")
    expect(steps[1]).to eq('mkdir argsFolder/')
    expect(steps[2]).to eq('chown -R forcedUser argsFolder')
    expect(steps[3]).to eq('chmod -R 655 argsFolder/')
    expect(steps[4]).to eq("(cd argsFolder && (echo \"Im doing some tasks with Caracara\"\\necho \"Some nice text!\" > file.txt))")
  end

  it 'should generate the SSH command' do
    # Command
    command = task.command

    # Assertions
    expect(command).to eq("echo\\ \\\"Im\\ doing\\ some\\ tasks\\ with\\ Caracara\\\"'\n'mkdir\\ niceFolder/'\n'chown\\ -R\\ forcedUser\\ niceFolder'\n'chmod\\ -R\\ 755\\ niceFolder/'\n'\\(cd\\ niceFolder\\ \\&\\&\\ \\(echo\\ \\\"Im\\ doing\\ some\\ tasks\\ with\\ Caracara\\\"\\\\necho\\ \\\"Some\\ nice\\ text\\!\\\"\\ \\>\\ file.txt\\)\\)")
  end
end
