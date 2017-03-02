import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// print("Hello, world!")

//Create the new HTTP Server
let server = HTTPServer()

server.serverPort = 8080

server.documentRoot = "webroot"

var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
    request, response in
    response.setBody(string: "Hello, Perfect!")
    .completed()
})

func returnJSONmessage(message: String, response: HTTPResponse){
    do {
        try response.setBody(json: ["message": message])
        .setHeader(.contentType, value: "application/json")
        .completed()
    } catch {
        response.setBody(string: "Error handling request: \(error)")
        .completed(status: .internalServerError)
    }
}

// Calling GET Method
routes.add(method: .get, uri: "/helloGetJSON", handler: {
    request, response in
    returnJSONmessage(message: "Hello, JSON!", response: response)
})


// Calling Nest Path Method
routes.add(method: .get, uri: "/helloGetJSON/there", handler: {
    request, response in
    returnJSONmessage(message: "I am trying to check Nest Path of Get method in JSON!", response: response)
})


// Instance example of above method
routes.add(method: .get, uri: "/books/{num_books}", handler: {
    request, response in
    guard let numBooksStrings = request.urlVariables["num_books"],
        let numBooksInt = Int(numBooksStrings) else {
            response.completed(status: .badRequest)
            return
    }
    returnJSONmessage(message: "Take one, if you done pass it around, \(numBooksInt - 1) to others to read.....", response: response)
})


// Calling POST Method
routes.add(method: .post, uri: "post", handler: {
    request, response in
    guard let name = request.param(name: "name") else {
        response.completed(status: .badRequest)
        return
    }
    returnJSONmessage(message: "Hello, \(name)!", response: response)
})




server.addRoutes(routes)

do {
    
    try server.start()
}   catch PerfectError.networkError(let err, let msg) {
    print("Network Error Thrown: \(err) \(msg)")
}

