/*******************************************************************************************************
 * @author Rehket, aalbright@iamrehket.me, 01 February 2019
 * @description This class has functions demonstrating common scenarios where errors might occur 
 * and how to handle them.
 * 
 * Business Requirement: We need a form for a user to check that a username is available.
 */

public with sharing class ErrorExamples {

    /*******************************************************************************************************
     * @description Demonstrates a function that processes a string to tell someone 
     * if they entered a valid username. 
     * @param String desired_username The username someone is requesting. 
     */
    static Boolean isUsernameAvailable(String desired_username){
        // A username in SalesForce is a string formated as an email. Ex: text@text.com
        // So what can go wrong here?
        
        List<User> duplicate_users = [SELECT Id FROM User WHERE UserName=:desired_username];
        if(duplicate_users.isEmpty())
            return true;
        return false;
    }
    /* Possible Problems:
        We can have a user input a username that is not valid. It will always return true. 
        A user could pass an empty string. This would also always return true. 

        In cases like these, what we want to do is tell the user that something is wrong and how they can fix it.
        In SalesForce, this is done with exceptions. 
    */


    // This is an exception we will use when the user can resolve the issue.
    class UserNameException extends Exception {}

    /*******************************************************************************************************
     * @description Returns true if the string has an @ symbol. Not really a good email check.
     * @param String potential_email The potential email. 
     */
    static Boolean isEmail(String potential_email){
        if (!potential_email.contains('@'))
            return false;
        List<String> email_components = potential_email.split('@');
        if (email_components.size() != 2)
            return false;
        return true;
    }


    /*******************************************************************************************************
     * @description A slightly better version of the isUserNameAvailable function, in terms of error handling.
     * @param String desired_username The username a user wants to check. 
     */
    static Boolean isMyUsernameAvailable(String desired_username){
        if(String.isNotBlank(desired_username) && isEmail(desired_username)){
            List<User> duplicate_users = [SELECT Id FROM User WHERE UserName=:desired_username];
            if(duplicate_users.isEmpty())
                return true;
            return false;
        }
        throw new UserNameException('Desired Username cannot be blank and should be in the form of text@somedomain.com'); 
    }

    /* Possible Problems:
        What do we do with the thrown exception?

        We could put that in a try-catch block, but that is really starting to get a large.....
    */





    /*******************************************************************************************************
     * @description A slightly bigger version of the isMyUserNameAvailable function, in terms of error handling.
     * @param String desired_username The username a user wants to check. 
     */
    static Boolean isAUsernameAvailable(String desired_username){
        try {
            if(String.isNotBlank(desired_username) && isEmail(desired_username)){
                List<User> duplicate_users = [SELECT Id FROM User WHERE UserName=:desired_username];
                if(duplicate_users.isEmpty())
                    return true;
                return false;
            }
            throw new UserNameException('Desired Username cannot be blank and should be in the form of text@somedomain.com');
        } catch (UserNameException e){
            return false;
        }
    }
    /* Possible Problems:
        So now if the user puts in something incorrect... the function will return false, that name is not available.
        It supports the business requirement.

        But what if we want to tell the user they are entering something invalid, rather than just 
        letting them plug away until they enter an email that is not already in use....
    */





    /*******************************************************************************************************
     * @description In the check_username method, we are going to use the isUsernameAvailable method 
     * we made before and combine it with pieces of the other methods to make something that is a bit
     * easier to understand and use. 
     * @param 
     */
    
    static Boolean checkUsername(String desired_username){
        if(String.isNotBlank(desired_username) && isEmail(desired_username))
            return isUsernameAvailable(desired_username);
        throw new UserNameException('Desired Username cannot be blank and should be in the form of text@somedomain.com');    
    }

    @AuraEnabled
    public static Boolean auraCheckUsername(String desired_username){
        try {
            return checkUsername(desired_username);
        } catch (UserNameException e) {
            throw new AuraHandledException('Desired Username cannot be blank and should be in the form of text@somedomain.com');
        } catch (Exception e){
            throw new AuraHandledException('Something unexpected happened... Please make a ticket with IT for more assistance.');
        }
      
    }

    /*
        So at this point, you have mave realized that despite us building this function to be used to take a users input, 
        we did not add an AuraEnabled decorator. That's beacuse is because seperating out the functionality and logic 
        from the aura enabled function lets us focus on handling the error in the aure function.

        If we get an exception we recognise, such as the UserNameException, we can ask the user to fix it. 
        If we get something we are not expecting, we ask the user to get assistance to IT. 
    
    */

    // Dealing With DML Exceptions

    // Incomplete Transactions when using try catch statements
}
