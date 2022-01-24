base = read.csv('credit_data.csv')
base$clientid <- NULL
summary(base)

idade_invalida = base[base$age < 0 & !is.na(base$age),]

media <- mean(base$age[base$age > 0], na.rm = TRUE)
base$age = ifelse(base$age < 0,media,base$age)

base[is.na(base$age),]
base$age = ifelse(is.na(base$age),media,base$age)

base[,1:3] =  scale(base[,1:3])

base$default = factor(base$default, levels = c(0,1))

install.packages('caTools')
library(caTools)
set.seed(1)
divisao = sample.split(base$default, SplitRatio = 0.75)
base_treinamento = subset(base, divisao == TRUE)
base_teste = subset(base,divisao == FALSE)

library(e1071)
classificador = naiveBayes(x = base_treinamento[-4], y = base_treinamento$default)

previsoes = predict(classificador, newdata = base_teste[-4])
df = data.frame(c(previsoes))
matriz_confusão = table(base_teste[, 4], previsoes)
install.packages('caret')
library(caret)
confusionMatrix(matriz_confusão)

