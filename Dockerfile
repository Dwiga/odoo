# Use official Python image as a base
FROM python:3.12
LABEL authors="amunoz"

# Set working directory
WORKDIR /opt/odoo

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libxml2-dev \
    libssl-dev \
    libsasl2-dev \
    libldap2-dev \
    zlib1g-dev \
    libjpeg-dev \
    liblcms2-dev \
    libblas-dev \
    git \
    npm \
    && apt-get clean

# Create directories for volume mounts
RUN mkdir -p /opt/odoo /etc/odoo /mnt/extra-addons /var/lib/odoo /var/log/odoo

# Copy requirements file first for better Docker layer caching
COPY ./odoo/requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Set the working directory where Odoo will be mounted
WORKDIR /opt/odoo

# Expose the Odoo port
EXPOSE 8069

# Set environment variables for Odoo
ENV ODOO_CONFIG=/etc/odoo/odoo.conf

# Start Odoo using the same command that works locally
CMD ["python", "odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf", "-i", "base"]
