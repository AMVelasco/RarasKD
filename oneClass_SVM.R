
install.packages("e1071")
install.packages("dplyr")
library(e1071)
library(dplyr)

# Cargar los datos del archivo CSV
data <- read.csv("synthetic_patients_onehot_2.csv")

# Seleccionar las columnas que corresponden a las variables de One-Hot Encoding
# Asumiendo que las columnas de One-Hot Encoding empiezan desde la columna 6 en adelante
onehot_data <- data[, 6:ncol(data)]

# Aplicar One-Class SVM para detectar outliers
set.seed(123) # Para reproducibilidad
svm_model <- svm(onehot_data, type = "one-classification", kernel = "radial", nu = 0.1)

# Predecir las clases de los datos
predictions <- predict(svm_model, onehot_data)

# Añadir las predicciones al dataframe original
data$predictions <- ifelse(predictions == TRUE, "Inlier", "Outlier")

# Guardar el dataframe con las predicciones en un archivo CSV
write.csv(data, "synthetic_patients_onehot2_outliers.csv", row.names = FALSE)

# Confirmación
cat("Las predicciones de One-Class SVM se han guardado en el archivo 'synthetic_patients_onehot2_outliers.csv'.\n")

