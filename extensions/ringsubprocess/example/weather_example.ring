load "../subprocess.ring"
load "jsonlib.ring"

# Example: Fetch and display weather data using OpenWeatherMap API
? "Weather Information Example"
? "========================="

proc = new ProcessManager()


# Test with some cities
cities = ["London", "Paris", "Tokyo"]

for city in cities {
    ? nl + "Fetching weather data for: " + city
    
    response = getWeatherData(city)
    if len(response) > 0 {
        data = json2list(response)
        if islist(data) {
            ? "Temperature: " + data["current"]["temp_c"] + "°C"
            ? "Condition: " + data["current"]["condition"]["text"]
            ? "Wind Speed: " + data["current"]["wind_kph"] + " km/h"
            ? "Humidity: " + data["current"]["humidity"] + "%"
        else
            ? "Error parsing weather data"
        }
    else
        ? "Failed to fetch weather data"
    }
}

# Clean up
proc.kill()

# Function to fetch weather data for a city
func getWeatherData city
    command = 'curl -s "http://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=' + city + '"'
    
    if proc.runCommand(command) {
        proc.waitForComplete()
        return proc.readOutput()
    }
    return ""
