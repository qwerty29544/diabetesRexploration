---
title: "Исследование многопараметрических данных"
author: "Юрченков Иван Александрович"
date: "18 02 2021"
output: 
  word_document: 
    toc: yes
    highlight: haddock
    fig_width: 8
    fig_height: 8
    fig_caption: yes
    keep_md: yes
---

## Введение



Данные, используемые в текущем проекте, содержат ряд диагностических показателей диабета 2 типа у женщин из индийского наследия Пима, а также того, имеет ли индивидуум диабет 2 типа.

Всего имеется 768 наблюдений и 9 переменных. Переменные в наборе данных:

-   Беременности
-   Глюкоза - концентрация глюкозы в плазме крови после 2-часового орального теста на толерантность к глюкозе.
-   BloodPressure - Диастолическое артериальное давление (мм / HG).
-   SkinThickness - толщина трицепса (мм).
-   Инсулин - 2 часа сывороточного инсулина (м.е. / мл).  https://ru.wikipedia.org/wiki/%D0%9C%D0%B5%D0%B6%D0%B4%D1%83%D0%BD%D0%B0%D1%80%D0%BE%D0%B4%D0%BD%D0%B0%D1%8F_%D0%B5%D0%B4%D0%B8%D0%BD%D0%B8%D1%86%D0%B0
-   ИМТ - индекс массы тела (кг / м в квадрате)
-   DiabetesPedigreeFunction - функция, которая определяет риск развития диабета 2 типа на основе семейного анамнеза. Чем больше функция, тем выше риск развития диабета 2 типа.
-   Возраст.
-   Результат - диагностирован ли у человека диабет 2 типа (1 = да, 0 = нет).

Особенно интересным атрибутом, использованным в исследовании, была «Родословная функция диабета». Он предоставил некоторые данные об истории сахарного диабета у родственников и генетических отношениях этих родственников с пациентом. Эта мера генетического влияния дала нам представление о наследственном риске, который может возникнуть при появлении сахарного диабета. Основываясь на наблюдениях в последующем разделе, неясно, насколько хорошо эта функция предсказывает начало диабета.



Посмотрим на структуру данных


```r
str(df)
```

```
## 'data.frame':	768 obs. of  9 variables:
##  $ Pregnancies             : int  6 1 8 1 0 5 3 10 2 8 ...
##  $ Glucose                 : int  148 85 183 89 137 116 78 115 197 125 ...
##  $ BloodPressure           : int  72 66 64 66 40 74 50 0 70 96 ...
##  $ SkinThickness           : int  35 29 0 23 35 0 32 0 45 0 ...
##  $ Insulin                 : int  0 0 0 94 168 0 88 0 543 0 ...
##  $ BMI                     : num  33.6 26.6 23.3 28.1 43.1 25.6 31 35.3 30.5 0 ...
##  $ DiabetesPedigreeFunction: num  0.627 0.351 0.672 0.167 2.288 ...
##  $ Age                     : int  50 31 32 21 33 30 26 29 53 54 ...
##  $ Outcome                 : int  1 0 1 0 1 0 1 0 1 1 ...
```

Выведем все метаданные

+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| Название поля            | Трактовка                                                                | Трактовка на русском                                                                                                                                 | Единицы измерения |
+==========================+==========================================================================+======================================================================================================================================================+===================+
| Pregnancies              | Number of times pregnant                                                 | Беременностей                                                                                                                                        | шт.               |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| Glucose                  | Plasma glucose concentration a 2 hours in an oral glucose tolerance test | Концентрация глюкозы в плазме через 2 часа при пероральном тесте на толерантность к глюкозе                                                          | ммоль/л           |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| BloodPressure            | Diastolic blood pressure (mm Hg)                                         | Диастолическое артериальное давление (мм рт. Ст.)                                                                                                    | мм.рт.ст          |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| SkinThickness            | Triceps skin fold thickness (mm)                                         | Толщина кожной складки трицепса (мм)                                                                                                                 | мм                |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| Insulin                  | 2-Hour serum insulin (mu U/ml)                                           | 2-часовой сывороточный инсулин (мЕд/мл, мМЕ/мл) - сколько микрограмм того или иного вещества соответствуют условной единице биологической активности | мЕд/мл            |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| BMI                      | Body mass index (weight in kg/(height in m)\^2)                          | Индекс массы тела (вес в кг / (рост в м) \^ 2)                                                                                                       | кг / (м\^2)       |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| DiabetesPedigreeFunction | Diabetes pedigree function                                               | Родословная диабетическая функция                                                                                                                    | у.е.              |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| Age                      | Age (years)                                                              | Возраст                                                                                                                                              | Годы              |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+
| Outcome                  | Class variable (0 or 1) 268 of 768 are 1, the others are 0               | Переменная класса (0 или 1) 268 из 768 равны 1, остальные равны 0                                                                                    | логическая        |
+--------------------------+--------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+

: Метаданные полей


## Предварительный анализ

Сначала я изучил каждый атрибут и рассмотрел параметры распространения, подготовленные Weka Explorer. Я заметил, что:

-   Атрибуты preg и age являются целыми числами.
-   Население, как правило, молодое, менее 50 лет.
-   Некоторые атрибуты, где существует нулевое значение, кажутся ошибками в данных (например, Plas, Pres, Skin, InS и Mass).

Изучив распределение значений классов, я заметил, что существует 500 отрицательных случаев (65,1%) и 258 положительных случаев (34,9%).


```r
plot(x = subset(df, select = -Outcome), cex = I(0.5), col = df$Outcome + 1, pch = 19)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-2-1.png)<!-- -->



Рисунок 1. Корреляционная карта признаков данных.


```r
ggplot2::ggplot(df, aes(x = BloodPressure)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df[[3]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Кровеносное давление, мм.рт.ст", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для кровеносного давления") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20)
```

![](4bakOutput_files/figure-docx/bloodpressure density -1.png)<!-- -->


```r
ggplot2::ggplot(df, aes(x = Glucose)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df[[2]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Глюкоза, ммоль/л", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для глюкозы") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20)
```

![](4bakOutput_files/figure-docx/glucoze density -1.png)<!-- -->


```r
ggplot2::ggplot(df, aes(x = SkinThickness)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df[[4]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Толщина кожи трицепса, мм", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для тощины кожи трицепса") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20)
```

![](4bakOutput_files/figure-docx/skinthickness density -1.png)<!-- -->


```r
ggplot2::ggplot(df, aes(x = Insulin)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df[[5]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Инсулин, мЕд/мл", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для инсулина") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20)
```

![](4bakOutput_files/figure-docx/insulin density -1.png)<!-- -->


```r
ggplot2::ggplot(df, aes(x = BMI)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df[[6]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "ИМТ индекс массы тела, кг/(м^2)", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для ИМТ") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20)
```

![](4bakOutput_files/figure-docx/BMI density -1.png)<!-- -->


```r
ggplot2::ggplot(df, aes(x = DiabetesPedigreeFunction)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df[[7]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Родословная диабетическая функция", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для РДФ") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20)
```

![](4bakOutput_files/figure-docx/entfamily density -1.png)<!-- -->


```r
ggplot2::ggplot(df, aes(x = Age)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df[[8]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Возраст в годах", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для возраста") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20)
```

![](4bakOutput_files/figure-docx/age density -1.png)<!-- -->


```r
plot(table(cut(df$Age, breaks = 20)))
```

![](4bakOutput_files/figure-docx/hist detailed-1.png)<!-- -->

Просмотр гистограмм всех атрибутов в наборе данных показывает нам, что:

-   Некоторые атрибуты выглядят нормально распределенными (plas, pres, skin и mass).
-   Некоторые из атрибутов выглядят так, как будто они имеют экспоненциальное распределение (preg, ins, pedi, age).
-   Возраст, вероятно, должен иметь нормальное распределение, ограничения на сбор данных могли исказить распределение.
-   Тестирование на нормальность (график нормальности) может представлять интерес. Мы могли бы посмотреть на подгонку данных к нормальному распределению.

Просмотр диаграмм разброса всех атрибутов в наборе данных показывает, что:

-   Не существует очевидной связи между возрастом и началом диабета.
-   Не существует очевидной связи между функцией педи и началом диабета.
-   Это может свидетельствовать о том, что диабет не является наследственным или что функция родословной диабета нуждается в работе.
-   Более высокие значения плазмы в сочетании с более высокими значениями для возраста, педиатрии, массы, инсулиновой, кожной, жировой ткани и прегина, как правило, показывают большую вероятность положительного результата теста на диабет.



## Очистка данных

По предъявленным распределениям для некоторых измерений можно заранее принять тот факт, что неокторые данные были собраны ошибочно. На основе таких величин можно провести некоторую фильтрацию данных измерений


```r
df_filtered <- df %>% dplyr::filter(BMI != 0 & 
                                      SkinThickness != 0 & 
                                      Glucose != 0 & 
                                      BloodPressure != 0 & 
                                      Insulin !=0)
```



```r
str(df_filtered)
```

```
## 'data.frame':	392 obs. of  9 variables:
##  $ Pregnancies             : int  1 0 3 2 1 5 0 1 1 3 ...
##  $ Glucose                 : int  89 137 78 197 189 166 118 103 115 126 ...
##  $ BloodPressure           : int  66 40 50 70 60 72 84 30 70 88 ...
##  $ SkinThickness           : int  23 35 32 45 23 19 47 38 30 41 ...
##  $ Insulin                 : int  94 168 88 543 846 175 230 83 96 235 ...
##  $ BMI                     : num  28.1 43.1 31 30.5 30.1 25.8 45.8 43.3 34.6 39.3 ...
##  $ DiabetesPedigreeFunction: num  0.167 2.288 0.248 0.158 0.398 ...
##  $ Age                     : int  21 33 26 53 59 51 31 33 32 27 ...
##  $ Outcome                 : int  0 1 1 1 1 1 1 0 1 0 ...
```



```r
plot(x = subset(df_filtered, select = -Outcome), cex = I(0.5), col = df$Outcome + 1, pch = 19)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-4-1.png)<!-- -->



```r
DPF_levels <- c(0.96, 1.4)
ggplot2::ggplot(df_filtered, mapping = aes(y = log(sort(DiabetesPedigreeFunction)), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Записи",
                y = "Родословная диабетическая функция") +
  ggplot2::theme_bw() + 
  ggplot2::geom_hline(color = "red", yintercept = log(DPF_levels), lty = 2) +
  ggplot2::geom_vline(xintercept = 135) +
  ggplot2::geom_text(label = paste("Критический уровень =", 
                                   DPF_levels[1]), 
                     aes(x = 200, 
                         y = DPF_levels[1] + DPF_levels[1]/10)) + 
  ggplot2::geom_text(label = paste("Критический уровень =", 
                                   DPF_levels[2]), 
                     aes(x = 200, 
                         y = DPF_levels[2] + DPF_levels[2]/10))
```

![](4bakOutput_files/figure-docx/unnamed-chunk-5-1.png)<!-- -->



```r
BMI_levels <- c(22.5, 40.5, 47)
ggplot2::ggplot(df_filtered, mapping = aes(y = sort(BMI), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номера записей в таблице",
                y = "ИНдекс массы тела") +
  ggplot2::theme_bw() +
  ggplot2::geom_hline(yintercept = BMI_levels, col = "red", lty = 2)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-6-1.png)<!-- -->



```r
Thick_levels <- c(12, 42, 52)
ggplot2::ggplot(df_filtered, mapping = aes(y = sort(SkinThickness), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсотированных величин",
                x = "Номера записией в таблице",
                y = "Толщина кожи трицепса") +
  ggplot2::theme_bw() +
  ggplot2::geom_hline(yintercept = Thick_levels, col = "red", lty = 2)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-7-1.png)<!-- -->



```r
insulin_levels <- c(38.5, 325, 475)
ggplot2::ggplot(df_filtered, mapping = aes(y = sort(Insulin), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номера записей в таблице данных",
                y = "Инсулин") +
  ggplot2::theme_bw() +
  ggplot2::geom_hline(yintercept = insulin_levels, col = "red", lty = 2)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-8-1.png)<!-- -->



```r
Glucose_levels <- c(80, 100, 130, 160, 180)
ggplot2::ggplot(df_filtered, mapping = aes(y = sort(Glucose), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номер записи в таблице данных",
                y = "Тест глюкозы") +
  ggplot2::theme_bw() +
  ggplot2::geom_hline(yintercept = Glucose_levels, lwd = I(0.5), col = "red", lty = 2)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-9-1.png)<!-- -->



```r
Press_levels <- c(58, 90)
ggplot2::ggplot(df_filtered, mapping = aes(y = sort(BloodPressure), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номер записи в таблице данных",
                y = "Дистолическое артериальное давление") +
  ggplot2::theme_bw() + 
  ggplot2::geom_hline(yintercept = Press_levels, col = "red", lty = 2)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-10-1.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, mapping = aes(y = sort(Age), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номер записи в таблице данных",
                y = "Возраст в годах") +
  ggplot2::theme_bw()
```

![](4bakOutput_files/figure-docx/unnamed-chunk-11-1.png)<!-- -->

```r
ggplot2::ggplot(df_filtered, mapping = aes(y = log(log(log(sort(Age)))), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номер записи в таблице данных",
                y = "Возраст в годах") +
  ggplot2::theme_bw()
```

![](4bakOutput_files/figure-docx/unnamed-chunk-11-2.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, mapping = aes(y = log(sort(Pregnancies) + 1), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номер записи в таблице данных",
                y = "Беременности в количестве единиц") +
  ggplot2::theme_bw()
```

![](4bakOutput_files/figure-docx/unnamed-chunk-12-1.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, aes(x = BloodPressure)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df_filtered[[3]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Кровеносное давление, мм.рт.ст", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для кровеносного давления") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::geom_vline(xintercept = Press_levels, lty = 2, col = "blue")
```

![](4bakOutput_files/figure-docx/bloodpressure density filtered -1.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, aes(x = Glucose)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df_filtered[[2]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Глюкоза, ммоль/л", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для глюкозы") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::geom_vline(xintercept = Glucose_levels, lty = 2, col = "blue")
```

![](4bakOutput_files/figure-docx/glucoze density filtered -1.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, aes(x = SkinThickness)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df_filtered[[4]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Толщина кожи трицепса, мм", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для тощины кожи трицепса") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::geom_vline(xintercept = Thick_levels, lty = 2, col = "blue")
```

![](4bakOutput_files/figure-docx/skinthickness density filtered -1.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, aes(x = Insulin)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df_filtered[[5]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Инсулин, мЕд/мл", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для инсулина") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::geom_vline(xintercept = insulin_levels, lty = 2, col = "blue")
```

![](4bakOutput_files/figure-docx/insulin density filtered -1.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, aes(x = BMI)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df_filtered[[6]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "ИМТ индекс массы тела, кг/(м^2)", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для ИМТ") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::geom_vline(xintercept = BMI_levels, lty = 2, col = "blue")
```

![](4bakOutput_files/figure-docx/BMI density filtered -1.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, aes(x = DiabetesPedigreeFunction)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df_filtered[[7]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Родословная диабетическая функция", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для РДФ") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::geom_vline(xintercept = DPF_levels, lty = 2, col = "blue")
```

![](4bakOutput_files/figure-docx/entfamily density filtered -1.png)<!-- -->



```r
ggplot2::ggplot(df_filtered, aes(x = Age)) + 
    geom_histogram(aes(y = ..density..), 
                 binwidth = density(df_filtered[[8]])$bw, 
                 color = "black", 
                 fill = "grey") +
  ggplot2::geom_density(fill = "red", alpha = I(0.3)) +
  ggplot2::labs(x = "Возраст в годах", 
                subtitle = "Оцениваемая плотность распределения ядерной функцией плотности",
                y = "Оцениваемая вероятность",
                title = "Ядерная функция плотности распределения для возраста") +
  ggplot2::scale_x_continuous(n.breaks = 20) +
  ggplot2::scale_y_continuous(n.breaks = 20)
```

![](4bakOutput_files/figure-docx/age density filtered -1.png)<!-- -->

## Парные корреляции


```r
ggplot2::ggplot(data = df_filtered, aes(x = Glucose, y = Insulin)) +
  ggplot2::geom_point(color = df_filtered$Outcome + 2) +
  ggplot2::geom_hline(yintercept = insulin_levels, lty = 3, col = "blue") +
  ggplot2::geom_vline(xintercept = Glucose_levels, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-13-1.png)<!-- -->

```r
ggplot2::ggplot(data = df_filtered, aes(x = Glucose, y = Insulin)) +
  ggplot2::geom_point(color = df_filtered$Outcome + 2) +
  ggplot2::geom_hline(yintercept = insulin_levels, lty = 3, col = "blue") +
  ggplot2::geom_vline(xintercept = Glucose_levels, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция") +
  ggplot2::geom_rect(xmin = 0, xmax = Glucose_levels[2], 
                     ymin = 0, ymax = max(df_filtered$Insulin), colour = "red", 
                     alpha = 0.002, fill = "red") +
  ggplot2::geom_rect(xmin = Glucose_levels[4], xmax = max(df_filtered$Glucose) + 100, 
                     ymin = 0, ymax = max(df_filtered$Insulin), colour = "green", 
                     alpha = 0.002, fill = "green")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-13-2.png)<!-- -->

```r
ggplot2::ggplot(data = df_filtered, aes(x = Glucose, y = Insulin)) +
  ggplot2::geom_point(color = df_filtered$Outcome + 2) +
  ggplot2::geom_hline(yintercept = insulin_levels, lty = 3, col = "blue") +
  ggplot2::geom_vline(xintercept = Glucose_levels, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция") +
  ggplot2::geom_rect(xmin = 0, xmax = Glucose_levels[3], 
                     ymin = 0, ymax = max(df_filtered$Insulin), colour = "red", 
                     alpha = 0.002, fill = "red") +
  ggplot2::geom_rect(xmin = Glucose_levels[3], xmax = max(df_filtered$Glucose) + 100, 
                     ymin = 0, ymax = max(df_filtered$Insulin), colour = "green", 
                     alpha = 0.002, fill = "green")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-13-3.png)<!-- -->



```r
df_filtered$Nature_model1 <- (df_filtered$Glucose > Glucose_levels[3]) * 1.0
print(target_matrix(df_filtered$Outcome, df_filtered$Nature_model1))
```

```
## $matrix
##        real0 real1
## model0   213    47
## model1    49    83
## 
## $precision
## [1] 0.6287879
## 
## $recall
## [1] 0.6384615
## 
## $F1
## [1] 0.6335878
## 
## $accuracy
## [1] 0.755102
```


```r
df$Nature_model1 <- (df$Glucose > Glucose_levels[3]) * 1.0
print(target_matrix(df$Outcome, df$Nature_model1))
```

```
## $matrix
##        real0 real1
## model0   408   109
## model1    92   159
## 
## $precision
## [1] 0.6334661
## 
## $recall
## [1] 0.5932836
## 
## $F1
## [1] 0.6127168
## 
## $accuracy
## [1] 0.7382812
```



```r
ggplot2::ggplot(data = df_filtered, aes(x = BMI, y = SkinThickness)) +
  ggplot2::geom_point(color = df_filtered$Outcome + 2) +
  ggplot2::geom_hline(yintercept = Thick_levels, lty = 3, col = "blue") +
  ggplot2::geom_vline(xintercept = BMI_levels, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-16-1.png)<!-- -->


```r
ggplot2::ggplot(data = df_filtered, aes(x = BloodPressure, y = Age)) +
  ggplot2::geom_point(color = df_filtered$Outcome + 2) +
  ggplot2::geom_vline(xintercept = Press_levels, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-17-1.png)<!-- -->


```r
ggplot2::ggplot(data = df_filtered, aes(x = Glucose, y = BMI)) +
  ggplot2::geom_point(color = df_filtered$Outcome + 2) +
  ggplot2::geom_vline(xintercept = Glucose_levels, lty = 3, col = "blue") +
  ggplot2::geom_hline(yintercept = BMI_levels, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-18-1.png)<!-- -->

## Перевод величин в систему СИ


\[
  \kappa_1 = BloodPressure \cdot Age^2 \cdot Insulin^{-1} \cdot SkinThickness^2
\]



```r
df_FM <- dplyr::mutate(.data = df_filtered, 
                       Glu_SE = Glucose * 6 * 10 ^ (-23) * 10^3,
                       Ins_SE = Insulin * 34.7 * 10^-3,
                       BMI_SE = BMI,
                       ST_SE = SkinThickness * 10^(-3),
                       Press_SE = BloodPressure * 133.32,
                       Years_SE = Age * 365.25 * 24 * 60 * 60)
df_FM$Kappa1 <- df_FM$Press_SE * df_FM$Years_SE^(2) * df_FM$Ins_SE^(-1) * df_FM$ST_SE^(2)
```




```r
kappa1_levels_log <- c(40.5, 41.36, 42.7, 43.75)
ggplot2::ggplot(df_FM, mapping = aes(y = log(sort(Kappa1)), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номер записи в таблице данных",
                y = "Первая безразмерная величина") +
  ggplot2::theme_bw() +
  ggplot2::geom_hline(yintercept = kappa1_levels_log, lty = 2, col = "red") +
  ggplot2::geom_text(label = kappa1_levels_log[1], x = 200, y = kappa1_levels_log[1] + 0.1) +
  ggplot2::geom_text(label = kappa1_levels_log[2], x = 240, y = kappa1_levels_log[2] + 0.1) + 
  ggplot2::geom_text(label = kappa1_levels_log[3], x = 100, y = kappa1_levels_log[3] + 0.1) +
  ggplot2::geom_text(label = kappa1_levels_log[4], x = 100, y = kappa1_levels_log[4] + 0.1)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-20-1.png)<!-- -->



```r
ggplot2::ggplot(data = df_FM, aes(x = Glucose, y = log(Kappa1))) +
  ggplot2::geom_point(color = df_FM$Outcome + 2) +
  ggplot2::geom_vline(xintercept = Glucose_levels, lty = 3, col = "blue") +
  ggplot2::geom_hline(yintercept = kappa1_levels_log, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-21-1.png)<!-- -->




```r
df_FM$Kappa2 <- df_FM$Ins_SE * df_FM$BMI^(-1) * df_FM$ST_SE
```


```r
kappa2_levels_log <- c(-6.75, -6.25, -5, -4.35)
ggplot2::ggplot(df_FM, mapping = aes(y = log(sort(Kappa2)), 
                                           x = (1:nrow(df_filtered)), 
                                           color = Outcome)) +
  ggplot2::geom_point() +
  ggplot2::geom_line() +
  ggplot2::scale_x_continuous(n.breaks = 20) + 
  ggplot2::scale_y_continuous(n.breaks = 20) +
  ggplot2::labs(title = "Распределение отсортированных величин",
                x = "Номер записи в таблице данных",
                y = "Вторая безразмерная величина") +
  ggplot2::theme_bw() +
  ggplot2::geom_hline(yintercept = kappa2_levels_log, lty = 2, col = "red")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-23-1.png)<!-- -->



```r
ggplot2::ggplot(data = df_FM, aes(x = Kappa2, y = Kappa1)) +
  ggplot2::geom_point(color = df_FM$Outcome + 2) +
  ggplot2::geom_vline(xintercept = exp(kappa2_levels_log), lty = 3, col = "blue") +
  ggplot2::geom_hline(yintercept = exp(kappa1_levels_log), lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-24-1.png)<!-- -->

```r
ggplot2::ggplot(data = df_FM, aes(x = log(Kappa2), y = log(Kappa1))) +
  ggplot2::geom_point(color = df_FM$Outcome + 2) +
  ggplot2::geom_vline(xintercept = kappa2_levels_log, lty = 3, col = "blue") +
  ggplot2::geom_hline(yintercept = kappa1_levels_log, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-24-2.png)<!-- -->


```r
outcome_kappa.logistic <- glm(formula = df_filtered$Outcome ~ log(df_FM$Kappa1) + log(df_FM$Kappa2), 
                        family = binomial)
print(summary(outcome_kappa.logistic))
```

```
## 
## Call:
## glm(formula = df_filtered$Outcome ~ log(df_FM$Kappa1) + log(df_FM$Kappa2), 
##     family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.8003  -0.8653  -0.4997   1.0107   2.5140  
## 
## Coefficients:
##                   Estimate Std. Error z value Pr(>|z|)    
## (Intercept)       -13.1278     4.5487  -2.886   0.0039 ** 
## log(df_FM$Kappa1)   0.4647     0.1106   4.201 2.66e-05 ***
## log(df_FM$Kappa2)   1.2737     0.1820   7.000 2.56e-12 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 498.10  on 391  degrees of freedom
## Residual deviance: 421.12  on 389  degrees of freedom
## AIC: 427.12
## 
## Number of Fisher Scoring iterations: 4
```

```r
df_FM$Out_kappamodel_1 <- (((1 / (1 + exp(-cbind(1, log(df_FM$Kappa1), log(df_FM$Kappa2)) %*% outcome_kappa.logistic$coefficients))) >= 0.5 ) * 1.0)[, 1]
print(target_matrix(df_filtered$Outcome, df_FM$Out_kappamodel_1))
```

```
## $matrix
##        real0 real1
## model0   225    79
## model1    37    51
## 
## $precision
## [1] 0.5795455
## 
## $recall
## [1] 0.3923077
## 
## $F1
## [1] 0.4678899
## 
## $accuracy
## [1] 0.7040816
```



```r
ggplot2::ggplot(data = df_FM, aes(x = log(Kappa2), y = log(Kappa1))) +
  ggplot2::geom_point(color = df_FM$Outcome + 2) +
  ggplot2::geom_vline(xintercept = kappa2_levels_log, lty = 3, col = "blue") +
  ggplot2::geom_hline(yintercept = kappa1_levels_log, lty = 3, col = "blue") +
  ggplot2::theme_bw() +
  ggplot2::labs(title = "Парная корреляция") +
  ggplot2::geom_abline(intercept = -outcome_kappa.logistic$coefficients[1]/outcome_kappa.logistic$coefficients[2],
                       slope = -outcome_kappa.logistic$coefficients[3]/outcome_kappa.logistic$coefficients[2],
                        color = "blue")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-26-1.png)<!-- -->



```r
library(plot3D)
plot3D::scatter3D(x = log(df_FM$Kappa1), y = log(df_FM$Kappa2), z = df_FM$Glucose, colvar = df_FM$Outcome, pch = 19, bty = "g", cex = I(0.8), theta = 45, phi = 35, xlab = "log(Kappa1)", ylab = "log(Kappa2)", zlab = "Glucose")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-27-1.png)<!-- -->



## Метод главных компонент



```r
# Разделение на обучающую и тестовую выборки
set.seed(123)
arange_vector <- 1:nrow(df_filtered)
train_sample <- sample(arange_vector, size = ceiling(0.8 * length(arange_vector)))
df_filtered_train <- df_filtered[train_sample, ]
df_filtered_test <- df_filtered[-train_sample, ]
```




```r
library(devtools)
```

```
## Loading required package: usethis
```

```r
library(factoextra)
```

```
## Welcome! Want to learn more? See two factoextra-related books at https://goo.gl/ve3WBa
```

```r
res.pca <- prcomp(x = df_filtered_train[, -(9:10)], scale. = TRUE)
fviz_eig(res.pca)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-29-1.png)<!-- -->



```r
plot(x = res.pca$x[, 1], 
     y = res.pca$x[, 2], 
     col = df_filtered_train$Outcome + 1, 
     pch = 19, 
     xlab = "Первая главная компонента", 
     ylab = "Вторая главная компонента", 
     main = "Точки набора данных в пространстве первых двух главных компонент")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-30-1.png)<!-- -->
### Модель на две главные компоненты


```r
outcome.logistic <- glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + res.pca$x[, 2], 
                        family = binomial)
print(summary(outcome.logistic))
```

```
## 
## Call:
## glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + res.pca$x[, 
##     2], family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.4146  -0.7842  -0.4330   0.8502   2.3556  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    -0.86837    0.14570  -5.960 2.52e-09 ***
## res.pca$x[, 1]  0.83081    0.10551   7.874 3.43e-15 ***
## res.pca$x[, 2]  0.03587    0.10391   0.345     0.73    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 402.89  on 313  degrees of freedom
## Residual deviance: 313.74  on 311  degrees of freedom
## AIC: 319.74
## 
## Number of Fisher Scoring iterations: 4
```


```r
plot(x = res.pca$x[, 1], 
     y = res.pca$x[, 2], 
     col = df_filtered_train$Outcome + 1, 
     pch = 19, 
     xlab = "Первая главная компонента", 
     ylab = "Вторая главная компонента", 
     main = "Точки набора данных в пространстве первых двух главных компонент")
abline(a = outcome.logistic$coefficients[1] / outcome.logistic$coefficients[3], 
       b = outcome.logistic$coefficients[2] / outcome.logistic$coefficients[3], 
       lty = 2, lwd = I(1.5), col = "blue")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-31-1.png)<!-- -->


```r
df_filtered_train$Out_logmodel_1 <- (((1 / (1 + exp(-cbind(1, res.pca$x[, 1:2]) %*% outcome.logistic$coefficients))) >= 0.5 ) * 1.0)[, 1]

print(target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_1))
```

```
## $matrix
##        real0 real1
## model0   176    54
## model1    31    53
## 
## $precision
## [1] 0.6309524
## 
## $recall
## [1] 0.4953271
## 
## $F1
## [1] 0.5549738
## 
## $accuracy
## [1] 0.7292994
```

### Модель на три главные компоненты



```r
outcome.logistic2 <- glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + 
                          res.pca$x[, 2] +
                          res.pca$x[, 3], 
                        family = binomial)
print(summary(outcome.logistic2))
```

```
## 
## Call:
## glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + res.pca$x[, 
##     2] + res.pca$x[, 3], family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -3.1393  -0.7339  -0.4349   0.8144   2.2778  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    -0.85402    0.14705  -5.808 6.34e-09 ***
## res.pca$x[, 1]  0.86401    0.10983   7.867 3.63e-15 ***
## res.pca$x[, 2]  0.03691    0.10585   0.349  0.72729    
## res.pca$x[, 3] -0.40833    0.14009  -2.915  0.00356 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 402.89  on 313  degrees of freedom
## Residual deviance: 304.57  on 310  degrees of freedom
## AIC: 312.57
## 
## Number of Fisher Scoring iterations: 4
```



```r
plot(x = res.pca$x[, 1], 
     y = res.pca$x[, 2], 
     col = df_filtered_train$Outcome + 1, 
     pch = 19, 
     xlab = "Первая главная компонента", 
     ylab = "Вторая главная компонента", 
     main = "Точки набора данных в пространстве первых двух главных компонент")
abline(a = outcome.logistic2$coefficients[1] / outcome.logistic2$coefficients[3], 
       b = outcome.logistic2$coefficients[2] / outcome.logistic2$coefficients[3], 
       lty = 2, lwd = I(1.5), col = "blue")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-33-1.png)<!-- -->

```r
plot(x = res.pca$x[, 1], 
     y = res.pca$x[, 3], 
     col = df_filtered_train$Outcome + 1, 
     pch = 19, 
     xlab = "Первая главная компонента", 
     ylab = "Третья главная компонента", 
     main = "Точки набора данных в пространстве первых двух главных компонент")
abline(a = outcome.logistic2$coefficients[1] / outcome.logistic2$coefficients[4], 
       b = outcome.logistic2$coefficients[2] / outcome.logistic2$coefficients[4], 
       lty = 2, lwd = I(1.5), col = "blue")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-33-2.png)<!-- -->

```r
plot(x = res.pca$x[, 2], 
     y = res.pca$x[, 3], 
     col = df_filtered_train$Outcome + 1, 
     pch = 19, 
     xlab = "Вторая главная компонента", 
     ylab = "Третья главная компонента", 
     main = "Точки набора данных в пространстве первых двух главных компонент")
abline(a = outcome.logistic2$coefficients[1] / outcome.logistic2$coefficients[4], 
       b = outcome.logistic2$coefficients[3] / outcome.logistic2$coefficients[4], 
       lty = 2, lwd = I(1.5), col = "blue")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-33-3.png)<!-- -->



```r
plot3D::scatter3D(x = res.pca$x[, 1], y = res.pca$x[, 2], z = res.pca$x[, 3], colvar = df_filtered_train$Outcome, pch = 19, bty = "g", cex = I(0.8), theta = 45, phi = 35, xlab = "PC1", ylab = "PC2", zlab = "PC3")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-34-1.png)<!-- -->


```r
grid.lines = 26
x.pred <- seq(min(res.pca$x[, 1]), max(res.pca$x[, 1]), length.out = grid.lines)
y.pred <- seq(min(res.pca$x[, 2]), max(res.pca$x[, 2]), length.out = grid.lines)
xy <- expand.grid( x = x.pred, y = y.pred)
z.pred <- matrix((outcome.logistic2$coefficients[1] + xy[, 1] * outcome.logistic2$coefficients[2] + xy[, 2] *
                    outcome.logistic2$coefficients[3]) / outcome.logistic2$coefficients[4], 
                 nrow = grid.lines, 
                 ncol = grid.lines)

plot3D::scatter3D(x = res.pca$x[, 1], 
                  y = res.pca$x[, 2], 
                  z = res.pca$x[, 3], 
                  colvar = df_filtered_train$Outcome, 
                  pch = 19, 
                  bty = "u", 
                  cex = I(0.8), 
                  theta = 15, 
                  phi = 0, 
                  xlab = "PC1", 
                  ylab = "PC2", 
                  zlab = "PC3", 
                  ticktype = "detailed",
                  surf = list(x = x.pred, y = y.pred, z = z.pred, facets = NA), 
                  col.panel ="steelblue", col.grid = "darkblue")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-35-1.png)<!-- -->



```r
df_filtered_train$Out_logmodel_2 <- (((1 / (1 + exp(-cbind(1, res.pca$x[, 1:3]) %*% outcome.logistic2$coefficients))) >= 0.5 ) * 1.0)[, 1]
print(target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_2))
```

```
## $matrix
##        real0 real1
## model0   181    50
## model1    26    57
## 
## $precision
## [1] 0.686747
## 
## $recall
## [1] 0.5327103
## 
## $F1
## [1] 0.6
## 
## $accuracy
## [1] 0.7579618
```

### Модель на четыре главные компоненты



```r
outcome.logistic3 <- glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + 
                          res.pca$x[, 2] +
                          res.pca$x[, 3] +
                          res.pca$x[, 4], 
                        family = binomial)
print(summary(outcome.logistic3))
```

```
## 
## Call:
## glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + res.pca$x[, 
##     2] + res.pca$x[, 3] + res.pca$x[, 4], family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -3.2832  -0.7330  -0.4183   0.8169   2.2556  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    -0.85479    0.14721  -5.806 6.38e-09 ***
## res.pca$x[, 1]  0.87135    0.11098   7.851 4.11e-15 ***
## res.pca$x[, 2]  0.04701    0.10718   0.439  0.66099    
## res.pca$x[, 3] -0.41496    0.14027  -2.958  0.00309 ** 
## res.pca$x[, 4] -0.15035    0.14775  -1.018  0.30886    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 402.89  on 313  degrees of freedom
## Residual deviance: 303.52  on 309  degrees of freedom
## AIC: 313.52
## 
## Number of Fisher Scoring iterations: 5
```

```r
df_filtered_train$Out_logmodel_3 <- (((1 / (1 + exp(-cbind(1, res.pca$x[, 1:4]) %*% outcome.logistic3$coefficients))) >= 0.5 ) * 1.0)[, 1]
print(target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_3))
```

```
## $matrix
##        real0 real1
## model0   182    49
## model1    25    58
## 
## $precision
## [1] 0.6987952
## 
## $recall
## [1] 0.5420561
## 
## $F1
## [1] 0.6105263
## 
## $accuracy
## [1] 0.7643312
```

### Модель на 5 главных компонент


```r
outcome.logistic4 <- glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + 
                          res.pca$x[, 2] +
                          res.pca$x[, 3] +
                          res.pca$x[, 4] +
                          res.pca$x[, 5], 
                        family = binomial)
print(summary(outcome.logistic4))
```

```
## 
## Call:
## glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + res.pca$x[, 
##     2] + res.pca$x[, 3] + res.pca$x[, 4] + res.pca$x[, 5], family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -3.3043  -0.7288  -0.4171   0.8130   2.2416  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    -0.85373    0.14723  -5.799 6.68e-09 ***
## res.pca$x[, 1]  0.87197    0.11106   7.851 4.12e-15 ***
## res.pca$x[, 2]  0.04693    0.10738   0.437  0.66206    
## res.pca$x[, 3] -0.41512    0.14027  -2.959  0.00308 ** 
## res.pca$x[, 4] -0.15121    0.14778  -1.023  0.30618    
## res.pca$x[, 5] -0.04143    0.16985  -0.244  0.80729    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 402.89  on 313  degrees of freedom
## Residual deviance: 303.47  on 308  degrees of freedom
## AIC: 315.47
## 
## Number of Fisher Scoring iterations: 5
```

```r
df_filtered_train$Out_logmodel_4 <- (((1 / (1 + exp(-cbind(1, res.pca$x[, 1:5]) %*% outcome.logistic4$coefficients))) >= 0.5 ) * 1.0)[, 1]
print(target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_4))
```

```
## $matrix
##        real0 real1
## model0   182    48
## model1    25    59
## 
## $precision
## [1] 0.702381
## 
## $recall
## [1] 0.5514019
## 
## $F1
## [1] 0.617801
## 
## $accuracy
## [1] 0.7675159
```


### Модель на 6 главных компонент


```r
outcome.logistic5 <- glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + 
                          res.pca$x[, 2] +
                          res.pca$x[, 3] +
                          res.pca$x[, 4] +
                          res.pca$x[, 5] +
                          res.pca$x[, 6], 
                        family = binomial)
print(summary(outcome.logistic5))
```

```
## 
## Call:
## glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + res.pca$x[, 
##     2] + res.pca$x[, 3] + res.pca$x[, 4] + res.pca$x[, 5] + res.pca$x[, 
##     6], family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.9956  -0.6834  -0.3927   0.7355   2.2925  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    -0.90808    0.15321  -5.927 3.08e-09 ***
## res.pca$x[, 1]  0.90361    0.11444   7.896 2.88e-15 ***
## res.pca$x[, 2]  0.06140    0.11054   0.555 0.578560    
## res.pca$x[, 3] -0.39560    0.13851  -2.856 0.004289 ** 
## res.pca$x[, 4] -0.18577    0.15467  -1.201 0.229714    
## res.pca$x[, 5] -0.04867    0.17464  -0.279 0.780465    
## res.pca$x[, 6]  0.75741    0.21866   3.464 0.000532 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 402.89  on 313  degrees of freedom
## Residual deviance: 291.06  on 307  degrees of freedom
## AIC: 305.06
## 
## Number of Fisher Scoring iterations: 5
```

```r
df_filtered_train$Out_logmodel_5 <- (((1 / (1 + exp(-cbind(1, res.pca$x[, 1:6]) %*% outcome.logistic5$coefficients))) >= 0.5 ) * 1.0)[, 1]
print(target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_5))
```

```
## $matrix
##        real0 real1
## model0   180    50
## model1    27    57
## 
## $precision
## [1] 0.6785714
## 
## $recall
## [1] 0.5327103
## 
## $F1
## [1] 0.5968586
## 
## $accuracy
## [1] 0.7547771
```


### Модель на 7 гланых компонент


```r
outcome.logistic6 <- glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + 
                          res.pca$x[, 2] +
                          res.pca$x[, 3] +
                          res.pca$x[, 4] +
                          res.pca$x[, 5] +
                          res.pca$x[, 6] +
                          res.pca$x[, 7], 
                        family = binomial)
print(summary(outcome.logistic6))
```

```
## 
## Call:
## glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + res.pca$x[, 
##     2] + res.pca$x[, 3] + res.pca$x[, 4] + res.pca$x[, 5] + res.pca$x[, 
##     6] + res.pca$x[, 7], family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.9531  -0.6856  -0.3827   0.7304   2.2610  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    -0.90957    0.15339  -5.930 3.04e-09 ***
## res.pca$x[, 1]  0.90834    0.11518   7.886 3.12e-15 ***
## res.pca$x[, 2]  0.06283    0.11103   0.566 0.571490    
## res.pca$x[, 3] -0.39065    0.13808  -2.829 0.004667 ** 
## res.pca$x[, 4] -0.19737    0.15640  -1.262 0.206945    
## res.pca$x[, 5] -0.04817    0.17458  -0.276 0.782599    
## res.pca$x[, 6]  0.76520    0.21892   3.495 0.000474 ***
## res.pca$x[, 7]  0.26811    0.25417   1.055 0.291494    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 402.89  on 313  degrees of freedom
## Residual deviance: 289.94  on 306  degrees of freedom
## AIC: 305.94
## 
## Number of Fisher Scoring iterations: 5
```

```r
df_filtered_train$Out_logmodel_6 <- (((1 / (1 + exp(-cbind(1, res.pca$x[, 1:7]) %*% outcome.logistic6$coefficients))) >= 0.5 ) * 1.0)[, 1]
print(target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_6))
```

```
## $matrix
##        real0 real1
## model0   183    50
## model1    24    57
## 
## $precision
## [1] 0.7037037
## 
## $recall
## [1] 0.5327103
## 
## $F1
## [1] 0.606383
## 
## $accuracy
## [1] 0.7643312
```


### Модель на 8 гланых компонент


```r
outcome.logistic7 <- glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + 
                          res.pca$x[, 2] +
                          res.pca$x[, 3] +
                          res.pca$x[, 4] +
                          res.pca$x[, 5] +
                          res.pca$x[, 6] +
                          res.pca$x[, 7] +
                          res.pca$x[, 8], 
                        family = binomial)
print(summary(outcome.logistic7))
```

```
## 
## Call:
## glm(formula = df_filtered_train$Outcome ~ res.pca$x[, 1] + res.pca$x[, 
##     2] + res.pca$x[, 3] + res.pca$x[, 4] + res.pca$x[, 5] + res.pca$x[, 
##     6] + res.pca$x[, 7] + res.pca$x[, 8], family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.8800  -0.6865  -0.3863   0.7187   2.2281  
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)    -0.90990    0.15352  -5.927 3.09e-09 ***
## res.pca$x[, 1]  0.90736    0.11490   7.897 2.85e-15 ***
## res.pca$x[, 2]  0.06438    0.11158   0.577 0.563970    
## res.pca$x[, 3] -0.39399    0.13953  -2.824 0.004747 ** 
## res.pca$x[, 4] -0.19372    0.15696  -1.234 0.217135    
## res.pca$x[, 5] -0.04431    0.17385  -0.255 0.798820    
## res.pca$x[, 6]  0.76354    0.22011   3.469 0.000523 ***
## res.pca$x[, 7]  0.27861    0.25567   1.090 0.275837    
## res.pca$x[, 8] -0.21544    0.27058  -0.796 0.425905    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 402.89  on 313  degrees of freedom
## Residual deviance: 289.30  on 305  degrees of freedom
## AIC: 307.3
## 
## Number of Fisher Scoring iterations: 5
```

```r
df_filtered_train$Out_logmodel_7 <- (((1 / (1 + exp(-cbind(1, res.pca$x[, 1:8]) %*% outcome.logistic7$coefficients))) >= 0.5 ) * 1.0)[, 1]
print(target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_7))
```

```
## $matrix
##        real0 real1
## model0   182    49
## model1    25    58
## 
## $precision
## [1] 0.6987952
## 
## $recall
## [1] 0.5420561
## 
## $F1
## [1] 0.6105263
## 
## $accuracy
## [1] 0.7643312
```


## Графики на обучении


```r
target1 <- target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_1)
target2 <- target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_2)
target3 <- target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_3)
target4 <- target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_4)
target5 <- target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_5)
target6 <- target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_6)
target7 <- target_matrix(df_filtered_train$Outcome, df_filtered_train$Out_logmodel_7)

acc_vec <- c(target1$accuracy,
             target2$accuracy,
             target3$accuracy,
             target4$accuracy,
             target5$accuracy,
             target6$accuracy,
             target7$accuracy)

F1_vec <- c(target1$F1,
            target2$F1,
            target3$F1,
            target4$F1,
            target5$F1,
            target6$F1,
            target7$F1)

prec_vec <- c(target1$precision,
              target2$precision,
              target3$precision,
              target4$precision,
              target5$precision,
              target6$precision,
              target7$precision)

recall_vec <- c(target1$recall,
                target2$recall,
                target3$recall,
                target4$recall,
                target5$recall,
                target6$recall,
                target7$recall)

plot(x = 1:7, y = acc_vec, col = "red", lty = 1, lwd = I(1.5), 
     xlab = "Количество главных компонент",
     ylab = "Качество", 
     main = "Графики качества при обучении логистической регрессии", 
     ylim = c(0.5, 0.8), 
     type = "o",
     pch = 19)
lines(x = 1:7, y = F1_vec, 
      col = "blue", lty = 1, 
      lwd = I(1.5), type = "o",
     pch = 19)
lines(x = 1:7, y = prec_vec, 
      col = "forestgreen", lty = 1, 
      lwd = I(1.5), type = "o",
     pch = 19)
lines(x = 1:7, y = recall_vec, 
      col = "purple", lty = 1, 
      lwd = I(1.5), type = "o",
     pch = 19)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-42-1.png)<!-- -->



```r
res_test.pca <- as.matrix(df_filtered_test[, 1:8]) %*% (as.matrix(res.pca$rotation)) 
res_test.pca <- apply(res_test.pca, 2, function(x) (x - mean(x))/sd(x))
```



```r
df_filtered_test$Out_logmodel_1 <- (((1 / (1 + exp(-cbind(1, res_test.pca[, 1:2]) %*% outcome.logistic$coefficients))) >= 0.5 ) * 1.0)[, 1]
df_filtered_test$Out_logmodel_2 <- (((1 / (1 + exp(-cbind(1, res_test.pca[, 1:3]) %*% outcome.logistic2$coefficients))) >= 0.5 ) * 1.0)[, 1]
df_filtered_test$Out_logmodel_3 <- (((1 / (1 + exp(-cbind(1, res_test.pca[, 1:4]) %*% outcome.logistic3$coefficients))) >= 0.5 ) * 1.0)[, 1]
df_filtered_test$Out_logmodel_4 <- (((1 / (1 + exp(-cbind(1, res_test.pca[, 1:5]) %*% outcome.logistic4$coefficients))) >= 0.5 ) * 1.0)[, 1]
df_filtered_test$Out_logmodel_5 <- (((1 / (1 + exp(-cbind(1, res_test.pca[, 1:6]) %*% outcome.logistic5$coefficients))) >= 0.5 ) * 1.0)[, 1]
df_filtered_test$Out_logmodel_6 <- (((1 / (1 + exp(-cbind(1, res_test.pca[, 1:7]) %*% outcome.logistic6$coefficients))) >= 0.5 ) * 1.0)[, 1]
df_filtered_test$Out_logmodel_7 <- (((1 / (1 + exp(-cbind(1, res_test.pca[, 1:8]) %*% outcome.logistic7$coefficients))) >= 0.5 ) * 1.0)[, 1]

target1 <- target_matrix(df_filtered_test$Outcome, df_filtered_test$Out_logmodel_1)
target2 <- target_matrix(df_filtered_test$Outcome, df_filtered_test$Out_logmodel_2)
target3 <- target_matrix(df_filtered_test$Outcome, df_filtered_test$Out_logmodel_3)
target4 <- target_matrix(df_filtered_test$Outcome, df_filtered_test$Out_logmodel_4)
target5 <- target_matrix(df_filtered_test$Outcome, df_filtered_test$Out_logmodel_5)
target6 <- target_matrix(df_filtered_test$Outcome, df_filtered_test$Out_logmodel_6)
target7 <- target_matrix(df_filtered_test$Outcome, df_filtered_test$Out_logmodel_7)
acc_vec <- c(target1$accuracy,
             target2$accuracy,
             target3$accuracy,
             target4$accuracy,
             target5$accuracy,
             target6$accuracy,
             target7$accuracy)
F1_vec <- c(target1$F1,
             target2$F1,
             target3$F1,
             target4$F1,
             target5$F1,
             target6$F1,
             target7$F1)
prec_vec <- c(target1$precision,
             target2$precision,
             target3$precision,
             target4$precision,
             target5$precision,
             target6$precision,
             target7$precision)
recall_vec <- c(target1$recall,
             target2$recall,
             target3$recall,
             target4$recall,
             target5$recall,
             target6$recall,
             target7$recall)
plot(x = 1:7, y = acc_vec, col = "red", lty = 1, lwd = I(1.5), 
     xlab = "Количество главных компонент",
     ylab = "Качество", 
     main = "Графики качества при валидации логистической регрессии", 
     ylim = c(0.2, 1), 
     type = "o",
     pch = 19)
lines(x = 1:7, y = F1_vec, 
      col = "blue", lty = 1, 
      lwd = I(1.5), type = "o",
     pch = 19)
lines(x = 1:7, y = prec_vec, 
      col = "forestgreen", lty = 1, 
      lwd = I(1.5), type = "o",
     pch = 19)
lines(x = 1:7, y = recall_vec, 
      col = "purple", lty = 1, 
      lwd = I(1.5), type = "o",
     pch = 19)
```

![](4bakOutput_files/figure-docx/unnamed-chunk-44-1.png)<!-- -->

```r
target6
```

```
## $matrix
##        real0 real1
## model0    55    17
## model1     0     6
## 
## $precision
## [1] 1
## 
## $recall
## [1] 0.2608696
## 
## $F1
## [1] 0.4137931
## 
## $accuracy
## [1] 0.7820513
```



```r
plot(res_test.pca[, 1:2], col = df_filtered_test$Outcome + 1, pch = 19)
abline(a = outcome.logistic2$coefficients[1] / outcome.logistic2$coefficients[3], 
       b = outcome.logistic2$coefficients[2] / outcome.logistic2$coefficients[3], 
       lty = 2, lwd = I(1.5), col = "blue")
```

![](4bakOutput_files/figure-docx/unnamed-chunk-45-1.png)<!-- -->
## Временной ряд





```r
#rm(list = ls())
```

