#Assignment_2_FE513

# ----------- connect to PostgreSQL ----------------
if(!require("RPostgreSQL")){ # check for package existence 
  install.packages("RPostgreSQL")
}
library("RPostgreSQL")
#save password
pw = {"Rhea@1802"}
# load PostgreSQL driver
drv = dbDriver("PostgreSQL") 
# create a connection
con = dbConnect(drv, dbname = "postgres", host = "127.0.0.1", port = 5432, 
                user = "postgres", password = pw)
# check for table existence
dbExistsTable(con, "banks_al_2001")

# ---------------- read and write data to the database ----------------

# get the data from postgreSQL
data_postgres = dbGetQuery(con, "select * from banks_al_2001")

#---------------- close the connection -----------------
dbDisconnect(con) # discards all pending work, and frees resources (e.g., memory, sockets)
dbUnloadDriver(drv)

