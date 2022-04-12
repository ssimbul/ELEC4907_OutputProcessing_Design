"""
===============
Curve fitting
===============

Demos a simple curve fitting
"""
import pandas as pd
############################################################
# First generate some data
import numpy as np
x = pd.read_csv('test.csv', header=None)
# Seed the random number generator for reproducibility
np.random.seed(0)

x_data = np.linspace(0, 1.6383, num=16383)
y_data = x[0]

# And plot it
import matplotlib.pyplot as plt
plt.figure(figsize=(6, 4))
plt.scatter(x_data, y_data)

############################################################
# Now fit a simple sine function to the data
from scipy import optimize

def test_func(x, a, b):
    return a * np.sin(b * x)

params, params_covariance = optimize.curve_fit(test_func, x_data, y_data,
                                               p0=[2, 2])

print(params)

############################################################
# And plot the resulting curve on the data

plt.figure(figsize=(6, 4))
plt.scatter(x_data, y_data, label='Data')
plt.plot(x_data, test_func(x_data, params[0], params[1]),
         label='Fitted function')

plt.legend(loc='best')

plt.show()
