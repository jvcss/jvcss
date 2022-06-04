import numpy as np
#from scipy import optimize
import matplotlib.pyplot as plt

dataset = [[17.3,71.7],[19.3,48.3],[19.5,88.3],[19.7,75.0],[22.9,91.7],[23.1,100.0],[26.4,73.3],[26.8,65.0],[27.6,75.0],[28.1,88.3],[28.2,68.3],[28.7,96.7],[29.0,76.7],[29.6,78.3],[29.9,60.0],[29.9,71.7],[30.3,85.0],[31.3,85.0],[36.0,88.3],[39.5,100.0],[40.4,100.0],[44.3,100.0],[44.6,91.7],[50.4,100.0],[55.9,71.7]]
df_x = np.array([item[0] for item in dataset],dtype=np.float16)
df_y = np.array([item[1] for item in dataset],dtype=np.float16)

print(df_x)
print(df_y)


"""
x= None
plt.style.use('seaborn-poster')
dataset = [[17.3,71.7],[19.3,48.3],[19.5,88.3],[19.7,75.0],[22.9,91.7],[23.1,100.0],[26.4,73.3],[26.8,65.0],[27.6,75.0],[28.1,88.3],[28.2,68.3],[28.7,96.7],[29.0,76.7],[29.6,78.3],[29.9,60.0],[29.9,71.7],[30.3,85.0],[31.3,85.0],[36.0,88.3],[39.5,100.0],[40.4,100.0],[44.3,100.0],[44.6,91.7],[50.4,100.0],[55.9,71.7]]
# generate x and y

#print(each[0], end=' ')
#x = np.linspace(dataset[0][0], dataset[-1])
x = np.r
print(x)
y = 1 + x + x * np.random.random(len(x))


# assemble matrix A
A = np.vstack([x, np.ones(len(x))]).T
"""