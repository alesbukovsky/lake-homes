export DB_HOST=localhost
export DB_PORT=5599
export DB_SCHEMA=houses
export DB_USER=hombre

export PI_HOST=192.168.1.99
export PI_USER=pi
export PI_WWW="/home/$PI_USER/Dev/www"

_sql() {
    psql -h $DB_HOST -p $DB_PORT -d $DB_SCHEMA -U $DB_USER -v ON_ERROR_STOP=1 $1 "$2"
    if [ $? -ne 0 ]; then
        exit 1
    fi
}