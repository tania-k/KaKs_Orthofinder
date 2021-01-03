# based on Tania-K but simplified

library(ggplot2)
library(readr)
library(dplyr)
library(tidyverse)
library(RColorBrewer)
library(cowplot)

#Using base R hist function
pdf("plots/Ks_histogram1.pdf")

FsAll <- read_tsv("data/Friedmanniomyces_simplex_CCFEE_5184.KaKs.tsv")
Fs2 <-FsAll %>% filter(dN <= 1)
Fs <- FsAll %>% filter(dS <= 1)
hist(Fs$dS,
       main="Histogram of Friedmanniomyces simplex Ks",
       xlab="Ks",
       ylab="Count",
       las=1,
       100)

FeAll = read_tsv("data/Friedmanniomyces_endolithicus_CCFEE_5311.KaKs.tsv")
Fe2=FeAll %>% filter(dN <= 1)
Fe= FeAll %>% filter(dS <= 1)

hist(Fe$dS,
       main="Histogram of Friedmanniomyces endolithicus Ks",
       xlab="Ks",
       ylab="Count",
       las=1,
       100)

HwAll=read_tsv("data/Hortaea_werneckii_EXF-2000-UCR.KaKs.tsv")
Hw2=HwAll%>% filter(dN <=1)
Hw=HwAll %>% filter(dS <=1)
hist(Hw$dS,
       main="Histogram of Hortaea werneckii Ks",
       xlab="Ks",
       ylab="Count",
       las=1,
       100)

dev.off()

#I wanted to work with ggplot here to get nicer figures.
KsPlotFile = "plots/Ks_histogram2.pdf"

p1 <- ggplot(Fs,aes(x=dS)) + geom_histogram(binwidth=0.01,aes(fill=..count..), alpha = .8) + labs(title="Ks Frequency Friedmanniomyces simplex", x="Ks", y="Count") +
        scale_fill_gradient("Count", low="green", high="red") + theme_bw()


p2 <- ggplot(Fe,aes(x=dS)) + geom_histogram(binwidth=0.01,aes(fill=..count..), alpha = .8) + labs(title="Ks Frequency Friedmanniomyces endolithicus", x="Ks", y="Count") +
        scale_fill_gradient("Count", low="green", high="red") + theme_bw()

p3 <- ggplot(Hw,aes(x=dS)) + geom_histogram(binwidth=0.01,aes(fill=..count..), alpha = .8) + labs(title="Ks Frequency Hortaea werneckii ", x="Ks", y="Count") +
        scale_fill_gradient("Count", low="green", high="red") + theme_bw()

gridplot = plot_grid(p1, p2, p3, labels = c('A', 'B', 'C'), label_size = 12)
ggsave(KsPlotFile,gridplot,width=10)

comboData <- bind_rows(
        Fs %>% select(dS) %>% rename(Fsimplex = dS) %>% gather("species","dS"),
        Fe %>% select(dS) %>% rename(Fendolithicus = dS) %>% gather("species","dS"),
        Hw %>% select(dS) %>% rename(Hwerneckii = dS) %>% gather("species","dS")
)

KsPlotBarplot =  "plots/Ks_boxplot.pdf"
p<- ggplot(comboData,aes(x=species,y=dS,color=species)) + geom_boxplot(outlier.shape = NA) + geom_jitter(size = 0.6,width=0.2,alpha=0.7,shape=16) + 
        labs(title="Boxplot of Ks values in duplicated gene pairs", x="Species", y="Ks") + scale_color_brewer(palette='Set1') + theme_bw()
ggsave(KsPlotBarplot,p,width=12) 


KaPlotFile = "plots/Ka_histogram.pdf"
d1 <- ggplot(Fs2,aes(x=dN)) + geom_histogram(binwidth=0.01,aes(fill=..count..), alpha = .8) + labs(title="Ka Frequency Friedmanniomyces simplex", x="Ka", y="Frequency") +
        scale_fill_gradient("Count", low="green", high="red") + theme_classic()


d2 <- ggplot(Fe2,aes(x=dN)) + geom_histogram(binwidth=0.01,aes(fill=..count..), alpha = .8) + labs(title="Ka Frequency Friedmanniomyces endolithicus", x="Ks", y="Frequency") +
        scale_fill_gradient("Count", low="green", high="red") + theme_classic()

d3 <- ggplot(Hw2,aes(x=dN)) + geom_histogram(binwidth=0.01,aes(fill=..count..), alpha = .8) + labs(title="Ka Frequency Hortaea werneckii ", x="Ka", y="Frequency") +
        scale_fill_gradient("Count", low="green", high="red") + theme_classic()

gridplot = plot_grid(d1, d2, d3, labels = c('A', 'B', 'C'), label_size = 12)
ggsave(KaPlotFile,gridplot,width=10)

comboData <- bind_rows(
        Fs2 %>% select(dN) %>% rename(Fsimplex = dN) %>% gather("species","dN"),
        Fe2 %>% select(dN) %>% rename(Fendolithicus = dN) %>% gather("species","dN"),
        Hw2 %>% select(dN) %>% rename(Hwerneckii = dN) %>% gather("species","dN")
)

KaPlotBarplot =  "plots/Ka_boxplot.pdf"
d<- ggplot(comboData,aes(x=species,y=dN,color=species)) + geom_boxplot(outlier.shape = NA) + geom_jitter(size = 0.6,width=0.2,alpha=0.7,shape=16) + 
        labs(title="Boxplot of Ka values in duplicated gene pairs", x="Species", y="Ka") + scale_color_brewer(palette='Set1')
ggsave(KaPlotBarplot,d,width=12) 


KsPlotBarplot =  "plots/Ks_boxplot_shortaln.pdf"
MAXLEN = 100
comboData <- bind_rows(
        Fs %>% filter(LENGTH <= MAXLEN) %>% select(dS) %>% rename(Fsimplex = dS) %>% gather("species","dS"),
        Fe %>% filter(LENGTH <= MAXLEN) %>% select(dS) %>% rename(Fendolithicus = dS) %>% gather("species","dS"),
        Hw %>% filter(LENGTH <= MAXLEN) %>% select(dS) %>% rename(Hwerneckii = dS) %>% gather("species","dS"),
)

p<- ggplot(comboData,aes(x=species,y=dS,color=species)) + geom_boxplot(outlier.shape = NA) + geom_jitter(size = 0.6,width=0.2,alpha=0.7,shape=16) + 
        labs(title=sprintf("Boxplot of Ks values in duplicated gene pairs with Alignment < %d",MAXLEN), x="Species", y="Ks") + scale_color_brewer(palette='Set1') + theme_bw()
ggsave(KsPlotBarplot,p,width=12) 
p1 <- ggplot(subset(Fs,dS == 0),aes(x=LENGTH)) + geom_histogram(bins=30) + theme_bw() + labs(x="Alignment Length (bp)", title="Boxplot of Alignment Lengths for F. simplex where Ks = 0")
p2 <- ggplot(subset(Fs,dS == 0 & LENGTH < 80),aes(x=LENGTH)) + geom_histogram(bins=30) + theme_bw() + labs(x="Alignment Length (bp)", title="Boxplot of Alignment Lengths for F. simplex where Ks = 0 & LENGTH < 80")

gridplot = plot_grid(p1, p2, labels = c('A', 'B'), label_size = 12)
ggsave("plots/Fsimplex_AlnLenHisto.pdf",gridplot,width=10)

p1 <- ggplot(Hw,aes(LENGTH, dS)) + geom_point() + theme_bw() + labs(title="H.werneckii dS vs AlnLen")
p2 <- ggplot(Fs,aes(LENGTH,dS)) + geom_point() + theme_bw() + labs(title="Fsimplex dS vs AlnLen")
p3 <- ggplot(Fe,aes(LENGTH,dS)) + geom_point() + theme_bw() + labs(title="Fendolithicus dS vs AlnLen")

gridplot = plot_grid(p1, p2, p3, labels = c('A', 'B', "C"), label_size = 12)
ggsave("plots/AlnLen_vs_Ks.pdf",gridplot,width=10)

