source("./functions/etl.R")
`%>%` <- magrittr::`%>%`
api_key <- Sys.getenv("eia_key")
start <- "2022-09-01T01"
end <- "2022-09-01T02"
subba <- "PGAE"
metric <- "value"
parent <- "CISO"
parent_list <- c("CISO",
                "ERCO",
                "ISNE",
                "NYIS",
                "PNM")


parent_subba_df <- data.frame(parent = "CISO", 
                              subba = c("PGAE", "SCE", "SDGE", "VEA"))

sub_region_demand <- function(url = "https://api.eia.gov/v2/electricity/rto/region-sub-ba-data/data",
                              api_key = Sys.getenv("eia_key"),
                              metric = "value",
                              parent = "CISO",
                              subba = "PGAE",
                              start = NULL,
                              end = NULL,
                              length = 50000){
  
  if(is.null(start)){
    start <- ""
  }  else{
    start <- paste("&start=", start, sep = "")
  } 
  
  if(is.null(end)){
    end <- ""
  } else {
    end <- paste("&end=", end, sep = "")
  }
  cmd <- paste("curl '", 
               url, 
               "?api_key=",
               api_key, 
               "&data[]=",
               metric,
               "&facets\\[parent\\][]=",
               parent,
               "&facets\\[subba\\][]=",
               subba,
               start,
               end, 
               "&length=",
               length,
               "' | jq -r ' .response | .data[] | [.[]] | @csv'",
               sep = "")
  
  
  df <- data.table::fread(cmd = cmd,
                          col.names = c("period", 
                                        "subba", 
                                        "subba-name", 
                                        "parent", 
                                        "parent-name", 
                                        "value",
                                        "units"))
  
  df <- df %>%
    dplyr::mutate(time = lubridate::ymd_h(period, tz = "UTC")) %>%
    dplyr::arrange(time)
  
  return(df)
  
}


df <- sub_region_demand(parent = "CISO",
                        subba = "PGAE")
df

