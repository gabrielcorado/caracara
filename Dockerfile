# Ruby Image
FROM ruby:2.2.0

# Install Bundler
RUN gem install bundler --no-ri --no-rdoc

# Make the app folder
RUN mkdir caracara/

# Set workdir
WORKDIR caracara/

# Add the rest of the source
ADD . .

# Bundle install it
RUN bundle install
