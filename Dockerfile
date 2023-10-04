# Use the Python slim image
FROM python:3.8-slim

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt /var/www/html
RUN pip install -r requirements.txt

# Copy your project files
COPY . /var/www/html

# Expose the necessary port
EXPOSE 8000

# Define the command to run your application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
