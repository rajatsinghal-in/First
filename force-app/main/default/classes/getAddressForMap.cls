public class getAddressForMap {
    
    // Google Maps API Place Autocomplete
    // Documentation: https://developers.google.com/places/web-service/autocomplete
    @AuraEnabled
    public static String getCoordinates(String Address) {
        String url = System.label.geoCodeURL+
            + 'address=' + Address
            + '&key=' + getGoogleMapsAPIKey();
        
        return makeAPICall(url);
    }
    
    private static string makeAPICall(string url) {
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(url);
        httpRequest.setTimeout(120000);
        httpResponse = http.send(httpRequest); 
        system.debug('httpResponse' + httpResponse.getBody());
        if (httpResponse.getStatusCode() == 200){
            return httpResponse.getBody();    
        } else {
            System.debug(httpResponse.getStatusCode());
            System.debug(httpResponse.getBody());
            throw new AuraHandledException(httpResponse.getBody());
        } 
    }
    
    private static string getGoogleMapsAPIKey() {
        return System.Label.geoCodeKey; // add api key or get from custom settings
    }
}