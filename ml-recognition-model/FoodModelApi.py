from fastapi import FastAPI, UploadFile, File
import uvicorn
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing import image
import io
from PIL import Image
from pathlib import Path

# 1. Initializam API-ul
app = FastAPI(title="FoodTrack AI API", description="Microserviciu pentru recunoasterea mancarii")

# 2. Încărcăm modelul la pornirea serverului (ca să nu îl încarce la fiecare poză)
print("Se incarca modelul AI...")
BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "food_recognition_model.keras"
try:
    model = tf.keras.models.load_model(MODEL_PATH)
    print("Model incarcat cu succes!")
except Exception as e:
    model = None
    print(f"Eroare la incarcarea modelului: {e}")

# Un dictionar scurt pentru testare
dictionar_clase = {
    0: 'alfa-sprouts', 1: 'almonds', 2: 'anchovies', 3: 'aperol-spritz', 
    4: 'apple', 5: 'apple-crumble', 6: 'apple-pie', 7: 'applesauce'
}

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
        img = img.resize((224, 224))
        img_array = image.img_to_array(img)
        img_array = np.expand_dims(img_array, axis=0)
        img_array /= 255.0  # Normalizarea pixelilor
        
        # Facem predictia
        predictii = model.predict(img_array)
        id_castigator = int(np.argmax(predictii[0]))
        probabilitate = float(predictii[0][id_castigator] * 100)
        
        nume_mancare = dictionar_clase.get(id_castigator, f"ID_Necunoscut_{id_castigator}")
        
        # Returnam un JSON
        return {
            "status": "success",
            "mancare": nume_mancare,
            "siguranta": round(probabilitate, 2)
        }
        
    except Exception as e:
        return {"status": "error", "message": str(e)}

# 4. Comanda de pornire a serverului
if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8085)