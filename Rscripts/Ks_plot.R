# based on Tania-K but simplified

library("ggplot2")
library("dplyr")
library("readr")
library("tidyverse")
library("tidyr")
library("reshape2")
library("dplyr")
library("tools")

#Using base R hist function
pdf("Ks_all_plot.pdf")

FsAll <- read_tsv("data/Fsimplex.tsv")
Fs <- FsAll %>% filter(Ks <= 1)
x=hist(Fs$Ks,
       main="Histogram of Friedmanniomyces simplex Ks",
       xlab="Ks",
       ylab="Frequency",
       las=1,
       100)

FeAll = read_tsv("data/Fendolithicus.tsv")
Fe= FeAll %>% filter(Ks <= 1)

f=hist(Fe$Ks,
       main="Histogram of Friedmanniomyces endolithicus Ks",
       xlab="Ks",
       ylab="Frequency",
       las=1,
       100)

HwAll=read_tsv("data/Hwer.tsv")
Hw=HwAll %>% filter(Ks <=1)
h=hist(Hw$Ks,
       main="Histogram of Hortaea werneckii Ks",
       xlab="Ks",
       ylab="Frequency",
       las=1,
       100)

dev.off()

#I wanted to work with ggplot here to get nicer figures.
KsPlotFile = "Ks_ggplot.all_plot.pdf"

KsData = tibble( ~Fsimplex      = Fs,
                 ~Fendolithicus = Fe,
                 ~Hwerneckii    = Hw)

ggplot(data=s,aes(KaKs)) + geom_histogram(binwidth=0.01,aes(fill=..count..), alpha = .8) + labs(title="Ks Frequency of Ancestral Duplicated Genes for Friedmanniomyces simplex", x="Frequencies", y="Count of Frequencies") + scale_fill_gradient("Count", low="green", high="red") + theme_classic()
#qplot(s$KaKs, geom="histogram")

e=read.csv("Fendolithicus.tsv", header=TRUE)
e=subset(e,KaKs<1.0)
Fendo=ggplot(data=e,aes(KaKs)) + geom_histogram(binwidth=0.02,aes(fill=..count..), alpha = .8) + labs(title="Ks Frequency of Ancestral Duplicated Genes for Friedmanniomyces endolithicus", x="Frequencies", y="Count of Frequencies") + scale_fill_gradient("Count", low="green", high="red") + theme_classic()

w=read.csv("Hwer.tsv", header=TRUE)
w=subset(w,KaKs<1.0)
Hwer=ggplot(data=w,aes(KaKs)) + geom_histogram(binwidth=0.02,aes(fill=..count..), alpha = .8) + labs(title="Ks Frequency of Ancestral Duplicated Genes for Hortaea werneckii", x="Frequencies", y="Count of Frequencies") + scale_fill_gradient("Count", low="green", high="red") + theme_classic()

dev.off()


pdf("Ks_Facet_ggplot.all_plot.pdf")

#Take combined dataset and create visuals.
all=read.csv("all.tsv", sep="\t", header = TRUE, dec = ".", na.strings = c("-nan"), stringsAsFactors=FALSE) #added stringsAsFactors because of factors error.
gg <- melt(all) #molten data
gg=subset(all,F.endolithicus<1.0 & F.simplex<1.0 & H.werneckii<1.0) #get the smaller values
gg_long <- gg %>% gather(strains, frequency, F.endolithicus:H.werneckii) #gotta make this data long to have only TWO variables. https://stackoverflow.com/questions/61068031/error-stat-count-can-only-have-an-x-or-y-aesthetic 

gg_long$strains <-as.factor(as.character(gg_long$strains))
gg_long$frequency <-as.numeric(as.character(gg_long$frequency)) #making sure data is numbers
gg_long <- subset(gg_long, !is.na(frequency)) #lots of empty cells, remove with this.

#this one gets them facing the right way
plot = ggplot(data=gg_long, aes(strains, frequency), fill=count) + geom_bar(width=0.5, alpha = .8, stat = 'identity')

#this one is horizontal
plot = ggplot(data=gg_long, aes(frequency, strains), fill=count) + geom_bar(width=0.5, alpha = .8, stat = 'identity') 

plot(plot)
#after_stat

#KaKs_grid=plot + facet_grid(vars(strains), scales = "free")
KaKs_grid=plot + facet_grid((strains ~ .), scales = "free")
plot(KaKs_grid)
dev.off()
