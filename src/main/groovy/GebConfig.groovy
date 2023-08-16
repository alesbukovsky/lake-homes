import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.chrome.ChromeOptions

driver = {
    ChromeOptions o = new ChromeOptions()
    o.addArguments("start-maximized")
    o.addArguments("remote-allow-origins=*")
    new ChromeDriver(o)  
}
