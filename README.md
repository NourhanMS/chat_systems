# Chat system mimic

Implementation for how a simple chat system could work .

## System Dependencies:

* Ruby 3.2.9
* Rails 8.1.1
* Redis 7.2.12 
* Elastic search 8.15.0
* Mysql 8.0


## How To Start The Application

You should have docker and docker compose  installed.  
```
    docker compose build
    docker compose up
```


## System Info  

In this system we control creating new applications providing a token for each app.  
Each application has many chat rooms assigned to it with a unique number assigned to each chat starts from 1.  

Using the application token and the chat number clients can send many messages to the chat room  
where each message inside a chat has a unique number that starts with 1.  

### Unique Numbers Handling

Since our application should be scaled across many servers  
We control the chat number / message number using redis counter  
So that many servers can read from it safely and race condition is controlled as well 
since our server increments and reads the new value atomically from redis counter using `INCR`.  


### Monolithic VS Micro Services  

Our app is monolithic which means our services are tightly coupled  
so if mysql database for example is down then all our services will be down.  

this could be enhanced by using the micro services approach if we want to favor
availability and to make each service working independently.  

To achive that we will have then:  
Chat servive / Message service / Application service .  
Where each of them will have its own mysql database 
and our main app will be just a gateway to take clients requests and pass them to the service redis queue , then each service should be listening on its own queue to handle the incoming requests.



## How To Solve chats_count / messages_count ?  

1- update with each new chat / message the counter ?  
That is an overhead to the system.  

2- Create an hourly cron job that executes a rake  
this rake should be responsible on reading all existing redis chat and message counters   
`chat_counter_app_{app_id}`  `message_counter_chat_{chat_id}`  
and then it should send two bulk update requests one to update the chats_count inside applications table. and the other for the messages_count inside chats table.  


## REST APIS

```
    Applications:

    POST http://localhost:3000/applications  
    {
        "name": "App2"
    }   

    GET http://localhost:3000/applications

    PUT http://localhost:3000/applications/<application_token> 
    {
        "name":"App1"
    }
```

```
    Chats:

    POST http://localhost:3000/applications/<application_token>/chats 

    GET http://localhost:3000/applications/<application_token>/chats 
```

If you send the content as a query parameter , we use elastic search for searching for that content and return messages that belong to a specific chat having this content.  

```
    Messages:

    POST http://localhost:3000/applications/<application_token>/chats/<chat_number>/messages 

    GET http://localhost:3000/applications/<application_token>/chats/<chat_number>?content=luciq
```
