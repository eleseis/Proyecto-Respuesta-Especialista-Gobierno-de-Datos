import json
from datetime import datetime

def parse_fecha(fecha_str):
    """Convierte fechas con distintos formatos a ISO (YYYY-MM-DD)."""
    formatos = ["%d-%m-%Y", "%Y-%m-%d", "%d/%m/%Y", "%Y/%m/%d"]
    for fmt in formatos:
        try:
            return datetime.strptime(fecha_str, fmt).strftime("%Y-%m-%d")
        except ValueError:
            continue
    return None

def main(req_body):
    """Simula una Azure Function que:
    - Recibe datos JSON (lista de transacciones)
    - Estandariza formato de fecha
    - Devuelve JSON limpio"""
    try:
        data = json.loads(req_body)
    except json.JSONDecodeError:
        return {"error": "JSON inválido"}

    for item in data:
        if "Fecha" in item:
            item["Fecha"] = parse_fecha(item["Fecha"])
    return data

if __name__ == "__main__":
    with open("transacciones_cloud.json", "r", encoding="utf-8") as f:
        contenido = f.read()
    resultado = main(contenido)
    print(json.dumps(resultado[:5], indent=4, ensure_ascii=False))
