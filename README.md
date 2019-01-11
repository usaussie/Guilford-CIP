# Guilford-CIP
The code and data standards for the Guilford County Community Indicators Project dashboard


# Data Standards

These data standards are divided into two main sections: content and structure. The former describes issues like reproducability and documentation. The latter describes standards for how the data should be organized and maintained in order to facilitate analysis, visualization, and data sharing. 

## Content

### Reproducability 

All data needs to have a source describing where and when the data were obtained the data and if there are any known issues with the data. This is important to ensure data integrity. 
 
Modifications to data should be fully reproducible using code (not manually adjusted). This is important in order to allow future updates to the data to be added and modified uniformly. It is also a safety protocol that allows changes to be tracked to prevent inaccurate conclusions to be drawn from the data.


## Structure

Data should be tabular with one header row starting in the top-left cell.  Cells should not be merged.

Data should be “tidy,” according to the definitions laid out in the journal article “Tidy Data” by Hadley Wickham. [Journal of Statistical Software](https://www.jstatsoft.org/article/view/v059i10), 2014-09-12).

Tidy data, Codd’s 3rd normal form (Codd 1990):

* Each variable forms a column
* Each observation forms a row
* Each type of observational unit forms a table

