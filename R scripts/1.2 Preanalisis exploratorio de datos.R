# PRE-ANALISIS EXPLORATORIO DE DATOS
# Análisis de datos brutos antes de procesar

# Parametros
ruta_datos_procesados = "../Datos/4 Procesados/"
ruta_analisis = "../Analisis Exploratorio/"
xdf_conversiones = "conversiones.xdf"
xdf_device_data = "device_data.xdf"
xdf_pageviews = "pageviews.xdf"

# Concatenar rutas y archivos
xdf_conversiones = paste0(ruta_datos_procesados, xdf_conversiones)
xdf_device_data = paste0(ruta_datos_procesados, xdf_device_data)
xdf_pageviews = paste0(ruta_datos_procesados, xdf_pageviews)

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

# Examinar estructuras
str(df_conversiones)
str(df_device_data)
str(df_pageviews)

# Summary
summary(df_conversiones)
summary(df_device_data)
summary(df_pageviews)

# Unique
length(unique(df_pageviews$PAGE)) # 1.725
unique(df_pageviews$CONTENT_CATEGORY)
unique(df_pageviews$CONTENT_CATEGORY_TOP)
unique(df_pageviews$CONTENT_CATEGORY_BOTTOM)
unique(df_pageviews$SITE_ID)
unique(df_pageviews$ON_SITE_SEARCH_TERM)

# Frecuencias
table(df_device_data$CONNECTION_SPEED)
table(df_device_data$IS_MOBILE_DEVICE)
table(df_pageviews$CONTENT_CATEGORY)
table(df_pageviews$CONTENT_CATEGORY_TOP)
table(df_pageviews$CONTENT_CATEGORY_BOTTOM)
table(df_pageviews$SITE_ID)
table(df_pageviews$ON_SITE_SEARCH_TERM)

