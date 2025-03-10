
# Cargar las librerías necesarias
library(igraph)
# Disease name: Amiloidosis hereditaria, ORPHA Cod 85450
# Definir las enfermedades y síntomas
enfermedades <- c("85450")
sintomas <- c("Síntoma 1", "Síntoma 2", "Síntoma 3", "Síntoma 4")

# Crear un grafo
edges <- c("85450", "Nephropathy HP:0000112",
           "85450", "Proteinuria HP:0000093",
           "85450", "Renal interstitial amyloid deposits HP:0032613",
           "85450", "Abnormal urinary electrolyte concentration HP:0012591",
           "85450", "Abnormality of the gastrointestinal tract HP:0011024",
           "85450", "Decreased glomerular filtration rate HP:0012213")

# Crear el grafo
g <- graph(edges, directed = FALSE)

# Generar 100 muestras sintéticas
set.seed(123)  # Para reproducibilidad
muestras <- data.frame()

for (i in 1:100) {
  enfermedad <- sample(enfermedades, 1)
  sintomas_asociados <- neighbors(g, V(g)[which(V(g)$name == enfermedad)])
  sintomas_seleccionados <- sample(sintomas_asociados, sample(1:length(sintomas_asociados), 1))

  muestra <- data.frame(
    Muestra = i,
    Enfermedad = enfermedad,
    Sintomas = paste(V(g)[sintomas_seleccionados]$name, collapse = ", ")
  )

  muestras <- rbind(muestras, muestra)
}

# Mostrar las primeras filas de las muestras sintéticas
head(muestras)

plot(muestras)
plot(g)

