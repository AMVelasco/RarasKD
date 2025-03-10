
# Instalar y cargar las librerías necesarias
install.packages("dplyr")
install.packages("igraph")
library(dplyr)
library(igraph)

# Definir el número de muestras
n <- 1000

# Crear un dataframe con datos sintéticos básicos
set.seed(123) # Para reproducibilidad
data <- data.frame(
  id = 1:n,
  age = rnorm(n, mean = 50, sd = 10), # Edad promedio de 50 años con desviación estándar de 10
  gender = sample(c("Male", "Female"), n, replace = TRUE), # Género aleatorio
  creatinine_level = rnorm(n, mean = 1.2, sd = 0.3), # Nivel de creatinina
  gfr = rnorm(n, mean = 60, sd = 15), # Tasa de filtración glomerular
  disease_stage = sample(1:5, n, replace = TRUE) # Etapa de la enfermedad
)

# Definir los síntomas y su estructura de grafo con 5 niveles de profundidad para generar archivo de prueba
symptoms <- c("Fatigue", "Swelling", "Nausea", "Loss of Appetite", "Confusion", "Shortness of Breath", "Chest Pain", "Headache", "Dizziness", "Blurred Vision", "Muscle Cramps", "Itching", "Sleep Problems", "High Blood Pressure", "Anemia")
edges <- data.frame(
  from = c("Fatigue", "Fatigue", "Swelling", "Swelling", "Nausea", "Nausea", "Loss of Appetite", "Loss of Appetite", "Confusion", "Confusion", "Shortness of Breath", "Shortness of Breath", "Chest Pain", "Chest Pain", "Headache", "Headache", "Dizziness", "Dizziness", "Blurred Vision", "Blurred Vision", "Muscle Cramps", "Muscle Cramps", "Itching", "Itching", "Sleep Problems", "Sleep Problems", "High Blood Pressure", "High Blood Pressure", "Anemia", "Anemia"),
  to = c("Swelling", "Nausea", "Loss of Appetite", "Confusion", "Shortness of Breath", "Chest Pain", "Shortness of Breath", "Chest Pain", "Shortness of Breath", "Chest Pain", "Headache", "Dizziness", "Headache", "Dizziness", "Blurred Vision", "Dizziness", "Blurred Vision", "Blurred Vision", "Muscle Cramps", "Itching", "Sleep Problems", "High Blood Pressure", "Sleep Problems", "High Blood Pressure", "High Blood Pressure", "Anemia", "Anemia", "Muscle Cramps", "Itching", "Sleep Problems")
)

# Crear el grafo de síntomas
symptom_graph <- graph_from_data_frame(edges, directed = TRUE, vertices = symptoms)

# Asignar síntomas a los pacientes
assign_symptoms <- function(graph, n) {
  symptoms_list <- vector("list", n)
  for (i in 1:n) {
    symptoms_list[[i]] <- sample(V(graph)$name, sample(1:5, 1), replace = FALSE)
  }
  return(symptoms_list)
}

data$symptoms <- assign_symptoms(symptom_graph, n)

# Convertir la columna de síntomas en una cadena de texto
data$symptoms <- sapply(data$symptoms, paste, collapse = ", ")

# Guardar las muestras sintéticas en un archivo CSV
write.csv(data, "synthetic_patients_2.csv", row.names = FALSE)

# Confirmación
cat("Las muestras sintéticas se han guardado en el archivo 'synthetic_patients_2.csv'.\n")

plot(symptom_graph)

