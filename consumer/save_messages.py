from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    'test_topic',
    bootstrap_servers='kafka:9092',
    value_deserializer=lambda m: json.loads(m.decode('utf-8')),
    auto_offset_reset='earliest',
    enable_auto_commit=True
)

messages = []

for message in consumer:
    messages.append(message.value)
    with open('messages.json', 'w') as f:
        json.dump(messages, f, indent=4)
    print(f'Saved: {message.value}')
