# CREAR COLUMNAS CALCULADAS ANIO Y MES
# 2 min

# Parametros
ruta_datos_origen = "../Datos/3 Origen xdf/"
ruta_datos_procesados = "../Datos/4 Procesados/"
xdf_origen_conversiones = "conversiones.xdf"
xdf_origen_device_data = "device_data.xdf"
xdf_origen_pageviews = "pageviews.xdf"

# Iniciar cronómetro
t0 = Sys.time()

# Concatenar rutas y archivos
xdf_procesados_conversiones = paste0(ruta_datos_procesados, xdf_origen_conversiones)
xdf_procesados_device_data = paste0(ruta_datos_procesados, xdf_origen_device_data)
xdf_procesados_pageviews = paste0(ruta_datos_procesados, xdf_origen_pageviews)
xdf_origen_conversiones = paste0(ruta_datos_origen, xdf_origen_conversiones)
xdf_origen_device_data = paste0(ruta_datos_origen, xdf_origen_device_data)
xdf_origen_pageviews = paste0(ruta_datos_origen, xdf_origen_pageviews)

# Cargar archivos en data frames
nr = rxGetInfo(xdf_origen_conversiones)$numRows
nc = rxGetInfo(xdf_origen_conversiones)$numVars
df_conversiones = rxDataStep(xdf_origen_conversiones, maxRowsByCols = nr*nc)
nr = rxGetInfo(xdf_origen_device_data)$numRows
nc = rxGetInfo(xdf_origen_device_data)$numVars
df_device_data = rxDataStep(xdf_origen_device_data, maxRowsByCols = nr*nc)
nr = rxGetInfo(xdf_origen_pageviews)$numRows
nc = rxGetInfo(xdf_origen_pageviews)$numVars
df_pageviews = rxDataStep(xdf_origen_pageviews, maxRowsByCols = nr*nc)

# Verificar estructura de data frames
str(df_conversiones)
str(df_device_data)
str(df_pageviews)

# Crear columnas anio y mes
# df_device_data
df_device_data$anio = as.integer(substring(df_device_data$FEC_EVENT, 1, 4))
df_device_data$mes = as.integer(substring(df_device_data$FEC_EVENT, 6, 7))
# df_pageviews
df_pageviews$anio = as.integer(substring(df_pageviews$FEC_EVENT, 1, 4))
df_pageviews$mes = as.integer(substring(df_pageviews$FEC_EVENT, 6, 7))

# Guardar en ruta datos procesados
rxDataStep(inData = df_conversiones, outFile = xdf_procesados_conversiones, overwrite = T)
rxDataStep(inData = df_device_data, outFile = xdf_procesados_device_data, overwrite = T)
rxDataStep(inData = df_pageviews, outFile = xdf_procesados_pageviews, overwrite = T)

# Verificar archivos procesados
rxGetVarInfo(xdf_procesados_conversiones)
rxGetVarInfo(xdf_procesados_device_data)
rxGetVarInfo(xdf_procesados_pageviews)

# Liberar memoria
rm(df_conversiones)
rm(df_device_data)
rm(df_pageviews)

# Mostrar tiempo tomado
print(Sys.time() - t0)
