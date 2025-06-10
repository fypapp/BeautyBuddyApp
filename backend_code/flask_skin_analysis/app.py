import os
import numpy as np
import tensorflow as tf
import torch
from PIL import Image
from torchvision import transforms, models
from tensorflow.keras.models import load_model
from flask import Flask, request, jsonify
import torch.serialization

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'


app = Flask(__name__)


models_dir = r"E:\\flaskmodel\\flask_skin_analysis\\models"
acne_model_path = os.path.join(models_dir, "acne_severity_model.keras")
skin_tone_model_path = os.path.join(models_dir, "Skin_Tone_Model_MobileNet.h5")
skin_type_model_path = os.path.join(models_dir, "skin_type_complete_model.pth")

# Load models
print("Loading Acne Severity Model...")
acne_model = load_model(acne_model_path)
print("Acne Severity Model Loaded!")

print("Loading Skin Tone Model...")
skin_tone_model = load_model(skin_tone_model_path)
print("Skin Tone Model Loaded!")

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"Using device: {device}")

print("Loading Skin Type Model...")
torch.serialization.add_safe_globals([models.resnet.ResNet])

try:
    skin_type_model = torch.load(skin_type_model_path, map_location=device, weights_only=False)
    print("Loaded full model successfully!")
except Exception as e:
    print(f"Error: {e}")
    print("Loading only weights...")
    skin_type_model = models.resnet18(pretrained=False)
    num_ftrs = skin_type_model.fc.in_features
    skin_type_model.fc = torch.nn.Linear(num_ftrs, 3)
    skin_type_model.load_state_dict(torch.load(skin_type_model_path, map_location=device))

skin_type_model = skin_type_model.to(device)
skin_type_model.eval()
print("Skin Type Model Loaded!")

def preprocess_acne(image_path):
    img = tf.keras.utils.load_img(image_path, target_size=(224, 224))
    img_array = tf.keras.utils.img_to_array(img) / 255.0
    return np.expand_dims(img_array, axis=0)

def preprocess_skin_tone(image_path):
    img = tf.keras.utils.load_img(image_path, target_size=(224, 224))
    img_array = tf.keras.utils.img_to_array(img) / 255.0
    return np.expand_dims(img_array, axis=0)

def preprocess_skin_type(image_path):
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])
    img = Image.open(image_path).convert('RGB')
    return transform(img).unsqueeze(0).to(device)


def analyze_skin(image_path):
    acne_input = preprocess_acne(image_path)
    skin_tone_input = preprocess_skin_tone(image_path)
    skin_type_input = preprocess_skin_type(image_path)

    acne_pred = acne_model.predict(acne_input)
    acne_class = np.argmax(acne_pred)
    acne_labels = ["Acne", "Clear", "Comedo"]

    skin_tone_pred = skin_tone_model.predict(skin_tone_input)
    skin_tone_class = np.argmax(skin_tone_pred)
    skin_tone_labels = ["Dark_deep", "Fair_light", "Medium_tane"]

    with torch.no_grad():
        skin_type_pred = skin_type_model(skin_type_input)
        skin_type_class = torch.argmax(skin_type_pred, dim=1).item()
    skin_type_labels = ["dry", "normal", "oily"]

    return {
        "Acne Severity": acne_labels[acne_class],
        "Skin Tone": skin_tone_labels[skin_tone_class],
        "Skin Type": skin_type_labels[skin_type_class]
    }

@app.route('/analyze', methods=['POST'])
def analyze_uploaded_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    file = request.files['image']
    temp_path = 'temp_image.jpg'
    file.save(temp_path)

    try:
        result = analyze_skin(temp_path)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)

    return jsonify(result)

@app.route('/')
def home():
    return 'Flask Skin Analysis API Running!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
