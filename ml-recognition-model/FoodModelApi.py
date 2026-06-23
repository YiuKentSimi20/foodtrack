from fastapi import FastAPI, UploadFile, File
import uvicorn
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision
import torchvision.transforms as transforms
import pandas as pd
import os
import io
from PIL import Image
from pathlib import Path


app = FastAPI(title="FoodTrack AI API", description="Microserviciu pentru recunoasterea mancarii")

print("Se incarca modelul AI...")
BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "efficientnet_b2_food101_best.pth"

def load_model():
    model = torchvision.models.efficientnet_b2()
    
    num_features = model.classifier[1].in_features
    model.classifier[1] = nn.Linear(num_features, 101)
    
    checkpoint = torch.load(MODEL_PATH, map_location=torch.device('cpu'))
    
    model.load_state_dict(checkpoint['model_state_dict'])
    
    idx_to_class = checkpoint['idx_to_class']
    
    model.eval()
    
    return model, idx_to_class

def preprocess_image(image):
    transform = transforms.Compose([
        transforms.Resize((320, 320), interpolation = transforms.InterpolationMode.BICUBIC),
        transforms.CenterCrop(288),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], 
                           std=[0.229, 0.224, 0.225])
    ])
    
    image_tensor = transform(image)
    image_tensor = image_tensor.unsqueeze(0)
    
    return image_tensor, image

def predict_aliment(model, image_tensor, idx_to_class):
    with torch.no_grad():
        outputs = model(image_tensor)
        probabilities = F.softmax(outputs, dim=1)
        
        # Get only the top prediction
        top_prob, top_idx = torch.max(probabilities, 1)
        predicted_class = idx_to_class[top_idx.item()]
        
        return predicted_class, top_prob.item()
    
print("Loading model and data...")
model, idx_to_class = load_model()
print("Model and data loaded successfully!")

@app.post("/api/predict")
async def predict_food(file: UploadFile = File(...)):
    try:
        if model is None:
            return {
                "status": "error",
                "message": f"Modelul nu a fost incarcat. Verifica existenta fisierului la: {MODEL_PATH}"
            }

        contents = await file.read()

        img = Image.open(io.BytesIO(contents)).convert("RGB")


        image_tensor, original_image = preprocess_image(img)
        
        # Facem predictia
        predicted_class, top_prob = predict_aliment(model, image_tensor, idx_to_class)

        if top_prob < 0.3:  # Prag de încredere
            predicted_class = "unknown" 
        
        # Returnam un JSON
        return {
            "status": "success",
            "mancare": predicted_class,
            "siguranta": round(top_prob, 2)
        }
        
    except Exception as e:
        return {"status": "error", "message": str(e)}

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8085)