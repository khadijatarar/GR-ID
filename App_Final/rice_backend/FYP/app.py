from flask import Flask, request, jsonify
from flask_cors import CORS
from ultralytics import YOLO
import numpy as np
import cv2

# -------------------------
# App setup
# -------------------------
app = Flask(__name__)
CORS(app)

# -------------------------
# Load YOLO model
# -------------------------
model = YOLO("best.pt")
NAMES = model.names

# -------------------------
# Config (UPDATED FOR STABILITY)
# -------------------------
IMGSZ = 1280
LOC_CONF = 0.25          # FIXED (was too low)
CONF_THRESHOLD = 0.4     # stricter filtering
SINGLE_GRAIN_CUTOFF = 1
MIN_AREA = 500           # filter tiny false detections


# -------------------------
# Health check route
# -------------------------
@app.route("/")
def home():
    return jsonify({"message": "GR-ID API is running"})


# -------------------------
# Prediction endpoint
# -------------------------
@app.route("/predict", methods=["POST"])
def predict():
    try:

        if "image" not in request.files:
            return jsonify({"error": "No image provided"}), 400

        file = request.files["image"]

        # Convert image
        img_bytes = np.frombuffer(file.read(), np.uint8)
        img = cv2.imdecode(img_bytes, cv2.IMREAD_COLOR)

        if img is None:
            return jsonify({"error": "Invalid image"}), 400

        # -------------------------
        # YOLO inference
        # -------------------------
        results = model.predict(img, imgsz=IMGSZ, conf=LOC_CONF, verbose=False)[0]

        # -------------------------
        # STEP 1: FILTER BY CONFIDENCE
        # -------------------------
        valid_boxes = [
            box for box in results.boxes
            if float(box.conf) >= CONF_THRESHOLD
        ]

        # -------------------------
        # STEP 2: FILTER BY SIZE (REMOVE NOISE)
        # -------------------------
        filtered_boxes = []

        for box in valid_boxes:
            x1, y1, x2, y2 = box.xyxy[0].tolist()
            area = (x2 - x1) * (y2 - y1)

            if area >= MIN_AREA:
                filtered_boxes.append(box)

        # -------------------------
        # NO DETECTION CASE
        # -------------------------
        if len(filtered_boxes) == 0:
            return jsonify({
                "mode": "no_detection",
                "success": True,
                "detections": []
            })

        detections = []

        # -------------------------
        # BATCH MODE
        # -------------------------
        if len(filtered_boxes) > SINGLE_GRAIN_CUTOFF:

            for box in filtered_boxes:
                x1, y1, x2, y2 = box.xyxy[0].tolist()

                detections.append({
                    "x1": float(x1),
                    "y1": float(y1),
                    "x2": float(x2),
                    "y2": float(y2),
                    "confidence": float(box.conf),
                    "class": int(box.cls),
                    "class_name": NAMES[int(box.cls)]
                })

            return jsonify({
                "mode": "batch",
                "success": True,
                "detections": detections
            })

        # -------------------------
        # SINGLE GRAIN MODE
        # -------------------------
        best = max(filtered_boxes, key=lambda b: float(b.conf))
        x1, y1, x2, y2 = best.xyxy[0].tolist()

        detections.append({
            "x1": float(x1),
            "y1": float(y1),
            "x2": float(x2),
            "y2": float(y2),
            "confidence": float(best.conf),
            "class": int(best.cls),
            "class_name": NAMES[int(best.cls)]
        })

        return jsonify({
            "mode": "single_grain",
            "success": True,
            "detections": detections
        })

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


# -------------------------
# Run server
# -------------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=7860)