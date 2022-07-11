global class WeatherController {
    
    private static final String API_KEY = 'fcc63e93b6c1af0d48949795e41d1365';

    @AuraEnabled
    global static wrapperData makeCallout(String cityName, String countryCod){
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather?q=' + cityName +','+ countryCod + '&appid=' + API_KEY;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        res = http.send(req);
        if (res.getStatusCode() == 200 && res.getBody() != null) {
            String jsonRes = res.getBody();
            fromJSON jsonParseData = (fromJSON)parse(jsonRes);
            wrapperData wrpData = new wrapperData(jsonParseData);
            return wrpData;
        } else {
            throw newMessageException('Error');
        }
    }

    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }

    global class wrapperData{
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Double temp;
        @AuraEnabled
        public String description;
        public wrapperData(fromJSON parseData){
            this.name = parseData.name;
            this.temp = parseData.main.temp;
            this.description = parseData.weather.description;
        }
    }
 
    public class fromJSON{
        public cls_coord coord;
        public cls_weather weather;
        public String base;
        public cls_main main;
        public Integer visibility;
        public cls_wind wind;
        public cls_clouds clouds;
        public Integer dt;
        public cls_sys sys;
        public Integer timezone;
        public Integer id;
        public String name;
        public Integer cod;
    }
    public class cls_coord {
        public Double lon;
        public Double lat;
    }
    public class cls_weather {
        public Integer id;
        public String main;
        public String description;
        public String icon;
    }
    public class cls_main {
        public Double temp;
        public Double feels_like;
        public Double temp_min;
        public Double temp_max; 
        public Integer pressure;
        public Integer humidity;
    }
    public class cls_wind {
        public Double speed;
        public Integer deg;
        public Double gust; 
    }
    public class cls_clouds {
        public Integer all;
    }
    public class cls_sys {
        public Integer type;
        public Integer id;
        public String country; 
        public Integer sunrise; 
        public Integer sunset; 
    }

    public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }
}