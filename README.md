# waste

import bluetooth
import io
import time
from PIL import Image

# Define the Bluetooth service UUID
SERVICE_UUID = "00001101-0000-1000-8000-00805F9B34FB"

# Create a Bluetooth socket
client_sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)

# Connect to the Raspberry Pi
client_sock.connect(("XX:XX:XX:XX:XX:XX", 1)) # Replace with the Raspberry Pi Bluetooth MAC address

try:
    # Receive the camera image data
    stream = io.BytesIO()
    while True:
        data = client_sock.recv(1024)
        if not data:
            break
        stream.write(data)

    # Convert the image data to a PIL image
    stream.seek(0)
    image = Image.open(stream)

    # Display the image
    image.show()

except Exception as e:
    print(e)

finally:
   

