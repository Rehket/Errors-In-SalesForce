/*******************************************************************************************************
 * @author Rehket, aalbright@iamrehket.me, 01 February 2019
 * @description This class has functions demonstrating common scenarios where errors might occur 
 * and how to handle them.
 */

public with sharing class ErrorExamples {

    /*******************************************************************************************************
     * @author Rehket, aalbright@iamrehket.me, 01 February 2019
     * @description Demonstrates a function that processes a string to tell someone 
     * if they entered a valid username. 
     * @param String desired_username The username someone is requesting. 
     */
    public static Boolean isUsernameAvailable(String desired_username){
        // A username in SalesForce is a string formated as an email. Ex: text@text.com
        
        List<User> duplicate_users = [SELECT Id FROM User WHERE UserName=:desired_username];
        if(duplicate_users.isEmpty())
            return true;
        return false;

    }
}
