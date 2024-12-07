from flask import Flask, jsonify, request
import pandas as pd
import os
# Flask uygulaması oluştur
app = Flask(__name__)


# Uygulama dizinini otomatik olarak bul
current_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(current_dir, 'forecast_results.csv')

forecast_data = pd.read_csv(csv_path)


# Şehir adına göre tüm metriklerin tahminlerini döndüren endpoint
@app.route('/api/forecast', methods=['GET'])
def get_city_forecasts():
    city = request.args.get('city')  # Şehir adı al
    
    if not city:
        return jsonify({"error": "Lütfen 'city' parametresini belirtin."}), 400

    # Şehir için filtreleme
    filtered_data = forecast_data[forecast_data['City'] == city]
    if filtered_data.empty:
        return jsonify({"error": f"{city} şehri için veri bulunamadı."}), 404

    # Tüm metrikler için tahminleri JSON formatına dönüştürme
    forecasts = {}
    for _, row in filtered_data.iterrows():
        metric = row['Metric']
        forecast = eval(row['Forecast'])  # String'den listeye dönüştür
        forecasts[metric] = forecast

    return jsonify({
        "city": city,
        "forecasts": forecasts
    })

if __name__ == '__main__':
    app.run(debug=True)
