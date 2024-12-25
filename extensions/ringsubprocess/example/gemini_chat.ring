load "subprocess.ring"
load "stdlib.ring"
load "jsonlib.ring"

proc = new ProcessManager()
API_KEY = "your api key"
API_URL = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key="

conversation = []

while true {
    ? nl + "You:> " give userInput
    userInput = trim(userInput)
    if lower(userInput) = "exit" {
        ? "Goodbye!"
        exit
    }
    
    conversation + [:role = :user, :content = userInput]
    response = sendMessage(userInput)
    
    if len(response) > 0 {
        try{ 
            data = json2list(response)
            if len(data["candidates"]) > 0 and 
               islist(data["candidates"][1]["content"]["parts"]){ 
                text = data["candidates"][1]["content"]["parts"][1]["text"]
                if text = NULL or len(text) = 0 {
                    text = data["candidates"][1]["content"]["parts"][0]["text"]
                }
                ? nl + "Model:> " + text + nl
                conversation + [:role = :model, :content = text]
            else
                ? "Error: Invalid response format"
                ? "Response: " + response
            }
        catch
            ? "Error: " + cCatchError
            ? "Response: " + response
        }
    else
        ? "Error: No response from API"
    }
}

proc.kill()

# دوال مساعدة
func join items, delimiter
    if not islist(items) { return "" }
    if len(items) = 0 { return "" }
    
    result = ""
    for i = 1 to len(items) {
        result += items[i]
        if i < len(items) { result += delimiter + nl + tab  }
    }
    return result

func buildContext conversation
    if len(conversation) = 0 { return "" }
    
    messages = []
    for msg in conversation {
        if msg[:role] = :user { 
            add(messages, '{"role":"user","parts":[{"text":"' + msg[:content] + '"}]}')
        else
            add(messages, '{"role":"model","parts":[{"text":"' + msg[:content] + '"}]}') 
        }
    }
    return join(messages, ",")

func sendMessage message
    context = buildContext(conversation)
    delimiter = ""
    if len(context) > 0 { delimiter = "," }
    
    requestBody = '{
      "contents": [' + context + delimiter + 
        '{"role":"user","parts":[{"text":"Respond in the same language as: ' + message + '"}]}],
      "generationConfig": {
        "temperature": 1.0,
        "maxOutputTokens": 4096,
        "topP": 0.8,
        "topK": 40
      }
    }'

    //? "requestBody: " + requestBody

    write("temp_request.json", requestBody)
    command = 'curl -s -X POST "' + API_URL + API_KEY + 
             '" -H "Content-Type: application/json" ' +
             '--data @temp_request.json'
    
    proc.runCommand(command)
    proc.waitForComplete()
    response = proc.readOutput()
    remove("temp_request.json")
    return response

func escapeJson str
    if str = NULL { return "" }
    escaped = ""
    for i = 1 to len(str) {
        char = str[i]
        switch char {
            case '"'  escaped += '\"'
            case "\" escaped += '\\'
            case '/' escaped += '\/'
            case char(8) escaped += '\b'
            case char(12) escaped += '\f'
            case char(10) escaped += '\n'
            case char(13) escaped += '\r'
            case char(9) escaped += '\t'
            default
                if ascii(char) < 32 { 
                    escaped += '\u' + right('0000' + hex(ascii(char)), 4)
                else
                    escaped += char
                }
        }
    }
    return escaped
