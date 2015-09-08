# Include the helper
require 'spec_helper'

# Define a simple task
class FolderTask < Caracara::Task
  step 'mkdir {{folder}}/'
  step 'chmod -R 775 {{folder}}/'
end

# Define a new group
class GroupSpec < Caracara::Group
  # Define a task from a class
  task :folder, FolderTask

  # Simple task
  task :move, 'mv anotherFolder/file.txt {{folder}}/movedFile.txt'
end

# Kickstart with the tests
describe 'Groups' do
  # Initialize the group
  let(:group) {
    GroupSpec.init folder: 'niceFolder'
  }

  it 'should return the right tasks from GroupSpec' do
    # Get the tasks
    tasks = group.tasks

    # Assertions
    expect(tasks[:folder]).to be_an_instance_of(FolderTask)
    expect(tasks[:move]).to be_an_instance_of(Caracara::Task)
  end

  it 'should compile all the tasks' do
    # Get the compile tasks
    tasks = group.compile_all

    # Assertions
    expect(tasks[0][0]).to eq('mkdir niceFolder/')
    expect(tasks[0][1]).to eq('chmod -R 775 niceFolder/')
    expect(tasks[1][0]).to eq('mv anotherFolder/file.txt niceFolder/movedFile.txt')
  end

  it 'should compile just one task' do
    # Compile it
    task = group.compile :move

    # Assertions
    expect(task[0]).to eq('mv anotherFolder/file.txt niceFolder/movedFile.txt')
  end

  it 'should compile all the tasks using the defined args' do
    # Get the compiled tasks
    tasks = group.compile_all folder: 'argsFolder'

    # Assertions
    expect(tasks[0][0]).to eq('mkdir argsFolder/')
    expect(tasks[0][1]).to eq('chmod -R 775 argsFolder/')
    expect(tasks[1][0]).to eq('mv anotherFolder/file.txt argsFolder/movedFile.txt')
  end

  it 'should compile one task using the defined args' do
    # Get the compiled tasks
    task = group.compile :move, folder: 'argsFolder'

    # Assertions
    expect(task[0]).to eq('mv anotherFolder/file.txt argsFolder/movedFile.txt')
  end

  it 'should generate the group command' do
    # Get the command
    command = group.command_all

    # Assertions
    expect(command).to eq("mkdir\\ niceFolder/'\n'chmod\\ -R\\ 775\\ niceFolder/'\n'mv\\ anotherFolder/file.txt\\ niceFolder/movedFile.txt")
  end

  it 'should generate one task command' do
    # Get the command
    command = group.command :move

    # Assertions
    expect(command).to eq("mv\\ anotherFolder/file.txt\\ niceFolder/movedFile.txt")
  end
end
