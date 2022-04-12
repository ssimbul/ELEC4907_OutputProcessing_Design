from pyparsing import srange
from scipy.fft import fft, fftfreq, ifft
import numpy as np
from matplotlib import pyplot as plt
import pandas as pd
import numpy, scipy.optimize
x = pd.read_csv('test.csv', header=None)

# print(df)
N=len(x)
sr = 100000
ts = 1.0/sr
t = np.arange(0,N/sr,ts)


SAMPLE_RATE = 100000  # Hertz
DURATION = 0.16383  # Seconds



X=fft(x)
N = len(X)
n = np.arange(N)
print(n)
T = N/sr
freq = n/T 

plt.figure(figsize = (12, 6))
# plt.subplot(121)
plt.plot(t, x[0], 'r')
plt.ylabel('Amplitude')

# plt.subplot(122)
# plt.stem(freq, np.abs(X), 'b', \
#          markerfmt=" ", basefmt="-b")
# plt.xlabel('Freq (Hz)')
# plt.ylabel('FFT Amplitude |X(freq)|')

plt.show()


# N = SAMPLE_RATE * DURATION


# yf = fft(x)
# xf = fftfreq(int(N), 1 / SAMPLE_RATE)

# plt.plot(xf, np.abs(yf))
# plt.show()


