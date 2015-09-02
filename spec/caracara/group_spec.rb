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
  task FolderTask

  # Simple task
  task 'mv anotherFolder/file.txt {{folder}}/movedFile.txt'
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
    expect(tasks[0]).to be_an_instance_of(FolderTask)
    expect(tasks[1]).to be_an_instance_of(Caracara::Task)
  end

  it 'should return the compiled tasks' do
    # Get the compile tasks
    tasks = group.compile

    # Assertions
    expect(tasks[0][0]).to eq('mkdir niceFolder/')
    expect(tasks[0][1]).to eq('chmod -R 775 niceFolder/')
    expect(tasks[1][0]).to eq('mv anotherFolder/file.txt niceFolder/movedFile.txt')
  end

  it 'should return the group command' do
    # Get the command
    command = group.command

    # Assertions
    expect(command).to eq("mkdir\\ niceFolder/'\n'chmod\\ -R\\ 775\\ niceFolder/'\n'mv\\ anotherFolder/file.txt\\ niceFolder/movedFile.txt")
  end
end
