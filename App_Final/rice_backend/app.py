from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
import cv2

app = Flask(__name__)

model = YOLO("best.pt")

@app.route("/")
def home():
    return "GR-ID API Running"

@app.route("/predict", methods=["POST"])
def predict():
    file = request.files["image"]

    img = cv2.imdecode(np.frombuffer(file.read(), np.uint8), cv2.IMREAD_COLOR)

    results = model(img)[0]

    detections = []

    for box in results.boxes:
        x1, y1, x2, y2 = box.xyxy[0].tolist()
        conf = float(box.conf[0])
        cls = int(box.cls[0])

        detections.append({
            "x1": x1,
            "y1": y1,
            "x2": x2,
            "y2": y2,
            "confidence": conf,
            "class": cls
        })

    return jsonify(detections)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=7860, debug=True)