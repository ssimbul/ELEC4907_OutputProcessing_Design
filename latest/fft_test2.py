import numpy as np
from matplotlib import pyplot as plt
from scipy.fft import fft, fftfreq
import pandas as pd
# Number of sample points
N = 16383
# sample spacing
T = 1.0 / 100000
x = np.linspace(0.0, N*T, N, endpoint=False)
y = pd.read_csv('test.csv', header=None)
yf = fft(y[0])
xf = fftfreq(N, T)[:N//2]
import matplotlib.pyplot as plt
plt.plot(xf, 2.0/N * np.abs(yf[0:N//2]))
plt.grid()
plt.show()