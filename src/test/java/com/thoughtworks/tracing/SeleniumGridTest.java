package com.thoughtworks.tracing;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.remote.RemoteWebDriver;

import java.net.MalformedURLException;
import java.net.URL;

public class SeleniumGridTest {

    static WebDriver driver;
    static String baseURL, nodeURL;

    @BeforeAll
    public static void setUp() throws MalformedURLException {
        baseURL = "https://selenium.dev/";
        nodeURL = "http://localhost:4444/";
        driver = new RemoteWebDriver(new URL(nodeURL), new FirefoxOptions());
    }

    @AfterAll
    public static void afterTest() {
        driver.quit();
    }

    @Test
    public void sampleTest() {
        driver.get(baseURL);

        driver.findElement(By.tagName("body")).getText();
    }
}