package com.thoughtworks.tracing;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.remote.RemoteWebDriver;

import java.net.MalformedURLException;
import java.net.URL;

public class DistributedTracingExamples {

    public static void main(String[] args) throws MalformedURLException {

        WebDriver driver = new RemoteWebDriver(
                new URL("http://localhost:4444"),
                new FirefoxOptions());

        driver.get("https://selenium.dev/");

        driver.findElement(By.tagName("body")).getText();

        driver.quit();
    }
}
