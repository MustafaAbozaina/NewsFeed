News App - Loading News List with it's details 

## BDD specs 

### story: Customer need to see News List App 

### Narrative #1 

> As an online customer 
I want to see latest news in a list so to be updated 

#### Scenarios (Acceptence criteria)

``` 
Given: The customer has connectivity 
when : The customer request to see news 
then : The app should display latest news from remote
``` 
### Narrative #2

> as an online customer 
I want to search in news by words 

#### Scenarios (Acceptence criteria)

```
Given: The customer is online
When: The customer search using word
then: the app should display news related to search word
```



### Narrative #3 

> As an offline customer I want to see there is no network  

#### Scenarios (Acceptence criteria)

```
Given: The Customer has no connectivity 
When: The Customer try open news list 
Then: The app should display there is no network connect and retry 
```

#### Primary path (happy path):
1. Execute "Load News " command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates News items from valid data.
5. System delivers News items.

#### Invalid data – error (sad path):
1. System delivers error.

#### No connectivity – error (sad path):
1. System delivers error.





