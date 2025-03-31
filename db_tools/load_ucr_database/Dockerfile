# Use the official Python image as the base image
FROM postgres:16.6

# Install any additional system dependencies if needed
# For example, if you need to install PostgreSQL client libraries:
RUN apt-get update 
RUN apt-get install -y libpq-dev 
RUN apt-get clean 
RUN apt-get install -y python3 --fix-missing
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# RUN apt-get update 
# RUN apt-get install -y postgresql-15.5
# RUN apt-get clean 
# RUN apt-get install -y --fix-missing postgresql-contrib
RUN apt-get install -y python3-pip
RUN apt install -y python3-venv

# Set the working directory within the container
WORKDIR /app

RUN python3 -m venv /opt/venv
# Enable venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy the requirements file into the container
COPY requirements.txt .

# Install psycopg2 and any other Python packages you need
RUN pip3 install -Ur requirements.txt

# Add any other setup or configuration steps here

# Set the entry point if needed
# ENTRYPOINT [ "python", "app.py" ]
