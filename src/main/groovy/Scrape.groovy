import geb.Browser
import org.openqa.selenium.JavascriptExecutor
import java.time.LocalDate
import java.time.format.DateTimeFormatter

cfg = [
    'root'   : 'https://www.lakehomes.com',
    'routes' : [
        '/connecticut',
        '/massachusetts',
        '/new-hampshire',
        '/vermont'
    ],
    'dir'    : '/Users/alesbukovsky/Dev/houses/data',
    'price'  : 200000
]

def ts = DateTimeFormatter.ofPattern('yyMMdd').format(LocalDate.now())
def fi = new File("${cfg.dir}/lakehomes-${ts}.csv");

def known = [:]
if (fi.exists()) {
    fi.eachLine { l -> 
        known[ l.tokenize('|')[0] ] = l 
    }
}

def out = fi.newPrintWriter()

Browser.drive {
    getDriver().manage().window().maximize() 

    cfg.routes.forEach { route ->
        go cfg.root + route
        sleep(500)

        def regions = []

        $('div', class:'niche-item').forEach { d ->
            def a = d.$('div').$('span').$('a')
            def t = a.text().replace('\n', '').replace('\r', '').split('Listings: ')
            if ((t[1] as int) > 0) {
                regions << a.attr('href')
            }
        }

        regions.forEach { region ->
            go region
            sleep(500)

            def props = []

            def run = true
            while (run) {
                def t = $('div', 'data-test':'context-child-2', text:iContains('Listing Results'))
                if (t) {
                    t.click()
                    sleep(500)
                }   

                $('div', class:'listing-item').$('a').forEach { a ->
                    def i = a.$('img', class:'card-img-top').attr('src')  
                    def p = a.$('div', class:'card-title').$('strong').text().replace('$', '').replace(',', '')
                    if ((p as int) <= cfg.price) {
                        props << [a.attr('href'), (i ? i : '')]
                    }
                }

                def n = $('a', role:'button', 'aria-label':'Next page', 'aria-disabled':'false')
                if (n) {
                    def js = driverAs(JavascriptExecutor.class)
                    js.get().executeScript('arguments[0].scrollIntoView(true)', n.firstElement())  
                    js.get().executeScript('arguments[0].click()', n.firstElement())
                    sleep(1000)  
                } else {
                    run = false
                }
            }

            props.forEach { prop ->
                def rec = null
                def ent = known.find(r -> { r.value != null && r.value.contains(prop[0]) })
                if (ent) {
                    rec = ent.value
                    known[ent.key] == null
                }
                
                else {
                    go prop[0]
                    sleep(500)

                    def price = $('h3', text:startsWith('$')).text().replace('$', '').replace(',', '')
                    def mls = $('div', 0, class:'mls#').$('span', class:'value').text()

                    def address = $('h1').text().replace('\n', ', ')
                    def parts = address.split(/\s+/)
                    def state = parts[parts.size() - 2]

                    def status = $('div', 0, class:'status').$('span', class:'value').text().replace(' ', '-').toUpperCase()
                    if (status.contains('---')) status = status.takeBefore('---')
                    if (status.contains('UNDER-CONTRACT') status = 'UNDER-CONTRACT'                    

                    if (!known.containsKey(mls)) {
                        rec = "${mls}|${state}|${address}|${price}|${status}|${prop[0]}|${prop[1]}"
                        known[mls] = null
                    }
                }
                
                if (rec) {
                    out.println(rec)
                    out.flush()
                }
            }
        }
    }
}.quit()

out.close()
