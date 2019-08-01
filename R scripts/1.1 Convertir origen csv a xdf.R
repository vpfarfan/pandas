# CONVERTIR ARCHIVOS DE ORIGEN A XDF
# 1 min 14 seg

# Parametros
ruta_datos_origen_csv = "../Datos/2 Origen csv/"
ruta_datos_origen_xdf = "../Datos/3 Origen xdf/"
csv_conversiones = "conversiones.csv"
csv_device_data = "device_data.csv"
csv_pageviews = "pageviews.csv"
xdf_conversiones = "conversiones.xdf"
xdf_device_data = "device_data.xdf"
xdf_pageviews = "pageviews.xdf"

# Iniciar cronómetro
t0 = Sys.time()

# Concatenar rutas y archivos
csv_conversiones = paste0(ruta_datos_origen_csv, csv_conversiones)
csv_device_data = paste0(ruta_datos_origen_csv, csv_device_data)
csv_pageviews = paste0(ruta_datos_origen_csv, csv_pageviews)
xdf_conversiones = paste0(ruta_datos_origen_xdf, xdf_conversiones)
xdf_device_data = paste0(ruta_datos_origen_xdf, xdf_device_data)
xdf_pageviews = paste0(ruta_datos_origen_xdf, xdf_pageviews)

# Inicializar punteros rx a archivos de origen
csv_conversiones = RxTextData(csv_conversiones, delimiter = ",")
csv_device_data = RxTextData(csv_device_data, delimiter = ",")
csv_pageviews = RxTextData(csv_pageviews, delimiter = ",")

# Convertir a xdf
rxDataStep(inData = csv_conversiones, outFile = xdf_conversiones)
rxDataStep(inData = csv_device_data, outFile = xdf_device_data)
rxDataStep(inData = csv_pageviews, outFile = xdf_pageviews)

# Mostrar tiempo tomado
print(Sys.time() - t0)