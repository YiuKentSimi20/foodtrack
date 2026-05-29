FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libgl1 \
       libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python deps
COPY requirements.txt .

RUN pip install --upgrade pip
# Install PyTorch (CPU) + torchvision from official PyTorch wheel index, then other requirements
RUN pip install --index-url https://download.pytorch.org/whl/cpu torch torchvision \
    && pip install -r requirements.txt

# Copy application code
COPY . .

EXPOSE 8085

# Run the FastAPI app
CMD ["uvicorn", "FoodModelApi:app", "--host", "0.0.0.0", "--port", "8085"]
