import numpy as np
import cv2
from matplotlib import pyplot as plt
import sys

path = '/home/cimubb/Downloads/' #Ubicacion del dataset
def process():
	ruta = ""

	if sys.argv[1] =='1':
		ruta='INDOOR/BOOKS'
	elif sys.argv[1] == '2':
		ruta='INDOOR/ELECTRONICS'
	elif sys.argv[1] == '3':
		ruta='INDOOR/HALLOWEEN'
	elif sys.argv[1] == '4':
		ruta='INDOOR/MATERIALS'
	elif sys.argv[1] == '5':
		ruta='INDOOR/MICS'
	elif sys.argv[1] == '6':
		ruta='INDOOR/PLANTS'
	elif sys.argv[1] == '7':
		ruta='INDOOR/STATUES'
	elif sys.argv[1] == '8':
		ruta='INDOOR/STORAGE_ROOM'
	elif sys.argv[1] == '9':
		ruta='INDOOR/TOOLS'
	elif sys.argv[1] == '10':
		ruta='INDOOR/TOYS'
	elif sys.argv[1] == '11':
		ruta='OUTDOOR/CARS'
	elif sys.argv[1] == '12':
		ruta='OUTDOOR/COURTYARD'
	elif sys.argv[1] == '13':
		ruta='OUTDOOR/CREEK'
	elif sys.argv[1] == '14':
		ruta='OUTDOOR/GARDEN'
	elif sys.argv[1] == '15':
		ruta='OUTDOOR/HOUSE'
	elif sys.argv[1] == '16':
		ruta='OUTDOOR/ISE'
	elif sys.argv[1] == '17':
		ruta='OUTDOOR/PATIO'
	elif sys.argv[1] == '18':
		ruta='OUTDOOR/SHED'
	else:
		print('\nIngrese un valor de 1 a 18 para el primer parámetro\n')
	if  (sys.argv[2] != '1' and sys.argv[2] != '2' and sys.argv[2] != '3' and sys.argv[2] != '4' and sys.argv[2]!= '5'):
		print('\nIngrese un valor de 1 a 5 para el segundo parámetro\n')

	if sys.argv[3] == 'cc':
		imagen_L='color/left_color_default.png'
		imagen_R='color/right_color_default.png'
		mask='color/mask.png'
	elif sys.argv[3] == 'tc':
		imagen_L='cross/left_thermal_default.png'
		imagen_R='cross/right_color_default.png'
		mask='color/mask.png'
	elif sys.argv[3] == 'tt':
		imagen_L='thermal/left_thermal_default.png'
		imagen_R='thermal/right_thermal_default.png'
		mask='color/mask.png'
	else:
		print('\nParámetro inválido o insuficiente\n')

	imgL = cv2.imread(path + 'all/CATS_Release/' + ruta + '/scene' + sys.argv[2] + '/rectified/' + imagen_L,0)
	imgR = cv2.imread(path + 'all/CATS_Release/' + ruta + '/scene' + sys.argv[2] + '/rectified/' + imagen_R,0)
	imgMask = cv2.imread(path + 'all/CATS_Release/' + ruta + '/scene' + sys.argv[2] + '/rectified/' + mask,0)
	if sys.argv[4] == 'BM' or sys.argv[4] == 'bm' or sys.argv[4] == 'Bm':
		stereo = cv2.StereoBM_create(numDisparities=int(sys.argv[5]), blockSize=int(sys.argv[6]))
	elif sys.argv[4] == 'SGBM' or sys.argv[4] == 'sgbm' or sys.argv[4] == 'Sgbm':
		stereo = cv2.StereoSGBM_create(numDisparities=int(sys.argv[5]), blockSize=int(sys.argv[6]));
	else:
		print ('Algoritmo inválido')

	disparity = stereo.compute(imgL,imgR)
	disparity = disparity * imgMask/255
	print (disparity.min())
	print (disparity.max())
	plt.imshow(disparity,'gray')
	plt.show()

if len(sys.argv) > 1:
	process()
else:
	print('Los parámetros a ingresar para ejecutar el procesamiento de las imágenes corresponden a:\n')
	print('A. Categoría de la Imagen\n\t1: Books\n \t2: Electronics\n \t3: Halloween\n \t4: Materials\n \t5: Misc\n \t6: Plants\n \t7: Statues\n \t8: Storage Room \n \t9: Tools\n \t10: Toys\n \t11: Cars\n \t12: Courtyard\n \t13: Creek\n \t14: Garden\n \t15: House\n \t16: Ise\n \t17: Patio\n \t18: Shed\n')
	print('B. Número de Escena dentro de la Categoría\n\tEntero entre 1 y 10\n')
	print('C. Técnica\n\tcc: Análisis en base a imágenes a color\n\ttc: Análisis en base a imagen a color e imagen térmica\n\ttt: Análisis en base a imágenes térmicas\n')
	print('D. Algoritmo a utilizar\n\tBM\n\tSGBM\n')
	print('E. Número de Disparidades\n\tParámetro para el análisis de imágenes stereo\n\tEntero positivo divisible por 16\n')
	print('F. Tamaño del bloque\n\tParámetro para el análisis de imágenes stereo\n\tEntero positivo impar, entre 5 y 255\n')
	

