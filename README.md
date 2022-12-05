# lake-homes

Scrapes listings from [lakehomes.com](https://www.lakehomes.com) based on filter criteria. Produces JSON data set to be used with custom web UI for better browsing experience.

### Setup

* Chromium driver, e.g. `brew install chromedriver`
* Gradle build tool, e.g. `sdk i gradle`
* PostgreSQL database, e.g. `docker-compose up -d`
* Database artifacts as per `./src/main/sql/create.sql`
* HTTP server, e.g. `pm2 start http-server -- ~/www -p 8080 -d false -c-1 -s`

### Process

1. `./scrape.sh`: scrapes listings into a dated CSV file in `./data` directory.
2. `./update.sh <scrape-file>`: uploads given scrape file into local PostgreSQL database.
3. `./publish.sh`: generates JSON data set and pushes it out to web UI server and local dev folder.
4. `./deploy.sh`: (when needed) deploys custom web UI to remote HTTP server 

### Internals

Scraping uses [Geb](https://gebish.org/) to navigate the website in a headless browser. The script defines basic filtering criteria, e.g. states to include and maximum listing price. The data is written into a dated pipe-separated (`|`) CSV file within `./data` directory. If a pre-existing file is detected for the same date, it is considered a result of an interrupted run. In that case, the already captured data is used instead of re-scraping the listings.

CAUTION: the headless browser tooling appears to need an active display and fails randomly unless both screensaver and display sleep are turned off. Script `scrape.sh` does just that in MacOS fashion (using `defaults` to tweak screensaver idle time and `caffeinate` to prevent display sleep). The process can be run without these measures (e.g. during development) by executing `gradle scrape` directly.

Update stores the date of the file in the `metas` table and inserts all listings into a temporary `uploads` table. A SQL script deletes all records previously marked as `REMOVED` and proceeds to mark new removals via a comparison of `uploads` and `homes` tables. All records from `uploads` are upserted into `homes` - inserted as `NEW`, updated with no change indicator. Associated database trigger checks for changes in price (`PRICE`) or status (`STATUS`). The resulting value of `change` column indicate detected difference from the previous update.

Publishing generates a single JSON file `data.json` from the current data in the database. It copies it to the remote HTTP server (Raspberry Pi) via `scp` as well as local web UI development directory (`./src/main/web`).

Deployment (`deploy.sh`) copies all CSS and HTML files from the local web UI development folder to remote HTTP server (Raspberry Pi) via `scp`.

### Tips

When `chromedriver` is installed or upgraded via `brew`, macOS is likely to fail the scraping process with `Error: “chromedriver” cannot be opened because the developer cannot be verified`. Run the following in a shell:
```
xattr -d com.apple.quarantine /usr/local/bin/chromedriver
```