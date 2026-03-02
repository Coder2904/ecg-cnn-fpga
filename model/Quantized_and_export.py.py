import numpy as np
import tensorflow as tf

MODEL_PATH = "../weights/ecg_model.h5"
OUTPUT_DIR = "../weights/"

model = tf.keras.models.load_model(MODEL_PATH)

def quantize_weights(w):
    scale = np.max(np.abs(w))
    if scale == 0:
        scale = 1
    w_q = np.round(w / scale * 127).astype(np.int8)
    return w_q

def save_hex(array, filename):
    flat = array.flatten()
    with open(OUTPUT_DIR + filename, "w") as f:
        for val in flat:
            if val < 0:
                val = (1 << 8) + val  # 2's complement
            f.write(f"{val:02X}\n")

# Loop through layers
for layer in model.layers:
    weights = layer.get_weights()

    if len(weights) == 2:
        w, b = weights

        w_q = quantize_weights(w)
        b_q = quantize_weights(b)

        if "conv1d" in layer.name and layer.filters == 8:
            save_hex(w_q, "conv1_w.hex")
            save_hex(b_q, "conv1_b.hex")

        elif "conv1d" in layer.name and layer.filters == 16:
            save_hex(w_q, "conv2_w.hex")
            save_hex(b_q, "conv2_b.hex")

        elif "dense" in layer.name and layer.units == 16:
            save_hex(w_q, "dense_w.hex")
            save_hex(b_q, "dense_b.hex")

        elif "dense" in layer.name and layer.units == 1:
            save_hex(w_q, "out_w.hex")
            save_hex(b_q, "out_b.hex")

print("Quantization and HEX export complete.")