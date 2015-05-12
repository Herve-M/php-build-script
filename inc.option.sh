# Option
#-----------------------------------------------------------------------------

# How many day ago : doing a backing at 10/10/10 at 02:00 will realy a backup from 09/10/10
DAYS="1"
# GET CURRENT DATETIME
NOW=$(date +"%d_%m_%Y")
# GENERATE PAST DATE FROM DAYS CONSTANT
REAL_BACKUP_DAY="$(date "+%d_%m_%Y" -d "$DAYS days ago")"

LOG_FILE="/tmp/phpbuild-$NOW.log"

readonly NB_CORE=4
