
# Instalar y cargar las librerías necesarias
install.packages("dplyr")
install.packages("igraph")
library(dplyr)
library(igraph)

# Cargar los datos de los archivos CSV
data1 <- read.csv("synthetic_patients_onethot.csv")
data2 <- read.csv("synthetic_patients_oneehot2.csv")

# Convertir la columna de síntomas en conjuntos de síntomas
data1$symptoms_set <- strsplit(as.character(data1$symptoms), ", ")
data2$symptoms_set <- strsplit(as.character(data2$symptoms), ", ")

# Crear una lista de todos los síntomas únicos en ambos conjuntos de datos
all_symptoms <- unique(c(unlist(data1$symptoms_set), unlist(data2$symptoms_set)))

# Crear matrices binarias para los síntomas
create_binary_matrix <- function(data, all_symptoms) {
  binary_matrix <- matrix(0, nrow = nrow(data), ncol = length(all_symptoms))
  colnames(binary_matrix) <- all_symptoms
  for (i in 1:nrow(data)) {
    binary_matrix[i, all_symptoms %in% data$symptoms_set[[i]]] <- 1
  }
  return(binary_matrix)
}

binary_matrix1 <- create_binary_matrix(data1, all_symptoms)
binary_matrix2 <- create_binary_matrix(data2, all_symptoms)

# Calcular la distancia de Jaccard entre los dos conjuntos de datos
jaccard_distances <- numeric(nrow(data1))
for (i in 1:nrow(data1)) {
  jaccard_distances[i] <- sum(binary_matrix1[i, ] & binary_matrix2[i, ]) / sum(binary_matrix1[i, ] | binary_matrix2[i, ])
}

# Promediar las distancias de Jaccard
average_jaccard_distance <- mean(jaccard_distances)

# Mostrar la distancia de Jaccard promedio
cat("La distancia de Jaccard promedio entre los dos grafos es:", average_jaccard_distance, "\n")

