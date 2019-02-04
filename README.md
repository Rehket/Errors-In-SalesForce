# SFDC Error Handling
## This repo contains examples on how to implement error handling in SalesForce.
### Part 1 - Some Basics of Error Handling(v1: Complete)
- What are errors in SalesForce? 
- What types of errors are there?
- How do we handle them?

### Part 2 - DML Errors(v1: In-Progress)
- What are DML Errors?
- What makes them special?
- How to handle them?

### Part 3 - Sending Error Messages to the UI(v1: To Do)
  
## Errors in SalesForce
Errors can be thought of as any action that does not work correctly, despite the user performing the expected actions.

Errors happen frequently when you are dealing with or processing user input. So code that is close to user interface needs to be especially robust. Errors are also frequently when you are consuming data from external systems. 

Critical Areas for error handling:
- UI Logic
- Parsing User Input
- Performing Background actions while a user is entering input
- Loading records from an external system or database
