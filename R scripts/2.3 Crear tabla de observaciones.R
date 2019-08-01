# CREAR TABLA DE OBSERVACIONES
# 2 min 14 seg

# Paquetes
library(sqldf)

# Parametros
ruta_datos_procesados = "../Datos/4 Procesados/"
xdf_conversiones = "conversiones.xdf"
xdf_device_data = "device_data.xdf"
xdf_pageviews = "pageviews.xdf"
xdf_observaciones = "observaciones.xdf"
csv_observaciones = "observaciones.csv"
columnas_observaciones = c("USER_ID", "anio", "mes", "Conversion")
i = 1 # Lapso de tiempo en meses entre lectura de variables predictivas y periodo deseado de predicción

# Iniciar cronómetro
t0 = Sys.time()

# Concatenar rutas y archivos
xdf_conversiones = paste0(ruta_datos_procesados, xdf_conversiones)
xdf_device_data = paste0(ruta_datos_procesados, xdf_device_data)
xdf_pageviews = paste0(ruta_datos_procesados, xdf_pageviews)
xdf_observaciones = paste0(ruta_datos_procesados, xdf_observaciones)
csv_observaciones = paste0(ruta_datos_procesados, csv_observaciones)

# Cargar archivos en data frames
nr = rxGetInfo(xdf_conversiones)$numRows
nc = rxGetInfo(xdf_conversiones)$numVars
df_conversiones = rxDataStep(xdf_conversiones, maxRowsByCols = nr*nc)
nr = rxGetInfo(xdf_device_data)$numRows
nc = rxGetInfo(xdf_device_data)$numVars
df_device_data = rxDataStep(xdf_device_data, maxRowsByCols = nr*nc)
nr = rxGetInfo(xdf_pageviews)$numRows
nc = rxGetInfo(xdf_pageviews)$numVars
df_pageviews = rxDataStep(xdf_pageviews, maxRowsByCols = nr*nc)

# Verificar estructura de data frames
str(df_conversiones)
str(df_device_data)
str(df_pageviews)

# Convertir numérico a entero
df_conversiones$mes = as.integer(df_conversiones$mes)
df_conversiones$anio = as.integer(df_conversiones$anio)
df_conversiones$USER_ID = as.integer(df_conversiones$USER_ID)
df_device_data$USER_ID = as.integer(df_device_data$USER_ID)

# Agregar variable dependiente a df_conversiones
df_conversiones$Conversion = 1

# Eliminar filas de df_conversiones no aplicables por el intervalo de lapso
df_conversiones = subset(df_conversiones, subset = (mes-i > 0))
sort(unique(df_conversiones$mes))

# Agrupar (GROUP BY) anio, mes, USER_ID
df_aniomes_device_data = sqldf("select USER_ID, anio, mes, avg(CONNECTION_SPEED) as AVG_CONNECTION_SPEED, sum(IS_MOBILE_DEVICE) as SUM_IS_MOBILE_DEVICE, sum(cast(IS_MOBILE_DEVICE as float))/count(*) as PCT_IS_MOBILE_DEVICE from df_device_data group by USER_ID, anio, mes")
df_aniomes_pageviews = sqldf("select USER_ID, anio, mes from df_pageviews group by USER_ID, anio, mes")
str(df_aniomes_device_data)
str(df_aniomes_pageviews)

# Merge (JOIN) de ambos data frames
df_observaciones = merge(df_aniomes_device_data, df_aniomes_pageviews)
str(df_observaciones) # 103.765 observaciones

# Crear columna mes+i para merge con df_conversiones
df_observaciones$mes_mas_i = df_observaciones$mes + 1
df_observaciones = subset(df_observaciones, subset = (mes_mas_i <= 12)) # Eliminar filas con mes_mas_i no válido (> 12)
sort(unique(df_observaciones$mes_mas_i))

# Merge con df_conversiones para crear la variable dependiente Conversion
df_observaciones = merge(df_observaciones, df_conversiones, all.x = T, by.x = c("USER_ID", "anio", "mes_mas_i"), by.y = c("USER_ID", "anio", "mes"))
df_observaciones[is.na(df_observaciones$Conversion), "Conversion"] = 0
df_observaciones$Conversion = as.integer(df_observaciones$Conversion)
subset(df_observaciones, subset = (is.na(Conversion)))
table(df_observaciones$Conversion)
df_observaciones$mes_mas_i = NULL # Eliminar columna mes_mas_i 
str(df_observaciones) # 92.846 observaciones

# Guardar tabla de observaciones
rxDataStep(inData = df_observaciones, outFile = xdf_observaciones, overwrite = T)
write.csv2(df_observaciones, file = csv_observaciones, row.names = F)

# Mostrar tiempo
print(Sys.time() - t0)
