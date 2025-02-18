from kafka import KafkaProducer
import json
import time

producer = KafkaProducer(
    bootstrap_servers='kafka:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

topic = 'test_topic'

for i in range(10):
    message = {'number': i, 'text': f'Message {i}'}
    producer.send(topic, message)
    print(f'Produced: {message}')
    time.sleep(1)

producer.flush()
