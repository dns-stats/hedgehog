# 
# Copyright 2014 Internet Corporation for Assigned Names and Numbers.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Developed by Sinodun IT (www.sinodun.com)
#

# TODO(refactor): Refactor this code

# Define globals

# Colours
GREY <- "#999999"
ORANGE <- "#E69F00"
SKYBLUE <- "#56B4E9"
GREEN <- "#009E73"
YELLOW <- "#F0E442"
BLUE <- "#0072B2"
VERMILLION <- "#D55E00"
PINK <- "#CC79A7"
BLACK <- "#000000"
GRIDGREY <- "#BFBFBF"
DARKERRED <- "#990F0F"
DARKERORANGEBT <- "#99700F"
DARKERLIMEGREEN <- "#1F990F"
DARKERVIOLET <- "#710F99"
SOFTRED <- "#E67E7E"
SOFTORANGE <- "#E6C77E"
SOFTLIMEGREEN <- "#8AE67E"
SOFTVIOLET <- "#C77EE6"
MODERATERED <- "#CC5252"
MODERATEORANGE <- "#CCA852"
MODERATELIMEGREEN <- "#60CC52"
MODERATEVIOLET <- "#A852CC"
DARKRED <- "#B22D2D"
DARKORANGEBT <- "#B28B2D"
DARKLIMEGREEN <- "#3CB22D"
DARKVIOLET <- "#8B2DB2"

# A colour-blind friendly palette:
 CBPALETTE = c(DARKERRED, DARKERORANGEBT, DARKERLIMEGREEN, DARKERVIOLET,
               SOFTRED, SOFTORANGE, SOFTLIMEGREEN, SOFTVIOLET,
               MODERATERED, MODERATEORANGE, MODERATELIMEGREEN, MODERATEVIOLET,
               DARKRED, DARKORANGEBT, DARKLIMEGREEN, DARKVIOLET)

NCBPALETTE <- length(CBPALETTE)

MINICBPALETTE <- c(DARKERRED, DARKERLIMEGREEN)
NMINICBPALETTE <- length(MINICBPALETTE)

# width and height of ggplot pngs
W <- 940
H <- 600

##################

linePlot <- function(df, f, title, xlabel, ylabel, gvis) {

	if (hh_debug) {
		system('logger -p user.notice In linePlot')
	}
	
    if(gvis == 1){
      # Stupid bug in gvis where the name of the numvar column causes issues with the correct name being diplayed in the legend
      names(df)[names(df)=="y"] <- "yyyyyyyyyyyy"
      # For now we default to the timeline flash chart unless 'svg' is specified by the user
      if (gui_config$www$default_interactive_plot_type == "svg") {
          p <- gvisAnnotationChart(df, numvar="yyyyyyyyyyyy", idvar = "key", datevar = "x", #titlevar="serial",
                                   options=list(
                                                #displayAnnotations=TRUE, annotationsWidth=10, 
                                                legendPosition='newRow', height=540, width=910, colors="['#0072B2','#990F0F','#99700F',
      '#1F990F','#710F99','#E67E7E','#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#0072B2','#990F0F','#99700F','#1F990F',
      '#710F99','#E67E7E','#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#0072B2','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#990F0F','#99700F','#1F990F','#710F99',
      '#E67E7E','#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#0072B2','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#990F0F','#99700F','#1F990F','#710F99','#E67E7E',
      '#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#0072B2','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#990F0F','#99700F',
      '#1F990F','#710F99','#E67E7E','#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#B22D2D','#B28B2D','#3CB22D','#8B2DB2']"))
         
      }else{
          p <- gvisAnnotatedTimeLine(df, numvar="yyyyyyyyyyyy", idvar = "key", datevar = "x", 
                                     options=list(legendPosition='newRow', height=540, width=910, colors="['#0072B2','#990F0F','#99700F',
      '#1F990F','#710F99','#E67E7E','#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#0072B2','#990F0F','#99700F','#1F990F',
      '#710F99','#E67E7E','#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#0072B2','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#990F0F','#99700F','#1F990F','#710F99',
      '#E67E7E','#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#0072B2','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#990F0F','#99700F','#1F990F','#710F99','#E67E7E',
      '#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#0072B2','#B22D2D','#B28B2D','#3CB22D','#8B2DB2','#990F0F','#99700F',
      '#1F990F','#710F99','#E67E7E','#E6C77E','#8AE67E','#C77EE6','#CC5252','#CCA852','#60CC52','#A852CC','#B22D2D','#B28B2D','#3CB22D','#8B2DB2']"))         
      }
      title <- sub("\n", "<br />", title)
      ylabel <- gsub(" +", "&nbsp;", ylabel)
      p$html$chart['divChart'] <- paste("<div style=\"text-align: center; width: 918px; font-family: HelveticaNeue, 
                                                      'Helvetica Neue', Helvetica, Arial, sans-serif;\">", 
                                                       title,
                                        "</div>",
                                        "<div style=\"display: flex; display: -webkit-flex; justify-content:flex-start; width: 918px;\">",  
                                        "<div>", p$html$chart['divChart'], "</div>",
                                        "<div style=\"width: 17px; height: 17px; font-size: small; transform: translateY(200px) rotate(90deg); transform-origin: right top; 
                                              -webkit-transform: translateY(200px) rotate(90deg); -webkit-transform-origin: right top;\">", ylabel, "</div>",
                                        "</div>",
                                        "<div style=\"text-align: center; width: 918px; font-size: small;\">", xlabel, "</div>",
                                       sep="")
      cat(p$html$chart, file=f)
    }else{
      nKeys <- length(unique(df$key))
      df$x <- as.POSIXct(df$x)
      png(f, width = W, height = H)
      p <- ggplot(data=df, aes(x=x, y=y, group=key, colour=key)) +
                  geom_line() +
                  labs(title=title, x=xlabel, y=ylabel) +
                  scale_x_datetime(expand=c(0.01,0)) +
                  scale_y_continuous(expand=c(0.01,0), labels = comma) +
                  theme_bw() +
                  theme(panel.grid.major = element_line(colour = GRIDGREY), 
                        panel.grid.minor = element_line(colour = GRIDGREY, linetype = "dotted")) +
                  guides(col = guide_legend(nrow = 20, byrow = TRUE, override.aes = list(size=3)))
      if (nKeys <= NCBPALETTE) {
        p <- p + scale_colour_manual(values=CBPALETTE)
      }

      print(p)
      dev.off()

      fstack <- sub(".png", "-stack.png", f)
      png(fstack, width = W, height = H)
      ps <- ggplot(data=df, aes(x=x, y=y, fill=key, order=key)) + 
                   geom_area(stat="identity") +
                   labs(title=title, x=xlabel, y=ylabel) +
                   scale_x_datetime(expand=c(0.01,0)) + 
                   scale_y_continuous(expand=c(0,0), labels = comma) +
                   theme_bw() +
                   theme(panel.grid.major = element_line(colour = GRIDGREY), 
                         panel.grid.minor = element_line(colour = GRIDGREY, linetype = "dotted")) +
                   guides(fill = guide_legend(nrow = 20, byrow = TRUE))

      if (nKeys <= NCBPALETTE) {
        ps <- ps + scale_fill_manual(values=CBPALETTE)
      }
      print(ps)
      dev.off()

      flog <- sub(".png", "-log.png", f)
      png(flog, width = W, height = H)
      p <- p + scale_y_log10() + ylab(paste("log(",ylabel,")",sep=""))
      print(p)
      dev.off()
    }
}

barPlot <- function(df, f, title, xlabel, ylabel, gvis, vertical=0, small=1) {

	if (hh_debug) {
		system('logger -p user.notice In barPlot')
	}

    if(gvis == 1){
      title <- sub("\n", " ", title)
      if(vertical == 1){
          p <- gvisColumnChart(df, xvar='x', yvar='y', 
                            options=list(legend="none", title=title, height=600, width=940,
                                         vAxis=paste("{title:'",ylabel,"',textStyle:{fontSize:'10'}}", sep=""), 
                                         hAxis=paste("{title:'",xlabel,"',textStyle:{fontSize:'14'}}", sep=""), 
                                         chartArea="{left:80,top:50,width:\"80%\",height:\"80%\"}"))
      }else{
        if(small==1){
          p <- gvisBarChart(df, xvar='x', yvar='y',
                            options=list(legend="none", title=title, height=600, width=940,
                                         vAxis=paste("{title:'",xlabel,"',textStyle:{fontSize:'10'}}", sep=""), 
                                         hAxis=paste("{title:'",ylabel,"',textStyle:{fontSize:'14'}}", sep=""), 
                                         chartArea="{left:80,top:50,width:\"88%\",height:\"80%\"}"))
        } else {
          p <- gvisBarChart(df, xvar='x', yvar='y',
                            options=list(legend="none", title=title, height=600, width=940,
                                         vAxis=paste("{title:'",xlabel,"')", sep=""), 
                                         hAxis=paste("{title:'",ylabel,"', textStyle:{fontSize:'14'}}", sep=""), 
                                         chartArea="{left:80,top:50,width:\"88%\",height:\"80%\"}"))
        }
      }
      cat(p$html$chart,file=f)
    }else{
      if (vertical == 0) {
          df$x <- factor(df$x, levels=rev(as.character(df$x)))
      }
      png(f, width = W, height = H)

      p <- ggplot(data=df, aes(x=x, y=y)) +
                  geom_bar(fill=GREY, colour=GREY, stat="identity") +
                  labs(title=title, x=xlabel, y=ylabel) +
                  theme_bw() + scale_y_continuous(expand=c(0,0), labels = comma) +
                  theme(panel.grid.major.y = element_line(colour = GRIDGREY), 
                        panel.grid.minor.y = element_line(colour = GRIDGREY, linetype = "dotted"), 
                        panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())

      if (vertical == 0) {
        p <- p +
             coord_flip() +
             theme(panel.grid.major.x = element_line(colour = GRIDGREY), 
                   panel.grid.minor.x = element_line(colour = GRIDGREY, linetype = "dotted"), 
                   panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank())
      }

      print(p)
      dev.off()
    }
}

stackedBarPlot <- function(df, f, title, xlabel, ylabel, gvis, pltnm, scalex="discrete", vertical=0, gbar_width=0) {

	if (hh_debug) {
		system('logger -p user.notice In stackedBarPlot')
	}
	
    if(gvis == 1){
      title <- sub("\n", " ", title)
      de <- cast(df, x ~ key, value='y', fun.aggregate=sum)
      y_var <- tail(colnames(de),-1)
      if(vertical == 1){
          if (gbar_width == 0) {
              p <- gvisColumnChart(de, xvar='x', yvar=y_var,
                                   options=list(isStacked=TRUE, title=title, height=600, width=940,
                                                vAxis=paste("{title:'", ylabel,"'}", sep=""), 
                                                hAxis=paste("{title:'", xlabel,"', textStyle:{fontSize:'14'}}", sep=""), 
                                                legend=paste("{textStyle:{fontSize:'12'}}", sep=""),
                                                chartArea="{left:80,top:50,width:\"75%\",height:\"80%\"}"))
          } else {
              p <- gvisColumnChart(de, xvar='x', yvar=y_var,
                                   options=list(isStacked=TRUE, title=title, height=600, width=940,
                                                vAxis=paste("{title:'", ylabel,"'}", sep=""), 
                                                hAxis=paste("{title:'", xlabel,"', textStyle:{fontSize:'14'}}", sep=""), 
                                                legend=paste("{textStyle:{fontSize:'12'}}", sep=""), 
                                                chartArea="{left:80,top:50,width:\"75%\",height:\"80%\"}", 
                                                bar=paste("{groupWidth:", gbar_width,"}", sep="")))
          }
      }else{
          # Need to order the table before passing it to gviz
          # write.table(de, file="/temp/de.out")
          de$total <- rowSums(de, na.rm=TRUE);
          de <-arrange(de, desc(total));
          de$total <- NULL
          jscode <- "alert('Hello world');"
          p <- gvisBarChart(de, xvar='x', yvar=y_var,
                            options=list(isStacked=TRUE, title=title, height=600, width=940,
                                         vAxis=paste("{title:'",xlabel,"',textStyle:{fontSize:'12'}}", sep=""), 
                                         hAxis=paste("{title:'",ylabel,"',textStyle:{fontSize:'14'}}", sep=""), 
                                         legend=paste("{textStyle:{fontSize:'12'}}", sep=""), 
                                         chartArea="{left:80,top:50,width:\"75%\",height:\"80%\"}",
                                         gviz.listener.jscode=jscode))
      }
      cat(p$html$chart,file=f)
    }else{
      if (scalex == "discrete") {
        df$x <- factor(df$x, levels=rev(as.character(df$x)))
        dfmelt <- melt(df)
        de <- cast(dfmelt, x ~ key, value='value')
        de$total <- rowSums(de, na.rm=TRUE)
        dorder2 <- de[with(de, order(total)), ]
        x_order <- dorder2$x
        df$x <- factor(df$x, levels=x_order)
      }

      nKeys <- length(unique(df$key))
      png(f, width = W, height = H)

      p <- ggplot(data=df, aes(x=x, y=y, fill=key, order=key)) + 
                  geom_bar(stat="identity") + 
                  labs(title=title, x=xlabel, y=ylabel) + 
                  scale_y_continuous(expand=c(0,0), labels = comma) +
                  theme_bw() +
                  theme(panel.grid.major = element_line(colour = GRIDGREY), 
                        panel.grid.minor = element_line(colour = GRIDGREY, linetype = "dotted")) +
                  guides(fill = guide_legend(nrow = 20, byrow = TRUE))

      if (nKeys <= NCBPALETTE) {
        p <- p + scale_fill_manual(values=CBPALETTE)
      }

      if (scalex == "continuous") {
        p <- p +
             scale_x_continuous(expand=c(0.01,0), labels = comma)
      }

      if (vertical == 0) {
        p <- p +
             coord_flip() +
             theme(panel.grid.major.x = element_line(colour = GRIDGREY), 
                   panel.grid.minor.x = element_line(colour = GRIDGREY, linetype = "dotted"), 
                   panel.grid.major.y = element_blank(), 
                   panel.grid.minor.y = element_blank(),
                   axis.text.y=element_text(size=14))
      } else {
          p <- p +
               geom_bar(width=1, stat="identity")
      }

      if (pltnm == 'rcode_vs_replylen') {
          p <- p + 
               scale_x_continuous(expand=c(0.01,0), labels = comma, limits=c(0,1000))
      }

      if (pltnm == 'rcode_vs_replylen_big') {
          xmin <- 1000
          p <- p + 
               scale_x_continuous(expand=c(0.01,0), labels = comma, limits=c(xmin,max(df$x) + 100))
      }

      print(p)
      dev.off()
    }
}

stackedAreaPlot <- function(df, f, title, xlabel, ylabel, gvis) {

	if (hh_debug) {
		system('logger -p user.notice In stackedAreaPlot')
	}
	
    if(gvis == 1){
      title <- sub("\n", " ", title)
      de <- cast(df, x ~ key, value='y', fun.aggregate=sum)
      y_var <- tail(colnames(de),-1)
      p <- gvisAreaChart(de, xvar='x', yvar=y_var, 
                         options=list(isStacked=TRUE, title=title, height=600, width=940, 
                                      vAxis=paste("{title:'",ylabel,"'}", sep=""), 
                                      hAxis=paste("{title:'",xlabel,"'}", sep=""), 
                                      legend=paste("{textStyle:{fontSize:'12'}}"), 
                                      chartArea="{left:80,top:50,width:\"75%\",height:\"80%\"}"))
      cat(p$html$chart,file=f)
    }else{
      	df$x <- as.POSIXct(df$x)
      nKeys <- length(unique(df$key))
      png(f, width = W, height = H)

      p <- ggplot(data=df, aes(x=x, y=y, fill=key, order=key)) + 
                  geom_area(stat="identity") + 
                  labs(title=title, x=xlabel, y=ylabel) +
                  scale_x_datetime(expand=c(0.01,0)) +
                  scale_y_continuous(expand=c(0,0), labels = comma) + 
                  theme_bw() +
                  theme(panel.grid.major = element_line(colour = GRIDGREY), 
                        panel.grid.minor = element_line(colour = GRIDGREY, linetype = "dotted")) +
                  guides(fill = guide_legend(nrow = 20, byrow = TRUE))

      if (nKeys <= NCBPALETTE) {
        p <- p + scale_fill_manual(values=CBPALETTE)
      }

      print(p)
      dev.off()
    }
}

facetedBarPlot <- function(df, f, title, xlabel, ylabel, gvis, bar_width) {

	if (hh_debug) {
		system('logger -p user.notice In facetedBarPlot')
	}
	
    if(gvis == 1){
        stackedBarPlot(df, f, title, xlabel, ylabel, gvis, pltnm = 'N/A', vertical = 1, gbar_width = bar_width)
    }else{
        nKeys <- length(unique(df$key))
        png(f, width = W, height = H)

        p <- ggplot(data=df, aes(x=x, y=y)) + 
                    geom_bar(stat="identity", width=bar_width, fill=DARKERRED) +
                    facet_grid(key ~ ., scales="free") + 
                    labs(title=title, x=xlabel, y=ylabel) + 
                    theme_bw() +
                    theme(panel.grid.major = element_line(colour = GRIDGREY), 
                          panel.grid.minor = element_line(colour = GRIDGREY, linetype = "dotted")) +
                    guides(fill = guide_legend(nrow = 20, byrow = TRUE))

        if (nKeys <= NCBPALETTE) {
          p <- p + scale_fill_manual(values=CBPALETTE)
        }

        print(p)
        dev.off()
    }
}

facetedLinePlot <- function(df, f, title, xlabel, ylabel, gvis) {

	if (hh_debug) {
		system('logger -p user.notice In facetedLinePlot')
	}

    if(gvis == 1){
	    # fix up the legends to work with svg
	    rkey_svg <- sub("dns-(.*-.*-).*-(.*)", "\\1\\2", df$key)
	    rkey_svg <- sub("responses", "resp", rkey_svg)
	    df["key"] <- rkey_svg
        linePlot(df, f, title, xlabel, ylabel, gvis)
    }else{
        nKeys <- length(unique(df$key))
        png(f, width = W, height = H)
        df$x <- as.POSIXct(df$x)
        rkey1 <- sub("dns-(.*)-.*-.*-(.*)", "\\1-\\2", df$key)
        df["rkey"] <- rkey1
        rkey2 <- sub("dns-.*-(.*)-.*-.*", "\\1", df$key)
        df["key"] <- rkey2

        p <- ggplot(data=df, aes(x=x, y=y, group=key, colour=key)) +
                    geom_jitter(position=position_jitter(width=2)) +
                    geom_line() +
                    labs(title=title, x=xlabel, y=ylabel) +
                    facet_grid(rkey ~ ., scales="free") +
                    scale_x_datetime(expand=c(0.01,0)) +
                    scale_y_continuous(expand=c(0.01,0), labels=comma) +
                    theme_bw() +
                    theme(panel.grid.major = element_line(colour = GRIDGREY), 
                          panel.grid.minor = element_line(colour = GRIDGREY, linetype = "dotted")) +
                    guides(col = guide_legend(nrow = 20, byrow = TRUE, override.aes=list(size=3)))

        nKeys = length(unique(df$key))
        if (nKeys <= NMINICBPALETTE) {
            p <- p + scale_colour_manual(values=MINICBPALETTE)
        }
        else if (nKeys <= NCBPALETTE) {
          p <- p + scale_colour_manual(values=CBPALETTE)
        }

        print(p)
        dev.off()
    }
}

facetedDiffLinePlot <- function(df, f, title, xlabel, ylabel, gvis) {

    if (hh_debug) {
	    system('logger -p user.notice In facetedDiffLinePlot')
    }

    nKeys <- length(unique(df$key))
    df$x <- as.POSIXct(df$x)
    rkey1 <- sub("dns-(.*)-.*-.*-(.*)", "\\1-\\2", df$key)
    png(f, width=W, height=H)
    df["rkey"] = rkey1

    dfx <- dplyr::arrange(df, x, rkey, desc(key))
    df1 <- aggregate(dfx$y, by=list(x2=dfx$x, rkey=dfx$rkey), FUN=diff)
    df1 <- plyr::rename(df1,c("x"="y", "x2"="x", "rkey"="key"))
    if (gvis == 1) {
        linePlot(df1, f, title, xlabel, ylabel, gvis)
    } else {

        p <- ggplot(data=df1, aes(x=x, y=y, group=key)) +
                    geom_line(colour=DARKERRED) +
                    labs(title=title, x=xlabel, y="Difference Between Number of Queries and Responses/min") +
                    facet_grid(key ~ ., scales="free") +
                    scale_x_datetime(expand=c(0.01,0)) +
                    scale_y_continuous(expand=c(0.01,0), labels=comma) +
                    theme_bw() +
                    theme(panel.margin=grid::unit(3,"mm"), 
                          panel.grid.major=element_line(colour=GRIDGREY),
                          panel.grid.minor=element_line(colour=GRIDGREY, linetype="dotted")) +
                    guides(col=guide_legend(nrow=20, byrow=TRUE, override.aes=list(size=3)))
        if (nKeys <= NCBPALETTE) {
            p <- p + scale_colour_manual(values=CBPALETTE)
        }
        print(p)
        dev.off()
    }
}

scatterPlot <- function(df, f, title, xlabel, ylabel, gvis) {

	if (hh_debug) {
		system('logger -p user.notice In barPlot')
	}

    if(gvis == 1){
      title <- sub("\n", " ", title)
      df$key <- NULL
	  df$x <- NULL
      df$serial <- as.integer(df$serial)
      df <- df[,c("serial", "y")]
      p <- gvisScatterChart(df, 
                        options=list(legend="none", title=title, height=600, width=940,
                                     vAxis=paste("{title:'",ylabel,"',textStyle:{fontSize:'10'}}", sep=""), 
                                     hAxis=paste("{title:'",xlabel,"',textStyle:{fontSize:'14'}}", sep=""), 
                                     chartArea="{left:80,top:50,width:\"80%\",height:\"80%\"}"))
    }
      cat(p$html$chart,file=f)
}


geomap <- function(df, f, title, xlabel, ylabel, gvis) {

	if (hh_debug) {
		system('logger -p user.notice In geomap')
    msg <- paste('logger -p user.notice file =', f)
    system(msg)
	}
  if(gvis == 1){
    title <- sub("\n", " ", title)
    p <- gvisMap(df, locationvar='location', tipvar='sum', 
                 options=list(colorAxis="{colors:['#FF0000', '#00FF00']}", displayMode='regions', height=600, width=940,
                              chartArea="{left:80,top:50,width:\"80%\",height:\"80%\"}"))
    cat(p$html$chart,file=f)
  }
}

geochart <- function(df, f, title, xlabel, ylabel, gvis) {

	if (hh_debug) {
		system('logger -p user.notice In geomap')
    msg <- paste('logger -p user.notice file =', f)
    system(msg)
	}
  if(gvis == 1){
    title <- sub("\n", " ", title)
# colorAxis="{colors:['#FF0000', '#00FF00']}",    
          js.code <- "alert('Hello');"
    p <- gvisGeoChart(df, locationvar='location', colorvar='sum', 
                      options=list(displayMode='regions', height=600, width=940,
                                   chartArea="{left:80,top:50,width:\"80%\",height:\"80%\"}"),
                                   gvis.listener.jscode=jscode)
    cat(p$html$chart,file=f)
  }
}

getStmntParameters <- function(dsccon, dbdrv, dd_pltid, prepStmtNm, srvrid, start, stop) {

	# Retrieving the datasets ids for the plot
	if (!(prepStmnt("getdatasetids", dsccon))) {
		return
	}

	sql <- paste("EXECUTE ", "getdatasetids", "('", dd_pltid, "');", sep="")

	dataframe <- dbGetDataFrame(dbdrv, dsccon, dbconstr, sql)

	if (is.null(dataframe) || ncol(dataframe) != 1) {
		return
	}

	# Preparing the statement parameters with 1 or 2 datasets for the plot
	ds_ids_list <- gsub("[{}]","",dataframe[1])
	list <- strsplit(ds_ids_list,",")
	num_ds_ids <- length(list[[1]])
	 
	if ( num_ds_ids == 1 ) {
		sql <- paste("EXECUTE ",prepStmtNm, "(", srvrid, ", '", list[[1]][1], "', timestamptz '", start, "', timestamptz '", stop, "');", sep="")
	}
	else if ( num_ds_ids == 2 ) {
		sql <- paste("EXECUTE ",prepStmtNm, "(", srvrid, ", '", list[[1]][1], "', '", list[[1]][2], "', timestamptz '", start, "', timestamptz '", stop, "');", sep="")
	}
	else {
		return
	}    
	return(sql)
}

generateYaml <- function(dsccon) {

	if (hh_debug) {
	    system('logger -p user.notice In generateYaml')
    }

	# Only allow yaml calls from local host in this implementation
	# as this is only called from the cron script for now
    if (SERVER$hostname != "localhost") 
		return(FALSE)
		
	# Determine the plot being requested
    prepStmnt("getpltdetails", dsccon)
    pltdetails <- dbGetDataFrame(dbdrv, dsccon, dbconstr, paste("EXECUTE getpltdetails(", GET$pltid, ");", sep=""))
    
    if (is.null(pltdetails)) {
        return(FALSE)
    }   
	pltnm     <- pltdetails$name

    # Nasty hard coding because the traffic size plot is split into two
	if (pltnm == 'traffic_sizes_small') {
		pltnm = 'traffic_sizes'
	}	
	if (pltnm == 'traffic_sizes_big') {
		return(TRUE)
	} 
	
    prepStmnt("getsrvr_display_name_from_id", dsccon)
    server_display_name <- dbGetDataFrame(dbdrv, dsccon, dbconstr, paste("EXECUTE getsrvr_display_name_from_id(", GET$svrid, ");", sep=""))

	# Load the config file with the rssac spec in it 
    rssac_config = yaml.load_file(paste(hh_config$directories$web_conf, "/rssac.yaml", sep=""))

	# Define the base parameters for the yaml
	metric <- sub("_", "-", pltnm)	
	metric_data <- rssac_config$metric[[metric]]
	# If the node looks like a root server, then set the service from the yaml
	# otherwise, just use the server name
	server_name_lc <- tolower(server_display_name)
	server_name_root <- substr(server_name_lc,2,6)
	if (server_name_root == "-root") {
		server_service <- paste(substr(server_name_lc,1,1), metric_data$service, sep="")
	} else {
		server_service <- server_name_lc
	}
    date <- format(as.POSIXct(sub("T", " ", GET$start)), '%Y-%m-%d')

	# Set up the output directory and file name
    main_dir <- paste(hh_config$directories$rssac, "/", format(as.POSIXct(date), '%Y'), "/", format(as.POSIXct(date), '%m'), "/",  metric, "/", sep="")
    dir.create(file.path(main_dir), showWarnings = FALSE, recursive = TRUE)
    yaml_file <- paste(main_dir, server_name_lc, "-", format(as.POSIXct(date), '%Y%m%d'), "-", metric, ".yaml", sep="")

    # Generate the query catering for the nodes specified
    prepStmntNm <- pltnm
    if (GET$ndarr == '-1') {
        prepStmntNm <- paste(prepStmntNm, "_all_nodes", sep="")
    }

	sql <- getStmntParameters(dsccon, dbdrv, GET$pltid, prepStmntNm, GET$svrid, GET$start, GET$stop)
	if(is.null(sql)){
		return(FALSE)
	}
    
	if (GET$ndarr != '-1'){
        sql <- sub(");", paste(", '", GET$ndarr, "');", sep=""), sql)
    }
	
	# Get the data frame
    if (!prepStmnt(prepStmntNm, dsccon)) 
		return(FALSE)
		
    df <- dbGetDataFrame(dbdrv, dsccon, dbconstr, sql)

	# TODO: Handle empty data frames better
	# This simply means there isn't any data for this server on this day
	if(is.null(df) || nrow(df) == 0){
		return(TRUE)
	}

	# Now process the data from the data frame into yaml format
    yaml_out <- list(service=server_service, 'start-period'=paste(GET$start, ":00Z", sep=""), 'end-period'=paste(GET$stop, ":59Z", sep=""), metric=metric)

    if (metric_data$statistics_type == "buckets") {
        de <- as.data.frame(cast(df, x ~ key, value='y', fun.aggregate=sum))	
        
        for (s in metric_data$statistics) {
            bucketlist <- list()
            
            for (i in seq(s$bucket_min, s$bucket_max, by=s$bucket_step)) {
                bucket <- paste(i, "-", sep="")
                
                if (i != s$bucket_max) {
                    bucket <- paste(bucket, i+s$bucket_step-1, sep="")
					value <- de[which(de$x == i + (s$bucket_step - 1)/2),s$name]
                } 
				else if (max(de$x) >= s$bucket_max) {
					value <- sum(subset(de, x >= s$bucket_max, select = s$name))
				}

                if (length(value)==0 || is.na(value) || is.null(value) || value==0) {
					bucketlist[[bucket]] <- as.integer(0)
                } 
				else {
                	bucketlist[[bucket]] <- as.numeric(value)
				}
            }  
            yaml_out[[s$name]] <- bucketlist
        }
    }
	else if (metric_data$statistics_type == "kv_pair") {
        de <- as.data.frame(cast(df, ~ key, value='y', fun.aggregate=sum))
        for (s in metric_data$statistics) {
            value <- as.integer(0)            
            if (s %in% colnames(de)){
                value <- de[[s]]
            } 
            yaml_out[[s]] <- value
        }
    } 
	else if (metric_data$statistics_type == "kv_pair_with_alias") {
        for (s in metric_data$statistics) {
            value <- as.integer(0)
            if (s$alias %in% df$x) {
            	value <- df[df$x == s$alias,2]
			}
            yaml_out[[s$name]] <- value
        }
	} 
	else if (metric_data$statistics_type == "count") {
		de <- as.data.frame(cast(df, ~ key, value='y', fun.aggregate=sum))
		
		for (s in metric_data$statistics) {	
			countlist <- list()
			for (i in colnames(de)) {
				if (i != "value") {
					countlist[[i]] <- de[[i]]
				}
			}
			yaml_out[[s$name]] <- countlist
		}
	}
	else if (metric_data$statistics_type == "average") {
		df$x <- NULL
		#de <- as.data.frame(cast(df, ~ serial, value='y', fun.aggregate=max))
		de <- as.data.frame(cast(df, ~ serial, value='y', function(x) quantile(x,c(0.95))))
		
		for (s in metric_data$statistics) {	
			countlist <- list()
			for (i in colnames(de)) {
				if (i != "value") {
					countlist[[i]] <- as.integer(de[[i]])
				}
			}
			yaml_out[[s$name]] <- countlist
		}
	}
	else if (metric_data$statistics_type == "value") {
		df$x <- NULL
		for (s in metric_data$statistics) {	
			countlist <- list()
			for(i in 1:nrow(df))  {
					countlist[df$serial[[i]]] <- df$y[[i]]
			}
			yaml_out[[s$name]] <- countlist
		}
	}
	
	# Write the result to the yaml file
	# A large precision is needed to deal with large (up to 64 bit) numbers
    write(paste("---\n", gsub("\\.0\\n","\\\n", as.yaml(yaml_out,precision = 20)),sep=""), yaml_file)
    return(TRUE)
}

# initialise plot options
initPlotOptions <- function() {
	
	if (hh_debug) {
		system('logger -p user.notice In initPlotOptions')
	}

	# first, create the groups that link plots to the prepared statements
	f1                      <<- c("edns_version", "do_bit", "client_port_range", "client_subnet2_trace")
	f1lookupcodes           <<- c("qtype", "rcode", "dnssec_qtype")
	f1lookupcodesnoquery    <<- c("opcode")
	f1noclr                 <<- c("rd_bit")
	f1count                 <<- c("client_subnet2_count")
	f1nonormal              <<- c("idn_qname")
	format1                 <<- c(f1, f1lookupcodes, f1lookupcodesnoquery, f1noclr, f1count, f1nonormal)
    
	f2mergekeys             <<- c("direction_vs_ipproto")
	f2mergekeys_lookup      <<- c("certain_qnames_vs_qtype")
	f2mergekeys_lookup_key1 <<- c("chaos_types_and_names")
	f2sumkey2values         <<- c("pcap_stats", "transport_vs_qtype", "dns_ip_version")
	format2                 <<- c(f2mergekeys, f2mergekeys_lookup, f2mergekeys_lookup_key1, f2sumkey2values)
    
	format3                 <<- c("client_subnet_accum", "ipv6_rsn_abusers_accum")

	formattraffic           <<- c("traffic_volume", "traffic_volume_difference")
    
	formatother             <<- c("qtype_vs_tld", "qtype_vs_legacygtld", "qtype_vs_cctld", "qtype_vs_newgtld", "qtype_vs_othertld", "client_addr_vs_rcode_accum", "qtype_vs_qnamelen", 
	                              "rcode_vs_replylen", "rcode_vs_replylen_big", "client_subnet2_accum", "dns_ip_version_vs_qtype", "by_node", "by_subgroup", "load_time", "zone_size")


	rssac                   <<- c("traffic_volume", "traffic_sizes_small","traffic_sizes_big", "rcode_volume", "unique_sources", "traffic_volume_difference")
  
	geo                     <<- c("geomap", "geochart")
  
	formatother             <<- c(formatother, rssac, geo)

	unknown_graphs          <<- c("client_subnet_count", "idn_vs_tld", "ipv6_rsn_abusers_count")

	# now create other useful groups    
	passplotname            <<- c(f1lookupcodes, f1lookupcodesnoquery)
	avgoverwindow           <<- c(format3, 'qtype_vs_tld', 'qtype_vs_legacygtld', 'qtype_vs_cctld', 'qtype_vs_newgtld', 'qtype_vs_othertld', 'client_addr_vs_rcode_accum', 'client_subnet2_accum', 'dns_ip_version_vs_qtype')
	lineplots               <<- c(format1, format2, "by_node", "by_subgroup", "rcode_volume")
	facetedbarplots         <<- c("traffic_sizes_small","traffic_sizes_big")
	facetedlineplots        <<- c("traffic_volume")
	faceteddifflineplots    <<- c("traffic_volume_difference")
	log_option              <<- c(f1, f1lookupcodes, f1lookupcodesnoquery, f1noclr, f1nonormal, format2, "by_node", "by_subgroup", "rcode_volume")
}

# create plot file if not cached
generatePlotFile <- function(plttitle, pltnm, ddpltid, plot_file, simple_start, simple_stop, svrid, pltid, gvis, ndarr, dsccon) {
	
	if (hh_debug) {
		system('logger -p user.notice In generatePlotFile')
	}

	mytitle <- paste(plttitle, "\nfrom ", simple_start, " UTC to ", simple_stop," UTC ", sep="")
	posix_start <- as.POSIXct(simple_start, format='%Y-%m-%d %H:%M')
	posix_stop <- as.POSIXct(simple_stop, format='%Y-%m-%d %H:%M')
	time_window <- difftime(posix_stop, posix_start, units="secs")
			
	if (time_window > 86340 && pltnm %in% lineplots) {
		mytitle <- paste(mytitle, " (smoothed)", sep="")
	}

	# Choose the prepared statement based on the group
	prepStmntNm <- ""
	if      (pltnm %in% f1)                         {prepStmntNm <- "f1"}
	else if (pltnm %in% f1lookupcodes )             {prepStmntNm <- "f1lookupcodes"}
	else if (pltnm %in% f1lookupcodesnoquery)       {prepStmntNm <- "f1lookupcodesnoquery"}
	else if (pltnm %in% f1noclr)                    {prepStmntNm <- "f1noclr"}
	else if (pltnm %in% f1count)                    {prepStmntNm <- "f1count"}
	else if (pltnm %in% f1nonormal)                 {prepStmntNm <- "f1nonormal"}
	else if (pltnm %in% f2mergekeys)                {prepStmntNm <- "f2mergekeys"}
	else if (pltnm %in% f2mergekeys_lookup)         {prepStmntNm <- "f2mergekeys_lookup"}
	else if (pltnm %in% f2mergekeys_lookup_key1)    {prepStmntNm <- "f2mergekeys_lookup_key1"}
	else if (pltnm %in% f2sumkey2values)            {prepStmntNm <- "f2sumkey2values"}
	else if (pltnm %in% format3 )                   {prepStmntNm <- "format3"}
	else if (pltnm %in% formattraffic )             {prepStmntNm <- "traffic_volume"}
	else if (pltnm %in% formatother)                {prepStmntNm <-  pltnm}

	# Do other fix ups to the SQL before running the query
	if (ndarr == '-1') {
		prepStmntNm <- paste(prepStmntNm, "_all_nodes", sep="")
	}	
	if (!(prepStmnt(prepStmntNm, dsccon))) {
		return
	}
	# Setting statement parameters with 1 or 2 datasets for the plot
	sql <- getStmntParameters(dsccon, dbdrv, ddpltid, prepStmntNm, svrid, simple_start, simple_stop)
	if (is.null(sql)) {
		return
	}	
	if (pltnm %in% passplotname){
		sql <- sub(");", paste(", '", pltnm, "');", sep=""), sql)
	}
	if (ndarr != '-1'){
		sql <- sub(");", paste(", '", ndarr, "');", sep=""), sql)
	}
	if(pltnm %in% avgoverwindow){
		sql <- sub("\\(", paste("\\(" , time_window, ".0, ", sep=""), sql)
	}

	# Get the data  **RUN THE QUERY **
	df <- dbGetDataFrame(dbdrv, dsccon, dbconstr, sql)

    # Set the axis labels
	xlab <- "Date"
	if       (pltnm %in% format3)                   {xlab <- "Subnet (IPv4/8 or IPv6/32)"}
	else if  (pltnm == 'traffic_sizes_small' ||
	          pltnm == 'traffic_sizes_big')         {xlab <- "Message Size (bytes)"}

	ylab <- "Queries/sec"
	if      (pltnm %in% rssac)                  {ylab <- "Queries/min"}
	else if (pltnm %in% f1count)                {ylab <- "# Client Subnets"}
	else if (pltnm %in% format3)                {ylab <- "Average Query Rate (q/sec)"}
	else if (pltnm == 'traffic_sizes_small' ||
             pltnm == 'traffic_sizes_big')      {ylab <- "Number of Queries in Each 16 Byte Group"}

	# Now decide how to plot it
	if      (is.null(df))                               {plot_file <- "plots/no_connection.png"}
	else if (nrow(df) == 0)                             {plot_file <- "plots/no_results.png"}
	else if (pltnm %in% f1count)                        {stackedAreaPlot     (df, plot_file, mytitle, xlab, ylab, gvis)}
	else if (pltnm %in% lineplots)                      {linePlot            (df, plot_file, mytitle, xlab, ylab, gvis)}
	else if (pltnm %in% facetedlineplots)               {facetedLinePlot     (df, plot_file, mytitle, xlab, ylab, gvis)}
	else if (pltnm %in% faceteddifflineplots)           {facetedDiffLinePlot (df, plot_file, mytitle, xlab, ylab, gvis)}
	else if (pltnm %in% facetedbarplots)                {facetedBarPlot      (df, plot_file, mytitle, xlab, ylab, gvis, 14)} # width hardcoded to 14
	else if (pltnm %in% format3)                        {barPlot             (df, plot_file, mytitle, xlab, ylab, gvis)}
	else if (pltnm == 'qtype_vs_tld' || 
	         pltnm == 'qtype_vs_legacygtld' || 
	         pltnm == 'qtype_vs_cctld' || 
	         pltnm == 'qtype_vs_newgtld' ||
	         pltnm == 'qtype_vs_othertld')             {stackedBarPlot(df, plot_file, mytitle, "TLD",                        "Average Query Rate (q/sec)", gvis, pltnm)}
	else if (pltnm == 'client_addr_vs_rcode_accum' || 
	         pltnm == 'client_subnet2_accum')           {stackedBarPlot(df, plot_file, mytitle, "Subnet (IPv4/8 or IPv6/32)", "Average Query Rate (q/sec)", gvis, pltnm)}
	else if (pltnm == 'qtype_vs_qnamelen')              {stackedBarPlot(df, plot_file, mytitle, "QNAME Length (bytes)",       "Count",                      gvis, pltnm, scalex="continuous", vertical=1)}

	else if (pltnm == 'dns_ip_version_vs_qtype')        {stackedBarPlot(df, plot_file, mytitle, "IP Version",                 "Average Query Rate (q/sec)", gvis, pltnm, vertical=1)}
	else if (pltnm == 'unique_sources')                 {barPlot       (df, plot_file, mytitle, "IP Version/Aggregation",     "Number of Unique Sources",   gvis, small=0)}
	else if (pltnm == 'rcode_vs_replylen' || 
	         pltnm == 'rcode_vs_replylen_big')          {if (gvis==1) {stackedAreaPlot(df, plot_file, mytitle, "Response Size Length (bytes)", "Count", gvis)}
	                                                     else         {stackedBarPlot (df, plot_file, mytitle, "Response Size Length (bytes)", "Count", gvis, pltnm, scalex="continuous", vertical=1)}}
	else if (pltnm == 'geomap')                         {geomap  (df, plot_file, mytitle, "aaaa", "bbbbb", 1)}
	else if (pltnm == 'geochart')                       {geochart(df, plot_file, mytitle, "aaaa", "bbbbb", 1)}
	else if (pltnm == 'load_time')                      {scatterPlot(df, plot_file, mytitle, xlab, ylab, gvis)}
	else if (pltnm == 'zone_size')                      {barPlot(df, plot_file, mytitle, xlab, ylab, gvis, vertical=1)}

	return(plot_file)
}
