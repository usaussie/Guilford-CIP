require(tidyverse)
require(siverse)
require(fs)

#This is also available from Jason in that folder, but he shared this code as to  how he obtained it.
temp <- file_temp()
download.file("http://dl.ncsbe.gov.s3.amazonaws.com/data/ncvoter41.zip", temp)
temp <- unzip(temp)
vote <- read_tsv(temp, guess_max = Inf)


