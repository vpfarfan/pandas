# ANALISIS EXPLORATORIO

# Paquetes
library(sqldf)
library(ggplot2)

# Parametros
ruta_datos_procesados = "../Datos/4 Procesados/"
ruta_analisis = "../Analisis Exploratorio/"
xdf_observaciones = "observaciones.xdf"
png_scatterplot_Mes_Ord = "scatterplot_Mes_Ord.png"

# Concatenar rutas y archivos
xdf_observaciones = paste0(ruta_datos_procesados, xdf_observaciones)
png_scatterplot_Mes_Ord = paste0(ruta_analisis, png_scatterplot_Mes_Ord)

# Cargar archivos en data frames
nr = rxGetInfo(xdf_observaciones)$numRows
nc = rxGetInfo(xdf_observaciones)$numVars
df_observaciones = rxDataStep(xdf_observaciones, maxRowsByCols = nr*nc)
str(df_observaciones)

# Crear tabla de probabilidad de mes
df_obs_mes = sqldf("select mes, sum(cast(Conversion as float))/count(*)*100 as Prob_Conversion from df_observaciones group by mes")
str(df_obs_mes)
nr = nrow(df_obs_mes)

# Crear gráfico de series de tiempo
g = ggplot(df_obs_mes, aes(x = mes, y = Prob_Conversion))
g = g + geom_line(colour = "red")
g = g + scale_x_discrete(limits = 1:nr)
g

# Crear variable ordinal Mes_Ord
df_obs_mes = df_obs_mes[order(df_obs_mes$Prob_Conversion), ]
df_obs_mes$Mes_Ord = 1:nr

# Crear gráfico de dispersión
g = ggplot(df_obs_mes, aes(x = Mes_Ord, y = Prob_Conversion))
g = g + geom_point(colour = "red")
g = g + scale_x_discrete(limits = 1:nr)
g = g + ggtitle("Probabilidad Conversión vs Mes Ordinal")
g

# Guardar
ggsave(png_scatterplot_Mes_Ord, plot = g)