---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---



## Loading and preprocessing the data

Here I'm using the "readr" package to read the data which handles most of the required steps to clean the data.


```r
library(readr)
library(tidyverse)
if (!file.exists("activity.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip", "activity.zip")
}
df <- read_csv("activity.zip")
```

Now let'a take a look at the data:


```r
dim(df)
```

```
## [1] 17568     3
```

```r
head(df)
```

```
## # A tibble: 6 × 3
##   steps date       interval
##   <dbl> <date>        <dbl>
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

```r
summary(df)
```

```
##      steps             date               interval     
##  Min.   :  0.00   Min.   :2012-10-01   Min.   :   0.0  
##  1st Qu.:  0.00   1st Qu.:2012-10-16   1st Qu.: 588.8  
##  Median :  0.00   Median :2012-10-31   Median :1177.5  
##  Mean   : 37.38   Mean   :2012-10-31   Mean   :1177.5  
##  3rd Qu.: 12.00   3rd Qu.:2012-11-15   3rd Qu.:1766.2  
##  Max.   :806.00   Max.   :2012-11-30   Max.   :2355.0  
##  NA's   :2304
```

We can see there are two months of data, with some NA values in it. For now we'll leave them be.


## What is mean total number of steps taken per day?

Now we draw a plot of total number of steps taken each.


```r
dfDaily <- df %>%
  group_by(date) %>%
  summarise(total = sum(steps))

meanSteps <- mean(dfDaily$total, na.rm = TRUE)
medianSteps <- median(dfDaily$total, na.rm = TRUE)

ggplot(dfDaily) +
  geom_histogram(aes(x = total), bins = 40) +
  geom_vline(xintercept = meanSteps, color = "red") +
  geom_vline(xintercept = medianSteps, color = "blue")
```

![](./figure/daily-1.png)<!-- -->

We can see some missing lines in the graph.

Calculated mean is: 10766 and the meidan is: 10765.

And we can see that the mean and median are very close.

## What is the average daily activity pattern?


```r
df %>%
  group_by(interval) %>%
  summarise(mean = mean(steps, na.rm = T)) %>%
  ggplot(aes(x = interval, y = mean)) +
  geom_line() +
  geom_point(size = 0.5) +
  scale_x_continuous(n.breaks = 23) +
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5)) +
  stat_smooth(method = "lm", formula = y ~ 1, se = FALSE) +
  labs(x = "Time", y = "Mean steps", title = "Average steps in each interval")
```

![](./figure/intervals-1.png)<!-- -->

And for finding the time interval where the most activity is in average:


```r
averages <- df %>%
  group_by(interval) %>%
  summarise(mean = mean(steps, na.rm = T))

max <- averages[which.max(averages$mean), ]
max
```

```
## # A tibble: 1 × 2
##   interval  mean
##      <dbl> <dbl>
## 1      835  206.
```

And the code gices us the answer is: 835.

## Imputing missing values

There are a total of 2304 missing values in the data whcih is 
**13%** 
of the data.

For imputing the NA's I'll simply use the mean of that time interval.


```r
df2 <- df %>%
  group_by(interval) %>%
  mutate(steps = ifelse(is.na(steps), mean(steps, na.rm = T), steps))
```

Now we have df2 with no NA's.


```r
dfDaily <- df2 %>%
  group_by(date) %>%
  summarise(total = sum(steps))

meanSteps <- mean(dfDaily$total, na.rm = TRUE)
medianSteps <- median(dfDaily$total, na.rm = TRUE)

ggplot(dfDaily) +
  geom_histogram(aes(x = total), bins = 40) +
  geom_vline(xintercept = meanSteps, color = "red") +
  geom_vline(xintercept = medianSteps, color = "blue")
```

![](./figure/histogram-1.png)<!-- -->

Since we have replaced the NA's with the mean, we can see that the plot does not change so much. In fact, just some bars have a bit higher count and thats all.

## Are there differences in activity patterns between weekdays and weekends?

With this code we will add a column indicating weekday and weekends.

```r
df <- df %>%
  mutate(weekday = ifelse(strftime(date, "%a") == "Sat" | strftime(date, "%a") == "Sun", "weekend", "weekday")) %>%
  mutate(across(weekday, as.factor))

summary(df$weekday)
```

```
## weekday weekend 
##   12960    4608
```

Now let's plot average step taken in each time interval for the two categories:


```r
df %>%
  group_by(interval, weekday) %>%
  summarise(mean = mean(steps, na.rm = T)) %>%
  ggplot(aes(x = interval, y = mean)) +
  geom_line() +
  geom_point(size = 0.5) +
  facet_grid(rows = vars(weekday)) +
  scale_x_continuous(n.breaks = 23) +
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5)) +
  stat_smooth(method = "lm", formula = y ~ 1, se = FALSE) +
  labs(x = "Time", y = "Mean steps", title = "Average steps in each interval")
```

![](./figure/weekend-1.png)<!-- -->
