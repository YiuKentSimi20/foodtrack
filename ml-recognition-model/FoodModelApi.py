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

# 1. Initializam API-ul
app = FastAPI(title="FoodTrack AI API", description="Microserviciu pentru recunoasterea mancarii")

# 2. Încărcăm modelul la pornirea serverului (ca să nu îl încarce la fiecare poză)
print("Se incarca modelul AI...")
BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "food_101_model.pth"

def load_model():
    # Initializam arhitectura EfficientNet-B2
    model = torchvision.models.efficientnet_b2()
    
    # Modificăm capul de clasificare pentru cele 101 clase ale tale
    num_features = model.classifier[1].in_features
    model.classifier[1] = nn.Linear(num_features, 101)
    
    # Incarcam modelul antrenat
    MODEL_PATH = "ml-recognition-model/efficientnet_b2_food101_best_71_20test.pth"
    checkpoint = torch.load(MODEL_PATH, map_location=torch.device('cpu'))
    
    # Access the model state dict from the checkpoint
    model.load_state_dict(checkpoint['model_state_dict'])
    
    # Get the class mapping
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
    

def load_data():
    # List of 101 food classes (you can update this with your actual class names)
    food_classes = [
        'apple_pie', 'baby_back_ribs', 'baklava', 'beef_carpaccio', 'beef_tartare',
        'beet_salad', 'beignets', 'bibimbap', 'bread_pudding', 'breakfast_burrito',
        'bruschetta', 'caesar_salad', 'cannoli', 'caprese_salad', 'carrot_cake',
        'ceviche', 'cheesecake', 'cheese_plate', 'chicken_curry', 'chicken_quesadilla',
        'chicken_wings', 'chocolate_cake', 'chocolate_mousse', 'churros', 'clam_chowder',
        'club_sandwich', 'crab_cakes', 'creme_brulee', 'croque_madame', 'cup_cakes',
        'deviled_eggs', 'donuts', 'dumplings', 'edamame', 'eggs_benedict',
        'escargots', 'falafel', 'filet_mignon', 'fish_and_chips', 'foie_gras',
        'french_fries', 'french_onion_soup', 'french_toast', 'fried_calamari', 'fried_rice',
        'frozen_yogurt', 'garlic_bread', 'gnocchi', 'greek_salad', 'grilled_cheese_sandwich',
        'grilled_salmon', 'guacamole', 'gyoza', 'hamburger', 'hot_and_sour_soup',
        'hot_dog', 'huevos_rancheros', 'hummus', 'ice_cream', 'lasagna',
        'lobster_bisque', 'lobster_roll_sandwich', 'macaroni_and_cheese', 'macarons', 'miso_soup',
        'mussels', 'nachos', 'omelette', 'onion_rings', 'oysters',
        'pad_thai', 'paella', 'pancakes', 'panna_cotta', 'peking_duck',
        'pho', 'pizza', 'pork_chop', 'poutine', 'prime_rib',
        'pulled_pork_sandwich', 'ramen', 'ravioli', 'red_velvet_cake', 'risotto',
        'samosa', 'sashimi', 'scallops', 'seaweed_salad', 'shrimp_and_grits',
        'spaghetti_bolognese', 'spaghetti_carbonara', 'spring_rolls', 'steak', 'strawberry_shortcake',
        'sushi', 'tacos', 'takoyaki', 'tiramisu', 'tuna_tartare', 'waffles'
    ]
    
    return food_classes

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

        # Citim biții imaginii primite prin rețea
        contents = await file.read()
        
        # O deschidem cu Pillow și o convertim la RGB (ca sa ingnoram canalul transparent dacă e PNG)
        img = Image.open(io.BytesIO(contents)).convert("RGB")

        # Pre-procesarea exacta ceruta de model
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

# 4. Comanda de pornire a serverului
if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8085)