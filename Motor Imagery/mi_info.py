import numpy as np
labels = ["None", "Forward", "Backward", "Left", "Right"]

sample_rate = 250

recording_time = 5

num_samples = sample_rate * recording_time

channels = 16

max_fft_hz = 60

segment_length = 50

active_labels= np.array((0, 1, 2, 3)) #---_ DEFINES WHAT LABELS WILL BE TRAINED ON. 0 = neutral, 1 = forward, etc...
