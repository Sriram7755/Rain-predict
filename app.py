from flask import Flask, request, jsonify
import pickle
import numpy as np
from flask_cors import CORS

# Load the trained model
with open("rain_prediction_model.pkl", "rb") as f:
    model = pickle.load(f)

app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing

@app.route("/")
def home():
    return "Rain Prediction API is Running!"

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.json
        temperature = float(data["temperature"])
        humidity = float(data["humidity"])
        wind_speed = float(data["wind_speed"])

        input_data = np.array([[temperature, humidity, wind_speed]])
        prediction = model.predict(input_data)
        result = "Rain" if prediction[0] == 1 else "No Rain"

        return jsonify({"prediction": result})

    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)