install.packages("dplyr")
install.packages("igraph")
library(dplyr)
library(igraph)
# Disease EJEMPLO: Amiloidosis hereditaria, ORPHA Cod 85450
# número de muestras
n <- 1000

# Dataframe
set.seed(123)
data <- data.frame(
  id = 1:n,
  age = rnorm(n, mean = 50, sd = 10), # Edad promedio de 40 años(en dependencia de etnia) con desviación estándar de 10
  gender = sample(c("Male", "Female"), n, replace = TRUE), # Género aleatorio
  creatinine_level = rnorm(n, mean = 1.2, sd = 0.3), # Nivel de creatinina
  gfr = rnorm(n, mean = 60, sd = 15), # Tasa de filtración glomerular
  disease_stage = sample(1:5, n, replace = TRUE) # Etapa de la enfermedad
)

# Definir los síntomas y su estructura de grafo
symptoms <- c("Fatigue", "Swelling", "Nausea", "Loss of Appetite", "Confusion", "Shortness of Breath", "Chest Pain", "Headache", "Dizziness", "Blurred Vision")
edges <- data.frame(
  from = c("Fatigue", "Fatigue", "Swelling", "Swelling", "Nausea", "Nausea", "Loss of Appetite", "Loss of Appetite", "Confusion", "Confusion", "Shortness of Breath", "Shortness of Breath", "Chest Pain", "Chest Pain", "Headache", "Headache", "Dizziness", "Dizziness"),
  to = c("Swelling", "Nausea", "Loss of Appetite", "Confusion", "Shortness of Breath", "Chest Pain", "Shortness of Breath", "Chest Pain", "Shortness of Breath", "Chest Pain", "Headache", "Dizziness", "Headache", "Dizziness", "Blurred Vision", "Dizziness", "Blurred Vision", "Blurred Vision")
)

# Crear el grafo de síntomas
symptom_graph <- graph_from_data_frame(edges, directed = TRUE, vertices = symptoms)

# Asignar síntomas a los pacientes
assign_symptoms <- function(graph, n) {
  symptoms_list <- vector("list", n)
  for (i in 1:n) {
    symptoms_list[[i]] <- sample(V(graph)$name, sample(1:4, 1), replace = FALSE)
  }
  return(symptoms_list)
}
plot(symptom_graph)
data$symptoms <- assign_symptoms(symptom_graph, n)
# Convertir la columna de síntomas en una cadena de texto
data$symptoms <- sapply(data$symptoms, paste, collapse = ", ")

# Guardar las muestras sintéticas en un archivo CSV
write.csv(data, "synthetic_patients.csv", row.names = FALSE)

# Confirmación
cat("Las muestras sintéticas se han guardado en el archivo 'synthetic_patients.csv'.\n")

# Mostrar las primeras filas del dataframe
head(data)

plot(symptom_graph)

