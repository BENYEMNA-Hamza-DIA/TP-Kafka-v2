FROM python:3.8-slim
WORKDIR /app
COPY consumer.py .
COPY save_messages.py .
RUN pip install kafka-python
CMD ["python", "consumer.py"]
