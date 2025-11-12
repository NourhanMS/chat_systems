FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  default-mysql-client


# Set working directory
WORKDIR /chat_system

# Copy entrypoint script and make it executable
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Install Rails (system-wide in the container)
RUN gem install rails mysql2

# Expose port 3000
EXPOSE 3000

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]
