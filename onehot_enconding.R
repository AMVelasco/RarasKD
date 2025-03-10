install.packages("dplyr")
install.packages("caret")
library(dplyr)
library(caret)

# Cargar los datos del archivo CSV
data <- read.csv("synthetic_patients.csv")

# Convertir la columna de síntomas en conjuntos de síntomas
data$symptoms_set <- strsplit(as.character(data$symptoms), ", ")

# Crear una lista de todos los síntomas únicos
all_symptoms <- unique(unlist(data$symptoms_set))

# Crear una matriz binaria para los síntomas (One-Hot Encoding)
create_onehot_matrix <- function(data, all_symptoms) {
  onehot_matrix <- matrix(0, nrow = nrow(data), ncol = length(all_symptoms))
  colnames(onehot_matrix) <- all_symptoms
  for (i in 1:nrow(data)) {
    onehot_matrix[i, all_symptoms %in% data$symptoms_set[[i]]] <- 1
  }
  return(onehot_matrix)
}

onehot_matrix <- create_onehot_matrix(data, all_symptoms)

# Convertir la matriz binaria en un dataframe
onehot_df <- as.data.frame(onehot_matrix)

# Combinar el dataframe original con el dataframe de One-Hot Encoding
data_onehot <- cbind(data, onehot_df)

# Eliminar la columna original de síntomas y la columna de conjuntos de síntomas
data_onehot <- data_onehot %>% select(-symptoms, -symptoms_set)

# Guardar el nuevo dataframe con One-Hot Encoding en un archivo CSV
write.csv(data_onehot, "synthetic_patients_onehot.csv", row.names = FALSE)

# Confirmación
cat("Los datos con One-Hot Encoding se han guardado en el archivo 'synthetic_patients_onehot.csv'.\n")
