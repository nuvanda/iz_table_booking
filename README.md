В каждом ресторане есть столы.  
Эти столы можно резервировать.  
При этом шаг резервации - 30 минут, а пользователь может резервировать стол на 30, 60, 90 и т.д. минут.   
В каждой резервации должен быть пользователь.  
У каждого ресторана есть график работы, который может переваливать за полночь.  
Резервации на один стол не должны пересекаться.  
При этом, если одна резервация закончилась в 5 вечера, вторая может начинаться в 5 вечера.  
Интересует только реализация моделей и структура базы данных.  

# Controllers: 

GET /restaurants  

Request params: 

    [{  
        id: integer,  
        type: "restaurant",  
        title: "string",  
        start_time: "string",  
        end_time: "string"  
    }]  

GET /restaurants/1/open_times  

Request params:  

    {  
        people_number: integer,  
        date: "date"
    }  

Response: 
    
    [{  
        start_time: "timestamp",  
        end_time: "timestamp"  
    }]

POST /restaurants/1/bookings  

Request params:  

    [{  
        start_time: "timestamp",  
        end_time: "timestamp",  
        people_number: integer  
    }]  

Response:  

    201:  
    {  
        restaurant_id: integer,  
        table_id: integer,  
        user_id: integer,  
        start_time: "timestamp",  
        end_time: "timestamp",  
        people_number: integer  
    }

    400:  
    {  
        error: "message"  
    }  

GET /restaurants/1/bookings  

Request params:  

    {  
        date: "date"  
    }  

Response:  

    [{  
        id: integer,  
        type: "booking",  
        start_time: "timestamp",  
        end_time: "timestamp",  
        table_id: integer,  
        user_id: integer,  
        people_number: integer  
    }]  

GET /users/1/bookings  

Request params:  

    {  
        date: "date"  
    }  

Response:  

    [{   
        id: integer,   
        type: "booking",   
        start_time: timestamp,   
        end_time: timestamp,   
        restaurant_id: integer,  
        table_id: integer,  
        people_number: integer  
    }]  

GET /tables/1/bookings  

Response:  

    [{  
        id: integer,  
        type: "booking",  
        start_time: timestamp,  
        end_time: timestamp,  
        restaurant_id: integer,  
        user_id: integer  
    }]

# Database:

## Restaurant:
    - title: string  
    - start_time: string  
    - end_time: string  

## Table:
    - restaurant_id  
    - people_number  

## Booking:
    - table_id  
    - user_id  
    - start_time  
    - end_time  

## User:
    - email  
    - password
    - first_name  
    - last_name  

# Services:

## Restaurant::TimeSlotsViewer

### Returns an array of objects with the start and end times for the restaurant
(restaurant_id: integer, date: "date", people_number: integer) => <Array<Hash{start_time: timestamp, end_time: timestamp}>>

### Restaurant::BookingCreator
(restautant_id: integer, start_time: time, end_time: time, people_number: integer, user_id: integer) => Booking