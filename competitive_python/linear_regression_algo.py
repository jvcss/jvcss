import numpy as np
#from scipy import optimize
import feather as ft
import pandas as pd
import matplotlib.pyplot as plt

info_dataset_title="""
# generate x and y.. This is not the fast way to work with matrix
# Using Feather-Format for 150x more speed   https://pypi.org/project/feather-format/
"""
dataset = [[17.3,71.7],[19.3,48.3],[19.5,88.3],[19.7,75.0],[22.9,91.7],[23.1,100.0],[26.4,73.3],[26.8,65.0],[27.6,75.0],[28.1,88.3],[28.2,68.3],[28.7,96.7],[29.0,76.7],[29.6,78.3],[29.9,60.0],[29.9,71.7],[30.3,85.0],[31.3,85.0],[36.0,88.3],[39.5,100.0],[40.4,100.0],[44.3,100.0],[44.6,91.7],[50.4,100.0],[55.9,71.7]]
df = pd.DataFrame({
	'force': [item[0] for item in dataset],
	'push_up':[item[1] for item in dataset]
})
ft.write_dataframe(df, 'atleta_do_ano.feather')
df = ft.read_dataframe('atleta_do_ano.feather')
#ler só o começo
#print(df.head())
#print([item for item in df['force']])
#print([item for item in df['push_up']])

df_x = np.array([item for item in df['force']],dtype=np.float64)
df_y = np.array([item for item in df['push_up']],dtype=np.float64)
#print(df_x)
#print([np.round(item, decimals=1) for item in df['force']])
#print(df_y)


matrix = np.vstack([df_x, np.ones(len(df_x),dtype=np.float64)]).T
#print(matrix[0][0])
#print(np.vstack([np.round(df_x,decimals=1), np.ones(len(df_x))]))

df_y = df_y[:, np.newaxis]
#print(df_y)

alpha = np.dot((np.dot(np.linalg.inv(np.dot(matrix.T,matrix)), matrix.T)), df_y)
print('output function')
print(f'y = {alpha[1][0]:.2f} * {alpha[0][0]:.4f}x' )

# exibe resultados com MATPLOTLIB
plt.figure(figsize = (7,5))
plt.plot(df_x, df_y, 'b.')
plt.plot(df_x, alpha[0]*df_x + alpha[1], 'r')
plt.xlabel('force')
plt.ylabel('weight')
plt.show()