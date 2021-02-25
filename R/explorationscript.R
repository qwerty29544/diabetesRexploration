# Первичный импорт данных -------------------------------------------------
# Имя файла
datafile = "data/diabetes.csv"

# Импорт файла
df <- read.csv(file = datafile)
str(df)
rm("datafile")

column_name <- colnames(df)
column_mean <- c("Number of times pregnant",
                 "Plasma glucose concentration a 2 hours in an oral glucose tolerance test",
                 "Diastolic blood pressure (mm Hg)",
                 "Triceps skin fold thickness (mm)",
                 "2-Hour serum insulin (mu U/ml)",
                 "Body mass index (weight in kg/(height in m)^2)",
                 "Diabetes pedigree function",
                 "Age (years)",
                 "Class variable (0 or 1) 268 of 768 are 1, the others are 0")
column_mean_ru <- c("Количество раз беременна",
                    "Концентрация глюкозы в плазме через 2 часа при пероральном тесте на толерантность к глюкозе",
                    "Диастолическое артериальное давление (мм рт. Ст.)",
                    "Толщина кожной складки трицепса (мм)",
                    "2-часовой сывороточный инсулин (мЕд/мл, мМЕ/мл – международные единицы в 1 миллилитре, сколько микрограмм того или иного вещества соответствуют условной единице биологической активности)",
                    "Индекс массы тела (вес в кг / (рост в м) ^ 2)",
                    "Родословная диабетическая функция",
                    "Возраст",
                    "Переменная класса (0 или 1) 268 из 768 равны 1, остальные равны 0")
ed_val <- c("шт", "ммоль/л", "мм рт. ст.", "мм", "мЕд/мл", "кг / (м^2)", "у.е.", "время", "логическая переменная")

df_meta <- data.frame(colname = column_name,
                      colmean = column_mean,
                      colmean_ru = column_mean_ru,
                      ed_val = ed_val)
rm("column_mean", "column_mean_ru", "column_name", "ed_val")
