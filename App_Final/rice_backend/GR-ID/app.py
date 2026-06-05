import gradio as gr
from ultralytics import YOLO
import numpy as np
import cv2

# Load model once
model = YOLO("best.pt")

def predict(image):
    # Convert Gradio image (RGB numpy) → OpenCV format
    img = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

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

    # Draw bounding boxes
    annotated = results.plot()

    return annotated, detections


interface = gr.Interface(
    fn=predict,
    inputs=gr.Image(type="numpy"),
    outputs=[
        gr.Image(type="numpy", label="Detected Image"),
        gr.JSON(label="Detections")
    ],
    title="GR-ID: Grain Recognition System",
    description="Upload an image to detect grains using YOLOv8"
)

interface.launch()