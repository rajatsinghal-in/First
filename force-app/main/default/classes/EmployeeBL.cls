public class EmployeeBL{
    
    public static void beforeinsert(List< Employee__c > employeeList){
        validateEmployeeUser(employeeList);
    }
    
    public static void validateEmployeeUser(List< Employee__c > employeeList){
        List<Id> userIds = new List<Id>();
        for(Employee__c employee : employeeList){
            if(employee.User__c != null)
            userIds.add(employee.User__c);
        }        
        List<Employee__c> usersAlreadyPresent = [select id from Employee__c where User__c IN: userIds];
        if(usersAlreadyPresent.size()>0){
            employeeList[0].addError('This user already has an employee record. Please select another user');
        }
    }

}