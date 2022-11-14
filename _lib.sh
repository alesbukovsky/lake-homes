export DB_HOST=localhost
export DB_PORT=5599
export DB_SCHEMA=lake-homes
export DB_USER=hombre

export PI_HOST=berry.local
export PI_USER=pi
export PI_WWW="/home/$PI_USER/www/homes"

_sql() {
    psql -h $DB_HOST -p $DB_PORT -d $DB_SCHEMA -U $DB_USER -v ON_ERROR_STOP=1 $1 "$2"
    if [ $? -ne 0 ]; then
        exit 1
    fi
}